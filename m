Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaFLF0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 01:26:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48704 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbaFLF0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 01:26:02 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-4d-539939e7aba2
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/3] f2fs: avoid unneeded SetPageUptodate in
 f2fs_write_end
Date: Thu, 12 Jun 2014 13:25:01 +0800
Message-id: <000101cf85fe$cc3b27d0$64b17770$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+F/Y2M3vdpcY2hR3yqK5MGlXO1QQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd3nljODDTparSyerJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI7isklJzcksSy3St0vgynj5qb7gLEtF2+S0
	Bsa7zF2MnBwSAiYSLzp/MkHYYhIX7q1n62Lk4hASWMQosXj+DSjnB6PEke2L2UGq2ARUJJZ3
	/AfrEAGyDy26DBZnFsiUuNc0A2yqsEC4xKz5SxlBbBYBVYmdH4+ygdi8ApYSexa0MUHYghI/
	Jt9jgejVkli/8zgThC0vsXnNW6jrFCR2nH3NCLFLT+LJjD+sEDXiEhuP3GKZwCgwC8moWUhG
	zUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsP4mdQOxpUNFocYBTgYlXh4
	I+pnBAuxJpYVV+YeYpTgYFYS4XU8DxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2x
	JDU7NbUgtQgmy8TBKdXA6Jl4eP50B8auCnZVjX/7OI4u7vD+ZyxR+iBAJ1Xr+N+uP3dueC1z
	vzajsHU9o6X2n8mZPCdj0zoXdPOqPOsLtDDjm1rT8dFp6gfZ/ZqtF5Y3KMpySMjvKeM5JL5P
	gmOPh87VoqI7kib7c7Pr7Lx81Yx3OG/7PjPhfbQDW/7BFUZ/me6+EvusxFKckWioxVxUnAgA
	WLkWvV8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have already set page update in ->write_begin, so we should remove redundant
SetPageUptodate in ->write_end.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c1fb6dd..fd133cf 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1003,7 +1003,6 @@ static int f2fs_write_end(struct file *file,
 
 	trace_f2fs_write_end(inode, pos, len, copied);
 
-	SetPageUptodate(page);
 	set_page_dirty(page);
 
 	if (pos + copied > i_size_read(inode)) {
-- 
1.7.9.5


