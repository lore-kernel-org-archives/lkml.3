Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaGVMOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:14:12 -0400
Received: from mail.zhinst.com ([212.126.164.98]:41478 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbaGVMNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:13:54 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mailbox/omap: Use module_platform_driver
Date: Tue, 22 Jul 2014 14:13:43 +0200
Message-Id: <1406031223-15759-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the module_platform_driver to omit module init/exit boilerplate code.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/mailbox/mailbox-omap1.c | 13 +------------
 drivers/mailbox/mailbox-omap2.c | 13 +------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
index 9001b76..735aeef 100644
--- a/drivers/mailbox/mailbox-omap1.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -184,18 +184,7 @@ static struct platform_driver omap1_mbox_driver = {
 	},
 };
 
-static int __init omap1_mbox_init(void)
-{
-	return platform_driver_register(&omap1_mbox_driver);
-}
-
-static void __exit omap1_mbox_exit(void)
-{
-	platform_driver_unregister(&omap1_mbox_driver);
-}
-
-module_init(omap1_mbox_init);
-module_exit(omap1_mbox_exit);
+module_platform_driver(omap1_mbox_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("omap mailbox: omap1 architecture specific functions");
diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 42d2b89..a9dedf0 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -337,18 +337,7 @@ static struct platform_driver omap2_mbox_driver = {
 	},
 };
 
-static int __init omap2_mbox_init(void)
-{
-	return platform_driver_register(&omap2_mbox_driver);
-}
-
-static void __exit omap2_mbox_exit(void)
-{
-	platform_driver_unregister(&omap2_mbox_driver);
-}
-
-module_init(omap2_mbox_init);
-module_exit(omap2_mbox_exit);
+module_platform_driver(omap2_mbox_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("omap mailbox: omap2/3/4 architecture specific functions");
-- 
2.0.1


