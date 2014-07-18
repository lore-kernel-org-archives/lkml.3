Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161163AbaGRNPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:15:51 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17838 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161147AbaGRNPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 158/170] ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
Date: Fri, 18 Jul 2014 14:12:43 +0200
Message-Id: <2b1a4617a88931112443052c735efb046bb1e926.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 94d4c066a4ff170a2671b1a9b153febbf36796f6 upstream.

We are spending a lot of time explaining to users what this error
means.  Let's try to improve the message to avoid this problem.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/mballoc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 08ddfdac955c..502f0fd71470 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -751,8 +751,8 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 
 	if (free != grp->bb_free) {
 		ext4_grp_locked_error(sb, group, 0, 0,
-				      "%u clusters in bitmap, %u in gd; "
-				      "block bitmap corrupt.",
+				      "block bitmap and bg descriptor "
+				      "inconsistent: %u vs %u free clusters",
 				      free, grp->bb_free);
 		/*
 		 * If we intend to continue, we consider group descriptor
-- 
2.0.0

