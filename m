Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbaIQVsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:48:36 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39490 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbaIQVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:48:31 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] eeepc-laptop: store_cpufv: return error if set_acpi fails
Date: Wed, 17 Sep 2014 23:47:27 +0200
Message-Id: <1410990447-3210-10-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
References: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The result of set_acpi is left unchecked, but it may return errors. If
one occurs, send the error to the caller. There's no reason to lie about
it, if set_acpi fails.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 875a43f..3f6c762 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -388,7 +388,9 @@ static ssize_t cpufv_store(struct device *dev,
 		return rv;
 	if (value < 0 || value >= c.num)
 		return -EINVAL;
-	set_acpi(eeepc, CM_ASL_CPUFV, value);
+	rv = set_acpi(eeepc, CM_ASL_CPUFV, value);
+	if (rv)
+		return rv;
 	return count;
 }
 
-- 
2.1.0

