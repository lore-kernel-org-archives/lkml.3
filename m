Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaLOPGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:06:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38427 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaLOO1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 051/168] fold swapping ->d_name.hash into switch_names()
Date: Mon, 15 Dec 2014 14:25:05 +0000
Message-Id: <1418653622-21105-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a28ddb87cdddb0db57466ba7f59f831002f4340c upstream.

and do it along with ->d_name.len there

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
[ luis: used Stefan's backport to 3.16 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/dcache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f9cec9d4dbe0..8a7dcc895d99 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2441,7 +2441,7 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
 			}
 		}
 	}
-	swap(dentry->d_name.len, target->d_name.len);
+	swap(dentry->d_name.hash_len, target->d_name.hash_len);
 }
 
 static void dentry_lock_for_move(struct dentry *dentry, struct dentry *target)
@@ -2540,7 +2540,6 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
 
 	/* Switch the names.. */
 	switch_names(dentry, target);
-	swap(dentry->d_name.hash, target->d_name.hash);
 
 	/* ... and switch the parents */
 	if (IS_ROOT(dentry)) {
@@ -2679,7 +2678,6 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 	dparent = dentry->d_parent;
 
 	switch_names(dentry, anon);
-	swap(dentry->d_name.hash, anon->d_name.hash);
 
 	dentry->d_parent = dentry;
 	list_del_init(&dentry->d_u.d_child);
-- 
2.1.3

