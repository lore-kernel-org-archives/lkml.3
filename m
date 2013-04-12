Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3DNVcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 17:32:48 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61031 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3DNVcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 17:32:47 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] fs: reiserfs: Use kstrdup function
Date: Fri, 12 Apr 2013 04:20:18 +0300
Message-Id: <1365729618-24397-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kstrdup function instead of kmalloc and strcpy.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 fs/reiserfs/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 194113b..f8a23c3 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1147,8 +1147,7 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 							 "on filesystem root.");
 					return 0;
 				}
-				qf_names[qtype] =
-				    kmalloc(strlen(arg) + 1, GFP_KERNEL);
+				qf_names[qtype] = kstrdup(arg, GFP_KERNEL);
 				if (!qf_names[qtype]) {
 					reiserfs_warning(s, "reiserfs-2502",
 							 "not enough memory "
@@ -1156,7 +1155,6 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 							 "quotafile name.");
 					return 0;
 				}
-				strcpy(qf_names[qtype], arg);
 				if (qtype == USRQUOTA)
 					*mount_options |= 1 << REISERFS_USRQUOTA;
 				else
-- 
1.7.9.5

