Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaDRGAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 02:00:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42810 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDRGAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 02:00:36 -0400
X-AuditID: cbfee690-b7f266d00000287c-89-5350bf82999e
Message-id: <1397800711.7727.34.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: fix to enable readahead last NAT block
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Apr 2014 14:58:31 +0900
In-reply-to: <000901cf5ab4$d64171a0$82c454e0$@samsung.com>
References: <000101cf5a1e$5c051770$140f4650$@samsung.com>
 <1397787344.7727.32.camel@kjgkr> <000901cf5ab4$d64171a0$82c454e0$@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zfd2m/QHBBtOecFn8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytg25Q5bwQHBijcd
	6Q2MO/i6GDk5JARMJO68WM0GYYtJXLi3Hsjm4hASWMYosWDrGVaYovlnDoAVCQksYpR4sYkH
	ougVo0TXxxVMIAleAR2JJ88XMoPYwgI+Er/aZrF0MXJwsAloS2zebwDRqyjxdv9dsJkiAkoS
	v+YvArOZBTIl7jXNAGtlEVCVaN27EizOKWAl0bq6BeqgLkaJ+a/awBL8AqIShxduZ4ZoVpeY
	NG8RM8ShShK72zvZIeLyEpvXvGWGuE1Q4sfkeywggyQE9rFL7Ds2hxFim4DEt8mHwA6VEJCV
	2HQAao6kxMEVN1gmMErMQrJiFpKxs5CMXcDIvIpRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMj
	JOIm7GC8d8D6EGMy0MqJzFKiyfnAiM0riTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBkbX1twJYkuiA6qjey5xFzVcPrdhfXXIrEampAn3KzV3FStP
	suhmfRfS/bF1W+3ppQmsgvwxS7fXnuhgPV+S+2Mu80eGE7d4T83ME4maL+Kxv6jn4p3Vm6eJ
	/TMIvxhy1+iB0D0unWetlT9TPropcM9yie0Wuz13T5NGt9WRGpMdeqWeXiaLw5RYijMSDbWY
	i4oTARnCeVrOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd2m/QHBBmsvs1r8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zYNuUOW8EBwYo3HekNjDv4uhg5OSQETCTmnznABmGLSVy4tx7MFhJYxCjx
	YhNPFyMXkP2KUaLr4womkASvgI7Ek+cLmUFsYQEfiV9ts1i6GDk42AS0JTbvN4DoVZR4u/8u
	K4gtIqAk8Wv+IjCbWSBT4l7TDLBWFgFVida9K8HinAJWEq2rW9ggdnUxSsx/1QaW4BcQlTi8
	cDszRLO6xKR5i5ghDlWS2N3eyQ4Rl5fYvOYtM8RtghI/Jt9jmcAoNAtJyywkZbOQlC1gZF7F
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzPz6R3MK5qsDjEKMDBqMTDe+Grf7AQa2JZcWXu
	IUYJDmYlEV7l0oBgId6UxMqq1KL8+KLSnNTiQ4zJQO9NZJYSTc4Hppq8knhDYxMzI0sjMwsj
	E3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamCsfdJ8fuu2D19X5R2y8NdOt1kp8Dzl
	Hae6/q6r/Q+mKhVetH7PyLNUZhqLWPWy3HV3pI53SQo8buCcG57I+WZqwPYf/ns/V/JUlS6p
	NvLdanbHzDJi4bkCeWbjPW7Tls+YbFq8xMf1g6Kdq+9jlzXKzqLKZ8zSqmfNZD128t7fpdf+
	cb5PaJRSYinOSDTUYi4qTgQAlnKJ8CsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got it.
The patch is like this.
Thanks,

>From 5f7a3bcf0df10bbb47a6e4409cc92ba8e6090674 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Fri, 18 Apr 2014 11:14:37 +0900
Subject: [PATCH] f2fs: add available_nids to fix handling max_nid
correctly

This patch introduces available_nids for alloc_nids() and fixes max_nid
for
build_free_nids() and scan_nat_pages().

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Reviewed-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h | 1 +
 fs/f2fs/node.c | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 55152de..556d06b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -244,6 +244,7 @@ static inline void set_raw_extent(struct extent_info
*ext,
 struct f2fs_nm_info {
 	block_t nat_blkaddr;		/* base disk address of NAT */
 	nid_t max_nid;			/* maximum possible node ids */
+	nid_t available_nids;		/* maximum available node ids */
 	nid_t next_scan_nid;		/* the next nid to be scanned */
 	unsigned int ram_thresh;	/* control the memory footprint */
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 837f5fd..6ebdba1 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1447,7 +1447,7 @@ bool alloc_nid(struct f2fs_sb_info *sbi, nid_t
*nid)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *i = NULL;
 retry:
-	if (unlikely(sbi->total_valid_node_count + 1 >= nm_i->max_nid))
+	if (unlikely(sbi->total_valid_node_count + 1 > nm_i->available_nids))
 		return false;
 
 	spin_lock(&nm_i->free_nid_list_lock);
@@ -1859,8 +1859,10 @@ static int init_node_manager(struct f2fs_sb_info
*sbi)
 	nat_segs = le32_to_cpu(sb_raw->segment_count_nat) >> 1;
 	nat_blocks = nat_segs << le32_to_cpu(sb_raw->log_blocks_per_seg);
 
+	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks;
+
 	/* not used nids: 0, node, meta, (and root counted as valid node) */
-	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks - 3;
+	nm_i->available_nids = nm_i->max_nid - 3;
 	nm_i->fcnt = 0;
 	nm_i->nat_cnt = 0;
 	nm_i->ram_thresh = DEF_RAM_THRESHOLD;
-- 
1.8.4.474.g128a96c




-- 
Jaegeuk Kim
Samsung

