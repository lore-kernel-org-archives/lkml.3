Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab3EGNyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:54:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42522 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab3EGNmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 094/118] ext4: fix online resizing for ext3-compat file systems
Date: Tue,  7 May 2013 14:39:00 +0100
Message-Id: <1367933964-1564-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit c5c72d814cf0f650010337c73638b25e6d14d2d4 upstream.

Commit fb0a387dcdc restricts block allocations for indirect-mapped
files to block groups less than s_blockfile_groups.  However, the
online resizing code wasn't setting s_blockfile_groups, so the newly
added block groups were not available for non-extent mapped files.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/resize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index a2289bf..097a7b0 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1255,6 +1255,8 @@ static void ext4_update_super(struct super_block *sb,
 
 	/* Update the global fs size fields */
 	sbi->s_groups_count += flex_gd->count;
+	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
+			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
-- 
1.8.1.2

