Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaDQJVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:21:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12047 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaDQJVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:21:07 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-db-534f9d01d11a
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: fix to enable readahead last NAT block
Date: Thu, 17 Apr 2014 17:20:18 +0800
Message-id: <000101cf5a1e$5c051770$140f4650$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9aHjM+I20hTYujQNuV8Q69ZCg2LQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQV3Guf7BBnc3Sltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldGzawVjwU/WipZt
	R9kbGN+wdDFyckgImEgsPDSHCcIWk7hwbz1bFyMXh5DAdEaJex8XMEM4PxglbjccZQSpYhNQ
	kVje8R+sQ0RAUWLD+w3sIDazQKbEvaYZzCC2sICHxOXb18DqWQRUJRq+rwOq5+DgFbCU2Hwu
	HyTMKyAo8WPyPRaIVi2J9TuPM0HY8hKb17xlhjhIQWLH2deMEKv0JL6c2gpVIy6x8cgtlgmM
	ArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4kJ9J7WBc2WBx
	iFGAg1GJh3eCun+wEGtiWXFl7iFGCQ5mJRHeJb1AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwH
	Wq0DhQTSE0tSs1NTC1KLYLJMHJxSDYxGGz5oFr6doRq8+UXJr1LtFf9+f5QPOdrba37q1pPD
	VjrCbMZO6UvSNN2yey6mG+v/Twit2X7tyIdvp1Y1bDAymvX15OEAziiPQ0++r539U/Wsxhtr
	5eJW7u6Fcu/n9q/Pa/o/fUNW3941Z4NMjnKZ3Ni/LL2Nbdfa1rQ3U9fbZlnc8P6xNdxKiaU4
	I9FQi7moOBEAC7b4sGACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We skip reading last one of NAT blocks when readahead them since max value of
valid block is calculated incorrectly. We should fix this problem to avoid it.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 744c68b..75189b1 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -77,7 +77,7 @@ inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 {
 	switch (type) {
 	case META_NAT:
-		return NM_I(sbi)->max_nid / NAT_ENTRY_PER_BLOCK;
+		return (NM_I(sbi)->max_nid + 3) / NAT_ENTRY_PER_BLOCK;
 	case META_SIT:
 		return SIT_BLK_CNT(sbi);
 	case META_SSA:
-- 
1.7.9.5


