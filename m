Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3EVAPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:15:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25150 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab3EVAOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:14:46 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-72-519c0df4c7d9
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: fix to handle do_recover_data errors
Date: Wed, 22 May 2013 09:13:32 +0900
Message-id: <1369181612-15777-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369181612-15777-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369181612-15777-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zQ90vvHMCDRY9Y7W4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PS1QbGgoPiFT/X
	9LE2MHYIdzFyckgImEgcXdHFDmGLSVy4t56ti5GLQ0hgGaPElRNfWGGKPj3rZ4dILGKU6Oj+
	zwzhtDFJnLzTBeRwcLAJaEts3m8A0iAiwCyxYOp5RpAaZoEJjBL/F71nAUkIC9hLHD/6iQ2k
	nkVAVeJtow5ImFfAXeL01mYWiGW6Eqv/Pwe7iFPAQ2LH4stgcSGgmvs7ZjJD1Hxnk3jYBGaz
	CAhIfJt8iAVkpISArMSmA1AlkhIHV9xgmcAovICRYRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+
	7iZGSMD27mC8fcD6EGMy0LiJzFKiyfnAgM8riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PXi1qjtT6rnJ8/5y0LDZ8tlaXoMnX1O3HzHUxPTBZu
	k116+9Hfqdxriv++6dj6/fXi76rnTwZqT5dX9V7Cf0m+Q+3PTFvB1afijEvEYrOZj015lsDh
	9sxvz5JVv3cu+BLHVlEQbzONv+uIQMfTLYcnXnxq1XB9u9W25x1NbrLu+yRE9m1bc6lFiaU4
	I9FQi7moOBEAcsSMJ24CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd0vvHMCDb68ZLS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj0tUGxoKD4hU/1/SxNjB2CHcxcnJICJhIfHrWzw5hi0lcuLeerYuRi0NI
	YBGjREf3f2YIp41J4uSdLiCHg4NNQFti834DkAYRAWaJBVPPM4LUMAtMYJT4v+g9C0hCWMBe
	4vjRT2wg9SwCqhJvG3VAwrwC7hKntzazQCzTlVj9/znYYk4BD4kdiy+DxYWAau7vmMk8gZF3
	ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgiHgmvYNxVYPFIUYBDkYlHt4HtbMDhVgT
	y4orcw8xSnAwK4nwGl4DCvGmJFZWpRblxxeV5qQWH2JMBjpqIrOUaHI+MFrzSuINjU3MjCyN
	zCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoHR+yeP6U3PFTvznM48nxfMVtKh
	HB4fXaaQ8fGw837/Qulpf/+FSH0u//TGrFZ9/fKJs+391rbI7RM9fnnuN+5FT+WjphgpCUhM
	W5n3arPVyyNWW2sy+UydHi5+y/i44wSnd6j5DcV1tQlvFmXcs2c6wmHV3MIlu/3ggaWam3cX
	XTpjWNnx0XiVEktxRqKhFnNRcSIAx4KQU8wCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds error handling codes of check_index_in_prev_nodes and its
caller, do_recover_data.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index eceb665..dcd8e86 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -188,7 +188,7 @@ static void destroy_fsync_dnodes(struct f2fs_sb_info *sbi,
 	}
 }
 
-static void check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
+static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 			block_t blkaddr, struct dnode_of_data *dn)
 {
 	struct seg_entry *sentry;
@@ -205,7 +205,7 @@ static void check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 
 	sentry = get_seg_entry(sbi, segno);
 	if (!f2fs_test_bit(blkoff, sentry->cur_valid_map))
-		return;
+		return 0;
 
 	/* Get the previous summary */
 	for (i = CURSEG_WARM_DATA; i <= CURSEG_COLD_DATA; i++) {
@@ -232,16 +232,18 @@ static void check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 		tdn.node_page = dn->inode_page;
 		tdn.ofs_in_node = sum.ofs_in_node;
 		truncate_data_blocks_range(&tdn, 1);
-		return;
+		return 0;
 	} else if (dn->nid == nid) {
 		struct dnode_of_data tdn = *dn;
 		tdn.ofs_in_node = sum.ofs_in_node;
 		truncate_data_blocks_range(&tdn, 1);
-		return;
+		return 0;
 	}
 
 	/* Get the node page */
 	node_page = get_node_page(sbi, nid);
+	if (IS_ERR(node_page))
+		return PTR_ERR(node_page);
 	bidx = start_bidx_of_node(ofs_of_node(node_page)) +
 					le16_to_cpu(sum.ofs_in_node);
 	ino = ino_of_node(node_page);
@@ -250,10 +252,11 @@ static void check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 	/* Deallocate previous index in the node page */
 	inode = f2fs_iget(sbi->sb, ino);
 	if (IS_ERR(inode))
-		return;
+		return PTR_ERR(inode);
 
 	truncate_hole(inode, bidx, bidx + 1);
 	iput(inode);
+	return 0;
 }
 
 static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
@@ -301,7 +304,9 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 			}
 
 			/* Check the previous node page having this index */
-			check_index_in_prev_nodes(sbi, dest, &dn);
+			err = check_index_in_prev_nodes(sbi, dest, &dn);
+			if (err)
+				goto err;
 
 			set_summary(&sum, dn.nid, dn.ofs_in_node, ni.version);
 
@@ -324,13 +329,14 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	set_page_dirty(dn.node_page);
 
 	recover_node_page(sbi, dn.node_page, &sum, &ni, blkaddr);
+err:
 	f2fs_put_dnode(&dn);
 	mutex_unlock_op(sbi, ilock);
 
 	f2fs_msg(sbi->sb, KERN_NOTICE, "recover_data: ino = %lx, "
-			"recovered_data = %d blocks",
-			inode->i_ino, recovered);
-	return 0;
+			"recovered_data = %d blocks, err = %d",
+			inode->i_ino, recovered, err);
+	return err;
 }
 
 static int recover_data(struct f2fs_sb_info *sbi,
-- 
1.8.1.3.566.gaa39828

