Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3CKI3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:29:19 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43166 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3CKI3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:29:16 -0400
From: Claudiu Ghioc <claudiughioc@gmail.com>
To: raven@themaw.net
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Claudiu Ghioc <claudiu.ghioc@gmail.com>
Subject: [PATCH] fs: sparse warning fix for autofs4/root.c
Date: Mon, 11 Mar 2013 10:29:04 +0200
Message-Id: <1362990544-4365-1-git-send-email-claudiu.ghioc@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the sparse warning:
*   "fs/autofs4/root.c:411:5: warning:
    symbol 'autofs4_d_manage' was not declared.
    Should it be static?"

Signed-off-by: Claudiu Ghioc <claudiu.ghioc@gmail.com>
---
 fs/autofs4/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 9bd1625..085da86 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -408,7 +408,7 @@ done:
 	return NULL;
 }
 
-int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
+static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-- 
1.7.10.4

