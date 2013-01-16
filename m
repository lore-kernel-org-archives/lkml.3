Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab3APP7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:59:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35737 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3APP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Alexis R. Cortes" <alexis.cortes@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 025/222] usb: host: xhci: Stricter conditional for Z1 system models for Compliance Mode Patch
Date: Wed, 16 Jan 2013 13:53:45 -0200
Message-Id: <1358351822-7675-26-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Alexis R. Cortes" <alexis.cortes@ti.com>

commit b0e4e606ff6ff26da0f60826e75577b56ba4e463 upstream.

This minor patch creates a more stricter conditional for the Z1 sytems for applying
the Compliance Mode Patch, this to avoid the quirk to be applied to models that
contain a "Z1" in their dmi product string but are different from Z1 systems.

This patch should be backported to stable kernels as old as 3.2, that
contain the commit 71c731a296f1b08a3724bd1b514b64f1bda87a23 "usb: host:
xhci: Fix Compliance Mode on SN65LVPE502CP Hardware"

Signed-off-by: Alexis R. Cortes <alexis.cortes@ti.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index f67634b..77da9a0 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -480,7 +480,7 @@ static bool compliance_mode_recovery_timer_quirk_check(void)
 	if (strstr(dmi_product_name, "Z420") ||
 			strstr(dmi_product_name, "Z620") ||
 			strstr(dmi_product_name, "Z820") ||
-			strstr(dmi_product_name, "Z1"))
+			strstr(dmi_product_name, "Z1 Workstation"))
 		return true;
 
 	return false;
-- 
1.7.9.5

