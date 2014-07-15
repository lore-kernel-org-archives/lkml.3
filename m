Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbaGORPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:15:21 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41292 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbaGORCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:11 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 33/94] ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
Date: Tue, 15 Jul 2014 20:00:48 +0300
Message-Id: <1405443709-15288-33-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

We are spending a lot of time explaining to users what this error
means.  Let's try to improve the message to avoid this problem.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 fs/ext4/mballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7f72f50..2dcb936 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -752,8 +752,8 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 
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
1.7.10.4

