Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3ETKxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab3ETKxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 059/115] ext4: add check for inodes_count overflow in new resize ioctl
Date: Mon, 20 May 2013 11:50:59 +0100
Message-Id: <1369047116-9378-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 3f8a6411fbada1fa482276591e037f3b1adcf55b upstream.

Addresses-Red-Hat-Bugzilla: #913245

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/resize.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 097a7b0..d0ba1a9 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1680,6 +1680,10 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 		return 0;
 
 	ext4_get_group_no_and_offset(sb, n_blocks_count - 1, &n_group, &offset);
+	if (n_group > (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
+		ext4_warning(sb, "resize would cause inodes_count overflow");
+		return -EINVAL;
+	}
 	ext4_get_group_no_and_offset(sb, o_blocks_count - 1, &o_group, &offset);
 
 	n_desc_blocks = (n_group + EXT4_DESC_PER_BLOCK(sb)) /
-- 
1.8.1.2

