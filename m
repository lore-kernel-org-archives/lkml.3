Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbaCSA0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:26:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38115 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaCSA0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:26:18 -0400
X-AuditID: cbfee68f-b7f156d00000276c-07-5328e425d0fb
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/5] f2fs: introduce nr_pages_to_write for segment alignment
Date: Wed, 19 Mar 2014 09:24:24 +0900
Message-id: <1395188665-4175-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1395188665-4175-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1395188665-4175-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zI13VJxrBBrf221hc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbHx3RWWglWqFTPu
	/mJqYLwm18XIySEhYCLx/ucbFghbTOLCvfVsXYxcHEICyxglnh4+ytrFyAFWdGMHB0R8EaNE
	w46pLBBOJ5PEvfkLWECK2AS0JTbvNwAZJCLALLFg6nlGkBpmgQmMEv8XvQfbICzgI9F+6Qor
	iM0ioCqx6dkedhCbV8BN4vyKbVBXaEtsez6REcTmFHCX+HL3DFhcCKhm1+vjTCBDJQR+s0nM
	nPYfapCAxLfJh1ggLpWV2HSAGWKOpMTBFTdYJjAKL2BkWMUomlqQXFCclF5krFecmFtcmpeu
	l5yfu4kRErL9OxjvHrA+xJgMNG4is5Rocj4w5PNK4g2NzYwsTE1MjY3MLc1IE1YS573/MClI
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6M0n65QVoNN2bSoyfy9zVcyuTUST0QbH5Gt+uni
	cSf+3LFf7Zd9q6YwcMWy/4rO1040kfjd1GoYEGXpNIkvdnmq5cOnBxLvFy7ZWp/1dZeQc1Tu
	C4cjAVMtUphiJBYKZbHmZCln7aucF5BcuvNYZ1z6bMuDJ91qJLJb2wsn8Z/XMD/S8axEiaU4
	I9FQi7moOBEA6RV5nm8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAV3VJxrBBn+uWFhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix8d0VloJVqhUz7v5iamC8JtfFyMEhIWAicWMHRxcjJ5ApJnHh3nq2LkYu
	DiGBRYwSDTumskA4nUwS9+YvYAFpYBPQlti83wCkQUSAWWLB1POMIDXMAhMYJf4ves8CkhAW
	8JFov3SFFcRmEVCV2PRsDzuIzSvgJnF+xTYWiG3aEtueT2QEsTkF3CW+3D0DFhcCqtn1+jjT
	BEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI+KZ9A7GVQ0WhxgFOBiVeHgPRGkE
	C7EmlhVX5h5ilOBgVhLhFb4LFOJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YLTmlcQbGpuY
	GVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOj0t4yrrJjx6+vdG2zPb+b
	9/f+JTI2XIYnn29YfvVryTqetiu2POt373dUifFeekd2WsqDaz76GyoPFuZLv/CXmWmztIJB
	Tz7ff2tR7Hvmp5LstuzGN2bmbnr1f3W2rll/1CTVZZlrvkbzXeM8ZHjlfqWYn46hrZ11gFDU
	Bruma9e/1uwRfbpUiaU4I9FQi7moOBEA+mblh8wCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces nr_pages_to_write to align page writes to the segment
or other operational unit size, which can be tuned according to the system
environment.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 11 ++++++-----
 fs/f2fs/data.c       | 12 +++---------
 fs/f2fs/node.c       |  8 +++-----
 fs/f2fs/segment.h    | 24 ++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index aef32f3..2a00c94 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -187,18 +187,19 @@ static int f2fs_write_meta_pages(struct address_space *mapping,
 				struct writeback_control *wbc)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
-	int nrpages = nr_pages_to_skip(sbi, META);
-	long written;
+	long diff, written;
 
 	/* collect a number of dirty meta pages and write together */
-	if (wbc->for_kupdate || get_pages(sbi, F2FS_DIRTY_META) < nrpages)
+	if (wbc->for_kupdate ||
+		get_pages(sbi, F2FS_DIRTY_META) < nr_pages_to_skip(sbi, META))
 		goto skip_write;
 
 	/* if mounting is failed, skip writing node pages */
 	mutex_lock(&sbi->cp_mutex);
-	written = sync_meta_pages(sbi, META, nrpages);
+	diff = nr_pages_to_write(sbi, META, wbc);
+	written = sync_meta_pages(sbi, META, wbc->nr_to_write);
 	mutex_unlock(&sbi->cp_mutex);
-	wbc->nr_to_write -= written;
+	wbc->nr_to_write = max((long)0, wbc->nr_to_write - written - diff);
 	return 0;
 
 skip_write:
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3bc3809..b0c923a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -844,8 +844,6 @@ redirty_out:
 	return AOP_WRITEPAGE_ACTIVATE;
 }
 
-#define MAX_DESIRED_PAGES_WP	4096
-
 static int __f2fs_writepage(struct page *page, struct writeback_control *wbc,
 			void *data)
 {
@@ -862,7 +860,7 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	bool locked = false;
 	int ret;
-	long excess_nrtw = 0, desired_nrtw;
+	long diff;
 
 	/* deal with chardevs and other special file */
 	if (!mapping->a_ops->writepage)
@@ -872,11 +870,7 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 			get_dirty_dents(inode) < nr_pages_to_skip(sbi, DATA))
 		goto skip_write;
 
-	if (wbc->nr_to_write < MAX_DESIRED_PAGES_WP) {
-		desired_nrtw = MAX_DESIRED_PAGES_WP;
-		excess_nrtw = desired_nrtw - wbc->nr_to_write;
-		wbc->nr_to_write = desired_nrtw;
-	}
+	diff = nr_pages_to_write(sbi, DATA, wbc);
 
 	if (!S_ISDIR(inode->i_mode)) {
 		mutex_lock(&sbi->writepages);
@@ -890,7 +884,7 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 
 	remove_dirty_dir_inode(inode);
 
-	wbc->nr_to_write -= excess_nrtw;
+	wbc->nr_to_write = max((long)0, wbc->nr_to_write - diff);
 	return ret;
 
 skip_write:
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 7cc146b..5e9c38e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1202,7 +1202,7 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
-	long nr_to_write = wbc->nr_to_write;
+	long diff;
 
 	/* balancing f2fs's metadata in background */
 	f2fs_balance_fs_bg(sbi);
@@ -1211,12 +1211,10 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 	if (get_pages(sbi, F2FS_DIRTY_NODES) < nr_pages_to_skip(sbi, NODE))
 		goto skip_write;
 
-	/* if mounting is failed, skip writing node pages */
-	wbc->nr_to_write = 3 * max_hw_blocks(sbi);
+	diff = nr_pages_to_write(sbi, NODE, wbc);
 	wbc->sync_mode = WB_SYNC_NONE;
 	sync_node_pages(sbi, 0, wbc);
-	wbc->nr_to_write = nr_to_write - (3 * max_hw_blocks(sbi) -
-						wbc->nr_to_write);
+	wbc->nr_to_write = max((long)0, wbc->nr_to_write - diff);
 	return 0;
 
 skip_write:
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index bbd9761..9fc46ee 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -683,3 +683,27 @@ static inline int nr_pages_to_skip(struct f2fs_sb_info *sbi, int type)
 	else
 		return 0;
 }
+
+/*
+ * When writing pages, it'd better align nr_to_write for segment size.
+ */
+static inline long nr_pages_to_write(struct f2fs_sb_info *sbi, int type,
+					struct writeback_control *wbc)
+{
+	long nr_to_write, desired;
+
+	if (wbc->sync_mode != WB_SYNC_NONE)
+		return 0;
+
+	nr_to_write = wbc->nr_to_write;
+
+	if (type == DATA)
+		desired = 4096;
+	else if (type == NODE)
+		desired = 3 * max_hw_blocks(sbi);
+	else
+		desired = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+
+	wbc->nr_to_write = desired;
+	return desired - nr_to_write;
+}
-- 
1.8.4.474.g128a96c

