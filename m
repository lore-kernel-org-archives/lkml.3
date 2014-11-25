Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaKYKuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:50:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaKYKnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephan Mueller <smueller@chronox.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 236/254] quirk for Lenovo Yoga 3: no rfkill switch
Date: Tue, 25 Nov 2014 10:39:46 +0000
Message-Id: <1416912004-5928-237-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Mueller <smueller@chronox.de>

commit 725c7f619e20f5051bba627fca11dc107c2a93b1 upstream.

The Yoga 3 does not contain any physical rfkill switch. Therefore
disable the rfkill switch identically to the Yoga 2 approach.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index b4c495a62eec..96056e29b673 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -831,6 +831,13 @@ static struct dmi_system_id rfkill_blacklist[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Yoga 2 11"),
 		},
 	},
+	{
+		.ident = "Lenovo Yoga 3 Pro 1370",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo YOGA 3 Pro-1370"),
+		},
+	},
 	{}
 };
 
-- 
2.1.0

