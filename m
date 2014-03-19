Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbaCSA0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:26:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38115 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaCSA0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:26:15 -0400
X-AuditID: cbfee68e-b7f566d000002344-9c-5328e4256e87
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/5] f2fs: increase pages_skipped when skipping writepages
Date: Wed, 19 Mar 2014 09:24:23 +0900
Message-id: <1395188665-4175-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1395188665-4175-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1395188665-4175-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zI13VJxrBBmu/m1hc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHqXE7BGbGKVwuE
	GhjPCXUxcnJICJhIPL65iwnCFpO4cG89WxcjF4eQwDJGiemfDrPCFL1YcocJIrGIUeLVnqfM
	EE4nk8S9+QtYuhg5ONgEtCU27zcAaRARYJZYMPU8I0gNs8AERon/i96zgCSEBbwkXvZcApvK
	IqAqMXf7PjCbV8BNYu3ebywQ27Qltj2fyAhicwq4S3y5ewYsLgRUs+v1cbArJAS+s0ncPHEF
	apCAxLfJh8COkBCQldh0gBlijqTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKRXnJhbXJqXrpec
	n7uJERKwfTsYbx6wPsSYDDRuIrOUaHI+MODzSuINjc2MLExNTI2NzC3NSBNWEudd9DApSEgg
	PbEkNTs1tSC1KL6oNCe1+BAjEwenVANj/9nAJ4/tBbfv5vUzqN8gXsyjKyvIXMD65vHNfpeT
	bgdlJsh+vbbCOC5/3n2NTyaKnY9yPofYxpfmm5uttYmKZvu+a/aiDeeCfvOcm6efzvhnSYvU
	mYPSXT3xvg63/DuYeCIdbfuV06r8w/hvxO/JnFm83+95d+3nPVM9pm/Ifj5H54f9CxklluKM
	REMt5qLiRACEVWVxbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAV3VJxrBBmvXGFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx6lxOwRmxilcLhBoYzwl1MXJySAiYSLxYcocJwhaTuHBvPVsXIxeHkMAi
	RolXe54yQzidTBL35i9g6WLk4GAT0JbYvN8ApEFEgFliwdTzjCA1zAITGCX+L3rPApIQFvCS
	eNlziRXEZhFQlZi7fR+YzSvgJrF27zcWiG3aEtueT2QEsTkF3CW+3D0DFhcCqtn1+jjTBEbe
	BYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4+GZ9A7GVQ0WhxgFOBiVeHgPRGkEC7Em
	lhVX5h5ilOBgVhLhFb4LFOJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YKzmlcQbGpuYGVka
	mVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVANjPrPik4JFqS1eVWsKxVMfCD97
	r+IcvybK4V3mja7nInZrl39VE1YXeDktvSt0Nf+r7eV+6y+fDL1nGWci0b/Oi6/92Cf+rrl2
	Djnt679Y8x+fVDxd1G65asZ0VT3PLdu8HuYlTympzbZzlOmT0Sp9m1eYarPn9pm/aX9/7v6x
	QzXN44L9VGslluKMREMt5qLiRAA3L2DWywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch increases pages_skipped when skipping writepages.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 11 ++++++-----
 fs/f2fs/data.c       |  6 +++++-
 fs/f2fs/node.c       |  6 +++++-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 1f52b70..aef32f3 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -190,12 +190,9 @@ static int f2fs_write_meta_pages(struct address_space *mapping,
 	int nrpages = nr_pages_to_skip(sbi, META);
 	long written;
 
-	if (wbc->for_kupdate)
-		return 0;
-
 	/* collect a number of dirty meta pages and write together */
-	if (get_pages(sbi, F2FS_DIRTY_META) < nrpages)
-		return 0;
+	if (wbc->for_kupdate || get_pages(sbi, F2FS_DIRTY_META) < nrpages)
+		goto skip_write;
 
 	/* if mounting is failed, skip writing node pages */
 	mutex_lock(&sbi->cp_mutex);
@@ -203,6 +200,10 @@ static int f2fs_write_meta_pages(struct address_space *mapping,
 	mutex_unlock(&sbi->cp_mutex);
 	wbc->nr_to_write -= written;
 	return 0;
+
+skip_write:
+	wbc->pages_skipped += get_pages(sbi, F2FS_DIRTY_META);
+	return 0;
 }
 
 long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index e3b7cfa..3bc3809 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -870,7 +870,7 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 
 	if (S_ISDIR(inode->i_mode) && wbc->sync_mode == WB_SYNC_NONE &&
 			get_dirty_dents(inode) < nr_pages_to_skip(sbi, DATA))
-		return 0;
+		goto skip_write;
 
 	if (wbc->nr_to_write < MAX_DESIRED_PAGES_WP) {
 		desired_nrtw = MAX_DESIRED_PAGES_WP;
@@ -892,6 +892,10 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 
 	wbc->nr_to_write -= excess_nrtw;
 	return ret;
+
+skip_write:
+	wbc->pages_skipped += get_dirty_dents(inode);
+	return 0;
 }
 
 static int f2fs_write_begin(struct file *file, struct address_space *mapping,
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index cb514f1..7cc146b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1209,7 +1209,7 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 
 	/* collect a number of dirty node pages and write together */
 	if (get_pages(sbi, F2FS_DIRTY_NODES) < nr_pages_to_skip(sbi, NODE))
-		return 0;
+		goto skip_write;
 
 	/* if mounting is failed, skip writing node pages */
 	wbc->nr_to_write = 3 * max_hw_blocks(sbi);
@@ -1218,6 +1218,10 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 	wbc->nr_to_write = nr_to_write - (3 * max_hw_blocks(sbi) -
 						wbc->nr_to_write);
 	return 0;
+
+skip_write:
+	wbc->pages_skipped += get_pages(sbi, F2FS_DIRTY_NODES);
+	return 0;
 }
 
 static int f2fs_set_node_page_dirty(struct page *page)
-- 
1.8.4.474.g128a96c

