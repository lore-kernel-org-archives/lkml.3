Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3DPFh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 01:37:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57346 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3DPFhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 01:37:55 -0400
X-AuditID: cbfee690-b7f656d0000007e3-f8-516ce3b1173d
Date: Tue, 16 Apr 2013 05:37:53 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] swiotlb: Replace dma_length to sg_dma_len()  macro
To: konrad.wilk@oracle.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130416052655212@eunb.song
Msgkey: 20130416052655212@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130416052655212@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25826040.283591366090672676.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zju7GxzmBBq3LxCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGr1WTmAueCFQ0H/jD3MC4QqCLkZNDSEBFouX/d8YuRg4OCQET
	ibcXJEDCEgJiEhfurWfrYuQCKlnGKPHv5zImiISJxOevr1ghEvMZJa6sPAqWYBFQlbj54gQL
	iM0moC3x9ssDVhBbWMBZ4sejO8wgC0QE5CWO7QJbwCzgKPHoMkgY5AZ5icmnL7OD2LwCghIn
	Zz5hgdilJHGoaSETRFxZ4s6faVBxCYlZ0y+wQti8EjPan0LF5SSmfV3DDGFLS5yftYER5pnF
	3x9Dxfkljt3ewQTxL6/Ek/vBMGN2b/7CBmELSEw9cxCqVV1iVeteqFY+iTUL37LAjNl1ajkz
	TO/9LXOZIN5SlJjS/ZAdwtaS+PJjHxu6t3gFnCR27LvBNoFReRaS1Cwk7bOQtCOrWcDIsopR
	NLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjJClM2MF474D1IcZkYIxMZJYSTc4HJpW8knhDYzMj
	C1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDKTv1X+W5Veeg+
	trz9imk7eCLX8vzOzjj25smaJOMNdXUvNL3cGjMPCgvNZM5QCTHNEo1m3ZMrmHDinDbHPOfD
	jhbFAif2LpeT6WpIeTpbOiLxD/fnBL1p9fNv5/o6VviZbLb/dkdu2apapq4Za2YGPPvVq+bC
	ci/+fbGUxQRW07nm/9kUG5RYijMSDbWYi4oTAULZaisgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2dN2Nj3MCDY6+Era4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	Gb9WTWIueCJQ0XzgD3MD4wqBLkZODiEBFYmW/98ZQWwJAROJz19fsULYYhIX7q1n62LkAqqZ
	zyhxZeVRJpAEi4CqxM0XJ1hAbDYBbYm3Xx6ANQgLOEv8eHSHuYuRg0NEQF7i2C4JkDCzgKPE
	o8sgYZBd8hKTT19mB7F5BQQlTs58wgKxS0niUNNCJoi4ssSdP9Og4hISs6ZfgLqHV2JG+1Oo
	uJzEtK9rmCFsaYnzszYwwty8+PtjqDi/xLHbO5hAzgHpfXI/GGbM7s1f2CBsAYmpZw5CtapL
	rGrdC9XKJ7Fm4VsWmDG7Ti1nhum9v2UuE8RbihJTuh+yQ9haEl9+7GND9xavgJPEjn032CYw
	ys1CkpqFpH0WknZkNQsYWVYxiqYWJBcUJ6VXmOgVJ+YWl+al6yXn525iBCeoZ0t2MDZcsD7E
	KMDBqMTDGyCfEyjEmlhWXJl7iFGCg1lJhFd9OVCINyWxsiq1KD++qDQntfgQYzIw/iYyS4km
	5wOTZ15JvKGxgbGhoaW5gamhkQVpwkrivM9arQOFBNITS1KzU1MLUotgtjBxcEo1MN6QucJw
	vCOE8f2qC6kbu99ZnRM6I1XS53oy5WuJKuvNUymh3zRO734nOHm39Dp9z3DR64cOJ0rkbpwR
	k7oq1f2b+T4Z5ToN82d+91Z++jv5u6LiBG5TllShXw9vfpHw/zhdsejwltTe/J2KDXsE10qK
	Woa8mrDuMo8Dp/nc7kybBDNV/aVBH5RYijMSDbWYi4oTASfbwiKUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3G5c4RK000658


This patch replace dma_length in "lib/swiotlb.c" to sg_dma_len() macro, because the build error can occur
if CONFIG_NEED_SG_DMA_LENGTH is not set, and CONFIG_SWIOTLB is set.
I confirmed compile only. 

Singed-off-by: EunBong Song <eunb.song@samsung.com>

---
 lib/swiotlb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index bfe02b8..7b16f4a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -859,13 +859,13 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 				swiotlb_full(hwdev, sg->length, dir, 0);
 				swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
 						       attrs);
-				sgl[0].dma_length = 0;
+				sg_dma_len(sgl) = 0;
 				return 0;
 			}
 			sg->dma_address = phys_to_dma(hwdev, map);
 		} else
 			sg->dma_address = dev_addr;
-		sg->dma_length = sg->length;
+		sg_dma_len(sg) = sg->length;
 	}
 	return nelems;
 }
@@ -893,7 +893,7 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i)
-		unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
+		unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir);
 
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -923,7 +923,7 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i)
 		swiotlb_sync_single(hwdev, sg->dma_address,
-				    sg->dma_length, dir, target);
+				    sg_dma_len(sg), dir, target);
 }
 
 void
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
