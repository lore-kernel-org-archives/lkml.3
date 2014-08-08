Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbaHHUuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:50:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379AbaHHUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:50:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 068/259] ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
Date: Fri,  8 Aug 2014 13:38:11 -0700
Message-Id: <1407530482-4483-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 94d4c066a4ff170a2671b1a9b153febbf36796f6 upstream.

We are spending a lot of time explaining to users what this error
means.  Let's try to improve the message to avoid this problem.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/mballoc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 08ddfda..502f0fd 100644
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
1.9.1

