Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3CXXlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 19:41:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49427 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3CXXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 19:41:08 -0400
X-AuditID: cbfee690-b7f656d0000007e3-fc-514f8f115172
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/4] f2fs: remain nat cache entries for further free nid
 allocation
Date: Mon, 25 Mar 2013 08:40:13 +0900
Message-id: <1364168414-12815-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zQ13Bfv9Ag92fBCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytjzOa7gCkdF1+uv
	bA2MzexdjJwcEgImEm9vb2GGsMUkLtxbz9bFyMUhJLCMUeLM7+UsXYwcYEXHH1lCxKczSnw+
	/pwVwmljkrh4fRETSBGbgLbE5v0GIINEBJglFkw9zwhSwywwgVHi/6L3LCAJYYFQiUv/+8C2
	sQioSjz/8o0VxOYVcJeY1/CWDeIKXYnV/5+zg8zkFPCQ+PvFGSQsBFTSfPYp2EwJge9sEnMu
	f2aBmCMg8W3yIahDZSU2HYB6RlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vO
	z93ECAnXCTsY7x2wPsSYDDRuIrOUaHI+MNzzSuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cC4xFtVqTG9Kn3D41mrJP06J1x+dflMTbZaQufVB7ay
	nyYkr8lrszm8SH3xROYUi0b9suDcwHXb07zel++0OGq6bE382RdHbDJWxputEjR2WqPJfcv7
	1TojsY4AK4734do+t+a0PzsqYXzaKDGAt6O2IM9W/FjfD1bnP88ui5xVz63Je5DL6qDEUpyR
	aKjFXFScCAATJlztbQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQV3Bfv9Ag7XzeC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zY8zmu4ApHRdfrr2wNjM3sXYwcHBICJhLHH1l2MXICmWISF+6tZ+ti5OIQ
	EpjOKPH5+HNWCKeNSeLi9UVMIA1sAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUASwgKh
	Epf+9zGD2CwCqhLPv3xjBbF5Bdwl5jW8ZYPYpiux+v9zsCM4BTwk/n5xBgkLAZU0n33KOIGR
	dwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Gh4JrWDcWWDxSFGAQ5GJR5egRr/QCHW
	xLLiytxDjBIczEoivG96gEK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD4zUvJJ4Q2MTMyNL
	IzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg1DhbHPZpRsCcSlOxjsalBoxV
	vs++zGRdtmLmclWOuqcOpzVLvp8IVTn8c4/8jvlhmn6brfjzO8Rtl3rdFnvy38givqzq+YX3
	btLv0rdYf/6x/8ukkzWrPoiU9vx2Vzgy2zFl1yLWZWFOk/e2vDyxfHpoofbM7dHqK+efk+lc
	5mHZWKJhVhH1X4mlOCPRUIu5qDgRAH/F4c3KAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the checkpoint flow, the f2fs investigates the total nat cache entries.
Previously, if an entry has NULL_ADDR, f2fs drops the entry and adds the
obsolete nid to the free nid list.
However, this free nid will be reused sooner, resulting in its nat entry miss.
In order to avoid this, we don't need to drop the nat cache entry at this moment.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f7b03ba..0177f94 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1621,11 +1621,11 @@ flush_now:
 			nid_in_journal(sum, offset) = cpu_to_le32(nid);
 		}
 
-		if (nat_get_blkaddr(ne) == NULL_ADDR) {
+		if (nat_get_blkaddr(ne) == NULL_ADDR &&
+					!add_free_nid(NM_I(sbi), nid)) {
 			write_lock(&nm_i->nat_tree_lock);
 			__del_from_nat_cache(nm_i, ne);
 			write_unlock(&nm_i->nat_tree_lock);
-			add_free_nid(NM_I(sbi), nid);
 		} else {
 			write_lock(&nm_i->nat_tree_lock);
 			__clear_nat_cache_dirty(nm_i, ne);
-- 
1.8.1.3.566.gaa39828

