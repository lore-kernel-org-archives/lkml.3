Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3APBNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:13:14 -0500
Received: from norkia.v3.sk ([91.210.183.14]:57096 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128Ab3APBNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:13:02 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 2/2] mtd: Allow removal of partitioning modules
Date: Wed, 16 Jan 2013 02:12:50 +0100
Message-Id: <1358298770-20286-2-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1358298770-20286-1-git-send-email-lkundrak@v3.sk>
References: <1358298770-20286-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/mtd/ar7part.c     |    6 ++++++
 drivers/mtd/cmdlinepart.c |    6 ++++++
 drivers/mtd/ofpart.c      |    7 +++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ar7part.c b/drivers/mtd/ar7part.c
index 9453931..a98899f 100644
--- a/drivers/mtd/ar7part.c
+++ b/drivers/mtd/ar7part.c
@@ -145,7 +145,13 @@ static int __init ar7_parser_init(void)
 	return register_mtd_parser(&ar7_parser);
 }
 
+static void __exit ar7_parser_exit(void)
+{
+	deregister_mtd_parser(&ar7_parser);
+}
+
 module_init(ar7_parser_init);
+module_exit(ar7_parser_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(	"Felix Fietkau <nbd@openwrt.org>, "
diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index a2bb2ea..8689a77 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -382,7 +382,13 @@ static int __init cmdline_parser_init(void)
 	return register_mtd_parser(&cmdline_parser);
 }
 
+static void __exit cmdline_parser_exit(void)
+{
+	deregister_mtd_parser(&cmdline_parser);
+}
+
 module_init(cmdline_parser_init);
+module_exit(cmdline_parser_exit);
 
 MODULE_PARM_DESC(mtdparts, "Partitioning specification");
 module_param(mtdparts, charp, 0);
diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
index d9127e2..d407e0b 100644
--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -171,7 +171,14 @@ out:
 	return rc;
 }
 
+static void __exit ofpart_parser_exit(void)
+{
+	deregister_mtd_parser(&ofpart_parser);
+	deregister_mtd_parser(&ofoldpart_parser);
+}
+
 module_init(ofpart_parser_init);
+module_exit(ofpart_parser_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Parser for MTD partitioning information in device tree");
-- 
1.7.1

