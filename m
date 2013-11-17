Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab3KQUtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 15:49:31 -0500
Received: from mail-gg0-f180.google.com ([209.85.161.180]:49305 "EHLO
	mail-gg0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3KQUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 15:49:24 -0500
X-Greylist: delayed 1164 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Nov 2013 15:49:23 EST
From: Erico Nunes <nunes.erico@gmail.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Erico Nunes <nunes.erico@gmail.com>
Subject: [PATCH] jffs2: fix sparse errors: directive in argument list
Date: Sun, 17 Nov 2013 18:18:33 -0200
Message-Id: <1384719513-27386-1-git-send-email-nunes.erico@gmail.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following errors reported when running sparse:
fs/jffs2/super.c:378:1: error: directive in argument list
fs/jffs2/super.c:380:1: error: directive in argument list
fs/jffs2/super.c:381:1: error: directive in argument list
fs/jffs2/super.c:383:1: error: directive in argument list
---
 fs/jffs2/super.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 0defb1c..ec9e16f 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -361,6 +361,14 @@ MODULE_ALIAS_FS("jffs2");
 static int __init init_jffs2_fs(void)
 {
 	int ret;
+	const char desc[] = "version 2.2."
+#ifdef CONFIG_JFFS2_FS_WRITEBUFFER
+		" (NAND)"
+#endif
+#ifdef CONFIG_JFFS2_SUMMARY
+		" (SUMMARY) "
+#endif
+		" © 2001-2006 Red Hat, Inc.";
 
 	/* Paranoia checks for on-medium structures. If we ask GCC
 	   to pack them with __attribute__((packed)) then it _also_
@@ -374,14 +382,7 @@ static int __init init_jffs2_fs(void)
 	BUILD_BUG_ON(sizeof(struct jffs2_raw_inode) != 68);
 	BUILD_BUG_ON(sizeof(struct jffs2_raw_summary) != 32);
 
-	pr_info("version 2.2."
-#ifdef CONFIG_JFFS2_FS_WRITEBUFFER
-	       " (NAND)"
-#endif
-#ifdef CONFIG_JFFS2_SUMMARY
-	       " (SUMMARY) "
-#endif
-	       " © 2001-2006 Red Hat, Inc.\n");
+	pr_info("%s\n", desc);
 
 	jffs2_inode_cachep = kmem_cache_create("jffs2_i",
 					     sizeof(struct jffs2_inode_info),
-- 
1.8.4.2

