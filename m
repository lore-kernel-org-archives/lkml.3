Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3J1CUC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 22:20:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3J1CT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 22:19:58 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-d0-526dc9cd05e3
From: =?utf-8?B?7J207LC966eM?= <cm224.lee@samsung.com>
To: "'Chao Yu'" <chao2.yu@samsung.com>, jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <000401ced092$28087a90$78196fb0$@samsung.com>
In-reply-to: <000401ced092$28087a90$78196fb0$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with
 bitops for better mount performance
Date: Mon, 28 Oct 2013 11:19:56 +0900
Message-id: <003501ced384$31fb7530$95f25f90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ6i6Dfb3BtsZq0jPxXbIKcIyyc4Zix8JSg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zA92zJ3ODDHatZbf43/SRzeL6rr9M
	FpcWuVvs2XuSxeLyrjlsFq0LzzM7sHnsXvCZyaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgy
	7h+axVKwVLTi1ZOrbA2MzwS7GDk5JARMJHqXXWaEsMUkLtxbz9bFyMUhJLCMUeLSpkcsMEWf
	th9kgkgsYpRY8GYblPOXUaJ3QwM7SBWbgJnE6W8nwWwRAVuJuRtvMYMUMQvMZpRYuHoHE0hC
	SMBS4nHbE9YuRg4OTgErie7J6SBhYYEiiT8t+5lBbBYBVYlFu3vBbF6g8kO9L1ggbEGJH5Pv
	sYC0MguoS0yZkgsSZhbQlnjy7gIrxKEKEjvOvmaEOMFIYsL5B0wQNSIS+168g/ryGrvEgrOO
	EKsEJL5NPgQ2UkJAVmLTAWaIEkmJgytusExglJiFZPEshMWzkCyehWTBAkaWVYyiqQXJBcVJ
	6UUmesWJucWleel6yfm5mxghsTlhB+O9A9aHGJOBtk9klhJNzgfGdl5JvKGxmZGFqYmpsZG5
	pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MMqd/5hteNpwUQJ3Za5uwLEm
	5k/WG3dGc5xptnU/ycnhu/+Fzv5VhqaL9jVNOPL6cupBx7bq++4NugFSLKnmjROv7PczmRvj
	aniSLUb/ktCCbd/fRd28r7pC5ETgllshM/463U3sYVH8a9ocePuEv+yiL3djbjGZz7/FvP+b
	55t9MmE6PaaXdymxFGckGmoxFxUnAgB5EXM34wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jAd2zJ3ODDI6uZLL43/SRzeL6rr9M
	FpcWuVvs2XuSxeLyrjlsFq0LzzM7sHnsXvCZyaNvyypGj8+b5AKYoxoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM+4fmsVSsFS04tWTq2wNjM8Euxg5OSQETCQ+bT/IBGGL
	SVy4t56ti5GLQ0hgEaPEgjfbmCCcv4wSvRsa2EGq2ATMJE5/OwlmiwjYSszdeIsZpIhZYDaj
	xMLVO8BGCQlYSjxue8LaxcjBwSlgJdE9OR0kLCxQJPGnZT8ziM0ioCqxaHcvmM0LVH6o9wUL
	hC0o8WPyPRaQVmYBdYkpU3JBwswC2hJP3l1ghThUQWLH2deMECcYSUw4/4AJokZEYt+Ld4wT
	GIVmIZk0C2HSLCSTZiHpWMDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOPafSe9gXNVg
	cYhRgINRiYd3w9rcICHWxLLiytxDjBIczEoivHwVQCHelMTKqtSi/Pii0pzU4kOMyUB/TmSW
	Ek3OB6alvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgtFhZ
	H7Bkqce2ews1+/c0+W1KTtqp1zsjasFur2e6LTevTbTrylrL4+x9XezNs8upai4vn91nKOO/
	nZ1Vcl7xWVTJTgHF0omlAt360k+2B9s6t3q8W9/RNIm90Mxtq/9W8XeuXy2eRAqVtISw9KYt
	aql1XH5aPyzNeeoCV0676QwLTAvSeK4rsRRnJBpqMRcVJwIAkVjRYEEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To check whether bitmap are all zeros or all ones, I think memcmp is more neat.
But I don't know exactly performance gap between memcmp and find_next_bit.


-----Original Message-----
From: Chao Yu [mailto:chao2.yu@samsung.com] 
Sent: Thursday, October 24, 2013 5:21 PM
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org; '谭姝'; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with bitops for better mount performance

Previously, check_block_count check valid_map with bit data type in common scenario that sit has all ones or zeros bitmap, it makes low mount performance.
So let's check the special bitmap with integer data type instead of the bit one.

v2:
    use find_next_bit_le/find_next_zero_bit_le for better performance and readable as Jaegeuk suggested.

Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Signed-off-by: Tan Shu <shu.tan@samsung.com>
Signed-off-by: Yu Chao <chao2.yu@samsung.com>
---
 fs/f2fs/segment.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index 7f94d78..d25b6af 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -552,6 +552,23 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
 	/* check boundary of a given segment number */
 	BUG_ON(segno > end_segno);
 
+	/* check all ones or zeros valid_map */
+	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
+		int pos = find_next_bit_le(&raw_sit->valid_map,
+					sbi->blocks_per_seg,
+					0);
+		if (pos != sbi->blocks_per_seg)
+			BUG();
+		return;
+	} else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
+		int pos = find_next_zero_bit_le(&raw_sit->valid_map,
+					sbi->blocks_per_seg,
+					0);
+		if (pos != sbi->blocks_per_seg)
+			BUG();
+		return;
+	}
+
 	/* check bitmap with valid block count */
 	for (i = 0; i < sbi->blocks_per_seg; i++)
 		if (f2fs_test_bit(i, raw_sit->valid_map))
--
1.7.9.5


------------------------------------------------------------------------------
October Webinars: Code for Performance
Free Intel webinars can help you accelerate application performance.
Explore tips for MPI, OpenMP, advanced profiling, and more. Get the most from 
the latest Intel processors and coprocessors. See abstracts and register >
http://pubads.g.doubleclick.net/gampad/clk?id=60135991&iu=/4140/ostg.clktrk
_______________________________________________
Linux-f2fs-devel mailing list
Linux-f2fs-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

