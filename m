Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaBEUW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:22:28 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48537 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaBEUHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:38 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 175/213] ext4: online defrag is not supported for journaled files
Date: Wed, 5 Feb 2014 15:02:10 -0500
Message-ID: <1391630568-49251-176-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f066055a3449f0e5b0ae4f3ceab4445bead47638 upstream.

Proper block swap for inodes with full journaling enabled is
truly non obvious task. In order to be on a safe side let's
explicitly disable it for now.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/move_extent.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index deff4a5085e8..6764168776bf 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1209,7 +1209,12 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
-
+	/* TODO: This is non obvious task to swap blocks for inodes with full
+	   jornaling enabled */
+	if (ext4_should_journal_data(orig_inode) ||
+	    ext4_should_journal_data(donor_inode)) {
+		return -EINVAL;
+	}
 	/* Protect orig and donor inodes against a truncate */
 	ret1 = mext_inode_double_lock(orig_inode, donor_inode);
 	if (ret1 < 0)
-- 
1.8.5.2

