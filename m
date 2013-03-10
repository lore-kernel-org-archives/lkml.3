Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3CJNHU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:07:20 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:49879 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3CJNHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:07:18 -0400
From: Ionut-Gabriel Radu <ihonius@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: jack@suse.cz, artem.bityutskiy@linux.intel.com, shaggy@kernel.org,
        akpm@linux-foundation.org, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ionut-Gabriel Radu <ihonius@gmail.com>
Subject: [PATCH] reiserfs: Use kstrdup instead of kmalloc/strcpy
Date: Sun, 10 Mar 2013 15:06:23 +0200
Message-Id: <1362920783-17093-1-git-send-email-ihonius@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ionut-Gabriel Radu <ihonius@gmail.com>
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
1.7.10.4

