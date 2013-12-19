Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3LSPEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:33 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59073 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3LSPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:29 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 12/38] arm: s5pv210: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:23 +0100
Message-Id: <1387465429-3568-13-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/arm/mach-s5pv210/common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-s5pv210/common.c b/arch/arm/mach-s5pv210/common.c
index 26027a2..81f43ae 100644
--- a/arch/arm/mach-s5pv210/common.c
+++ b/arch/arm/mach-s5pv210/common.c
@@ -267,8 +267,14 @@ core_initcall(s5pv210_core_init);
 
 int __init s5pv210_init(void)
 {
+	int rc = 0;
+
 	printk(KERN_INFO "S5PV210: Initializing architecture\n");
-	return device_register(&s5pv210_dev);
+	rc = device_register(&s5pv210_dev);
+	if (rc)
+		put_device(&s5pv210_dev);
+
+	return rc;
 }
 
 /* uart registration process */
-- 
1.8.3.1

