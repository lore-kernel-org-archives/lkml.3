Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3FDWpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:45:14 -0400
Received: from 1wt.eu ([62.212.114.60]:35947 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab3FDWpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:45:10 -0400
Message-Id: <20130604172135.450014158@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 124/184] ext4: online defrag is not supported for journaled
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 files

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit f066055a3449f0e5b0ae4f3ceab4445bead47638 upstream.

Proper block swap for inodes with full journaling enabled is
truly non obvious task. In order to be on a safe side let's
explicitly disable it for now.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/move_extent.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index fe81390..da25617 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1208,7 +1208,12 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
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
1.7.12.2.21.g234cd45.dirty



