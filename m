Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3KVIxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:53:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30424 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3KVIxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:53:45 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-18-528f1b97b189
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>, fanofcode.li@samsung.com
References: 
In-reply-to: 
Subject: [f2fs-dev] [PATCH] f2fs: remove unneeded code in punch_hole
Date: Fri, 22 Nov 2013 16:52:50 +0800
Message-id: <000201cee760$58df9f10$0a9edd30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7nX4LVAyOC9UTrStuYb8Cw1/GOlwAAIMXQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jQd3p0v1BBtMvqVl83trIbnF9118m
	i0uL3C327D3JYnF51xw2i9aF55kd2Dx2L/jM5NG3ZRWjx+dNcgHMUVw2Kak5mWWpRfp2CVwZ
	p+7/ZiqYwlYx+dEFpgbGnyxdjJwcEgImErcer2CFsMUkLtxbz9bFyMUhJDCdUaLtxTRGCOcH
	o8Sx+xcZQarYBFQklnf8ZwKxRQQUJTa838AOUsQssIlR4vLF50AOB1AHt8Tq5iCQGk4BHol1
	fzqZQWxhAReJF/PegdksAqoSD4//BbN5BSwl5qzoYISwBSV+TL4Hdh2zgIZE/6INbBC2vMTm
	NW+ZIS5VkNhx9jUjxA1GEtPvT2SEqBGX2HjkFssERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQ
	XFCclJ5rqFecmFtcmpeul5yfu4kRHA/PpHYwrmywOMQowMGoxMMrYNMXJMSaWFZcmXuIUYKD
	WUmE99dVoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbG
	rXaBR5/+FOzYoaylspLz9Mkz/5+cW2d1fFmf+nO9OY9MfZOucxi673158Km6V6X7zFQ+2WLd
	VOZr2xrcN2xWPKa179vTVJ9Gk6MB19inTxPV6aj7unm5zfPId21BbtX9p20S15tnL/n610Us
	0m2DhOHL6dw893QzjdlvTzl88O+Nl5JTZY56KLEUZyQaajEXFScCAKAS/yGDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because FALLOC_FL_PUNCH_HOLE flag must be ORed with FALLOC_FL_KEEP_SIZE 
in fallocate, so we could remove the useless 'keep size' branch code which 
will never be excuted in punch_hole.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Fan Li <fanofcode.li@samsung.com>
---
 fs/f2fs/file.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7d714f4..0087d2a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -499,12 +499,6 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len, int mode)
 		}
 	}
 
-	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-		i_size_read(inode) <= (offset + len)) {
-		i_size_write(inode, offset);
-		mark_inode_dirty(inode);
-	}
-
 	return ret;
 }
 
-- 
1.7.9.5

