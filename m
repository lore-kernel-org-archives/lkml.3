Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaDRCRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:17:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58434 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDRCRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:17:48 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-10-53508b4afd3b
Message-id: <1397787344.7727.32.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix to enable readahead last NAT block
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Apr 2014 11:15:44 +0900
In-reply-to: <000101cf5a1e$5c051770$140f4650$@samsung.com>
References: <000101cf5a1e$5c051770$140f4650$@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zfV2v7oBgg/urjCz+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZdzcs4qpYAdvxbzD
	79gbGH9xdTFyckgImEh8+jmdCcIWk7hwbz1bFyMXh5DAMkaJY+saWLoYOcCKNs9lgYhPZ5RY
	c+4kO0iDkMArRom5m61BbF4BHYnFM/tYQGxhAR+J8y9WsYL0sgloS2zebwBRrijxdv9dVhBb
	REBJ4tf8RWA2s0CmxL2mGcwgNouAqsT7T8fB4pwCVhI3/1xggui1lJj6YxXYeH4BUYnDC7cz
	Q/SqS0yat4gZ4n4lid3tnewQcXmJzWveMkOcJijxY/I9sPslBA6xS9z6swNqmYDEt8mHoH6U
	ldh0AGqOpMTBFTdYJjBKzEKyYhaSsbOQjF3AyLyKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cT
	IyTeencw3j5gfYgxGWjlRGYp0eR8YLzmlcQbGpsZWZiamBobmVuakSasJM6b9DApSEggPbEk
	NTs1tSC1KL6oNCe1+BAjEwenVAOjYU2MUDdDQJ7U36W+2gWL+OUOXXzs7M2yt23JPo++pIRj
	Avd6PzKxfhG8kztx/i4PibUSTcI5P8u2P7aRqnyxTbZLapHj5f67+45brrB4Z/mwrXlx7LMr
	Z5gsrm58zy8l/qalZe5Rp+y8icY3T5RoHoiIefv3pZZLm72R1aPEtc4HF/ZrGtkqsRRnJBpq
	MRcVJwIAOtNreM0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQV2v7oBgg1nz9Cz+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWbc3LOKqWAHb8W8w+/YGxh/cXUxcnBICJhIbJ7L0sXICWSKSVy4t56ti5GL
	Q0hgOqPEmnMn2UESQgKvGCXmbrYGsXkFdCQWz+wDaxAW8JE4/2IVK8gcNgFtic37DSDKFSXe
	7r/LCmKLCChJ/Jq/CMxmFsiUuNc0gxnEZhFQlXj/6ThYnFPASuLmnwtMEL2WElN/rAIbzy8g
	KnF44XZmiF51iUnzFjFD3Kkksbu9kx0iLi+xec1bZojTBCV+TL7HMoFRaBaSlllIymYhKVvA
	yLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzian0nvYFzVYHGIUYCDUYmH98JX/2Ah1sSy
	4srcQ4wSHMxKIrzKpQHBQrwpiZVVqUX58UWlOanFhxiTgb6byCwlmpwPTDR5JfGGxiZmRpZG
	ZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCYqhh17GHddQW93ujNb3h75kW1
	73u666e0TInyjDpJPgf1x/0zt1ufkntc4LnnyWoDpi28Eidj7qYsuBW38Q9vaBqrfsRrCa2D
	L///stJKKnTavmjaWYdcz/aHd5eLtcsysfHx/T2RfOPsCaV3yS43XdWXTmq46nB88mILpuBb
	u95+ZeTjs81WYinOSDTUYi4qTgQA/IwqySoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

How about this?

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
index 837f5fd..5fb484c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1447,7 +1447,7 @@ bool alloc_nid(struct f2fs_sb_info *sbi, nid_t
*nid)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *i = NULL;
 retry:
-	if (unlikely(sbi->total_valid_node_count + 1 >= nm_i->max_nid))
+	if (unlikely(sbi->total_valid_node_count + 1 >= nm_i->available_nids))
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

