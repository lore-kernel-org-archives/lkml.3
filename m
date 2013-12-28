Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3L1M4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 07:56:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22574 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3L1M4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 07:56:15 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-5e-52beca6d1b73
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH] f2fs: avoid to left uninitialized data in page when
 read inline data
Date: Sat, 28 Dec 2013 20:55:39 +0800
Message-id: <000201cf03cc$30b2ce30$92186a90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8DzAZOJA8FaJzsRcOxv/m0ZpDRFg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd3cU/uCDN4/sra4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2Nq92ymgtVsFR8+
	tDM2MM5i7WLk5JAQMJHYd3oWM4QtJnHh3no2EFtIYBGjxMTz6V2MXED2D0aJjlOTWUASbAIq
	Ess7/jOB2CICihIb3m9gB7GZBTIl5ryeDDZUWCBJYlX/PLA4i4CqxIeTp8GG8gpYSnTPbmSF
	sAUlfky+xwLRqyWxfudxJghbXmLzmrdQBylI7Dj7mhFil57Ep4blbBA14hIbj9ximcAoMAvJ
	qFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYID+Zn0DsZVDRaHGAU4
	GJV4eBN+7A0SYk0sK67MPcQowcGsJMKbfnxfkBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63W
	gUIC6YklqdmpqQWpRTBZJg5OqQbG1ffYDveKPS0KnTH3meDjWqasqK2SzOuEHdrXHC/m/9Ne
	917JQe8Wg4Dm2f752fzHzxw5OjNa118w+qrErSu8RfkRxUo1n5VyVtzJtIksv/hHNbjT4IPc
	P56kY2WJ9Tp9epPy9i3Ss/F0vq7CG/a9XURj+fK5ryfuLDq4KcmSacsMHdVb70uVWIozEg21
	mIuKEwFjvxoYYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We left uninitialized data in the tail of page when we read an inline data
page. So let's initialize left part of the page excluding inline data region.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/inline.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 0e940ce..eebda9b 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -48,8 +48,7 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 	if (IS_ERR(ipage))
 		return PTR_ERR(ipage);
 
-	zero_user_segment(page, INLINE_DATA_OFFSET,
-				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+ 	zero_user_segment(page, MAX_INLINE_DATA, PAGE_CACHE_SIZE);
 
 	/* Copy the whole inline data block */
 	src_addr = inline_data_addr(ipage);
-- 
1.7.9.5

