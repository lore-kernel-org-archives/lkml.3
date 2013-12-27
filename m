Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3L0ECb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 23:02:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3L0EBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 23:01:37 -0500
X-AuditID: cbfee690-b7f266d00000287c-93-52bcfb9d5c55
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/6] f2fs: convert inline_data for punch_hole
Date: Fri, 27 Dec 2013 13:00:16 +0900
Message-id: <1388116820-15038-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zY925v/cEGaz/ZG5xfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8blz3tZCj5xVfzb
	dou5gfExRxcjJ4eEgInEywfXGSFsMYkL99azdTFycQgJLGOU+He7lRWm6NqeqewQiemMEjtn
	bmMBSQgJNDNJtM3k7WLk4GAT0JbYvN8AJCwiwCyxYOp5RpB6ZoEJjBL/F70HqxcWsJVYdWQX
	M4jNIqAqcfnMUzYQm1fAXeJC01yoZdoS255PBLuIU8BDov3nfXaIXe4SX9cfZAIZKiHwm01i
	4p13rBCDBCS+TT7EAnKEhICsxKYDzBBzJCUOrrjBMoFReAEjwypG0dSC5ILipPQiE73ixNzi
	0rx0veT83E2MkJCdsIPx3gHrQ4zJQOMmMkuJJucDQz6vJN7Q2MzIwtTE1NjI3NKMNGElcV61
	R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhNfvp4/M/lrys02q0Y+2Z2QYem/rrPD07k
	ms5Q01y/q1hF/nANj7mTibzCYsf4PE+PL/MTvzamL3LcWNq4IWizf7fX98WfGMOZusuZ7LIt
	bt7ZlCm9N4hjT4Jm+8dFpuWXbQ3vrX+4i6n2IqOqtee3wurkW898d4moLkwNZ78r/OcPU+u8
	JCWW4oxEQy3mouJEAM/DekRvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd25v/cEGWxeZWJxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPG5c97WQo+cVX823aLuYHxMUcXIyeHhICJxLU9U9khbDGJC/fWs3UxcnEI
	CUxnlNg5cxsLSEJIoJlJom0mbxcjBwebgLbE5v0GIGERAWaJBVPPM4LUMwtMYJT4v+g9WL2w
	gK3EqiO7mEFsFgFVictnnrKB2LwC7hIXmuayQizTltj2fCIjiM0p4CHR/vM+O8Qud4mv6w8y
	TWDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOCKeSe9gXNVgcYhRgINRiYfXYcOe
	ICHWxLLiytxDjBIczEoivJ+vAIV4UxIrq1KL8uOLSnNSiw8xJgNdNZFZSjQ5HxiteSXxhsYm
	ZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAyOP1aa6bso+E5Y/7dx3f
	cDVn3j17T75JedkEgQURUkonPv1cV3ynIPNc3FzJU9XvAjQlWe7dVL6cplWSWV8kee7U5KdV
	7Jwd0ffWR0+QCHUIfuGvp1X4UrLrdILAui+pz5LX7Pxc+Pf8g4xH/xMEAp91uhwrPpd1Qij5
	YoNdqO7SN0zrBOb6KLEUZyQaajEXFScCAK4ALgbMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the punch_hole(), let's convert inline_data all the time for simplicity and
to avoid potential deadlock conditions.
It is pretty much not a big deal to do this.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7ef2d6a..f64a1c8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -462,25 +462,9 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	loff_t off_start, off_end;
 	int ret = 0;
 
-	if (f2fs_has_inline_data(inode)) {
-		struct page *page;
-		unsigned flags = AOP_FLAG_NOFS;
-		page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
-		if (IS_ERR(page))
-			return PTR_ERR(page);
-		if (offset + len > MAX_INLINE_DATA) {
-			ret = f2fs_convert_inline_data(inode, page, flags);
-			f2fs_put_page(page, 1);
-			if (ret)
-				return ret;
-		} else {
-			zero_user_segment(page, offset, offset + len);
-			SetPageUptodate(page);
-			set_page_dirty(page);
-			f2fs_put_page(page, 1);
-			return ret;
-		}
-	}
+	ret = f2fs_convert_inline_data(inode, NULL, AOP_FLAG_NOFS);
+	if (ret)
+		return ret;
 
 	pg_start = ((unsigned long long) offset) >> PAGE_CACHE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_CACHE_SHIFT;
-- 
1.8.4.474.g128a96c

