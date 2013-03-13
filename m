Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab3CMRBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:01:43 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:50682 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3CMRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:01:41 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] overlayfs: Print info when (un)loaded into the logs
Date: Wed, 13 Mar 2013 18:01:28 +0100
Message-Id: <1363194088-5795-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.2.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 fs/overlayfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 482c26f..92b9ad5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -675,11 +675,13 @@ MODULE_ALIAS_FS("overlayfs");
 static int __init ovl_init(void)
 {
 	return register_filesystem(&ovl_fs_type);
+	printk(KERN_INFO "overlayfs: loaded\n");
 }
 
 static void __exit ovl_exit(void)
 {
 	unregister_filesystem(&ovl_fs_type);
+	printk(KERN_INFO "overlayfs: unloaded\n");
 }
 
 module_init(ovl_init);
-- 
1.8.2.rc3

