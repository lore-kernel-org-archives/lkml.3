Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab3HQAH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:07:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3HPWjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 094/133] ext4: fix retry handling in ext4_ext_truncate()
Date: Fri, 16 Aug 2013 15:33:56 -0700
Message-Id: <1376692475-28413-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 94eec0fc3520c759831763d866421b4d60b599b4 upstream.

We tested for ENOMEM instead of -ENOMEM.   Oops.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 728c8f6..c3db941 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4329,7 +4329,7 @@ void ext4_ext_truncate(struct inode *inode)
 retry:
 	err = ext4_es_remove_extent(inode, last_block,
 				    EXT_MAX_BLOCKS - last_block);
-	if (err == ENOMEM) {
+	if (err == -ENOMEM) {
 		cond_resched();
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 		goto retry;
-- 
1.8.1.2

