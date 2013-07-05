Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab3GEFXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 01:23:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20064 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEFW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 01:22:59 -0400
X-AuditID: cbfee68e-b7f276d000002279-75-51d658311ee4
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: recover date requested by fdatasync
Date: Fri, 05 Jul 2013 14:22:52 +0900
Message-id: <1373001772-7013-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zA13DiGuBBl9e6Fhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbHyx0vWgsUcFQ+u
	v2BsYHzA1sXIySEhYCJx/kMHlC0mceHeejBbSGAZo8Tv2cUwNQ/OdTB3MXIBxRcxSuzbvJUV
	wmljkjj6extQBwcHm4C2xOb9BiANIgLMEgumnmcEqWEWmMAo8X/RexaQGmEBK4kDl8JAalgE
	VCX2vpzBAmLzCrhJzO+5zgKxTFdi0YmDYPMlBO6zSXw90M4M0SAg8W3yIbA5EgKyEpsOMEPU
	S0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIQHYt4Px5gHrQ4zJQOMm
	MkuJJucDAzivJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYzJsxXyavn6rv0y3yGqpcTwfqr5hz1TVF5xqB1IfbbGdQbbHgU2IVaefb2Wq969mDrb
	UPpQzqfXVTv6Wdj3yf5fmde0eOvM6L1iyWdKvcMWmCd9SRFtWt0UUfFzoknCRJ99bgskGL5c
	WHyym6NHeGrh5JmdUg27fvYu7lq9tfP2w943XC/fM+9VYinOSDTUYi4qTgQAe1ouwlYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAV3DiGuBBs2fNSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xY+eMla8FijooH118wNjA+YOti5OSQEDCReHCugxnCFpO4cG89UJyLQ0hg
	EaPEvs1bWSGcNiaJo7+3AWU4ONgEtCU27zcAaRARYJZYMPU8I0gNs8AERon/i96zgNQIC1hJ
	HLgUBlLDIqAqsfflDBYQm1fATWJ+z3UWiGW6EotOHGSdwMi9gJFhFaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZwgD+T3sG4qsHiEKMAB6MSD++D+quBQqyJZcWVuYcYJTiYlUR4Pd4DhXhT
	EiurUovy44tKc1KLDzEmA22fyCwlmpwPjL68knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmk
	J5akZqemFqQWwWxh4uCUamCcMK8n8NvOG2rfdiW73rriFRs9d7HVwh1f+NvN6j01k5/r5exj
	OzIvLuVNxU4D4b36PeKr5nBud1JZnOJ83bBc2EdN7OKhAxH6EhYXl57fGvP0zSa/o6uiP8j7
	P4mYdTR1Z+Z8hccTWTdzBnq/rtTg3BawOjv3x7dTcxg3/Aw2nvEnw+J+1Iw3SizFGYmGWsxF
	xYkAzzk+vrQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support SQLite that uses fdatasync instead of fsync, we should
guarantee the data requested by fdatasync can be recovered after sudden-power-
off.

So, let's remove the fdatasync condition in f2fs_sync_file.
Otherwise, we can restore the data after sudden-power-off due to nonexistence
of any fsync mark'ed node blocks.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d2d2b7d..157a635 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -147,9 +147,10 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	mutex_lock(&inode->i_mutex);
 
-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		goto out;
-
+	/*
+	 * Both of fdatasync() and fsync() are able to be recovered from
+	 * sudden-power-off.
+	 */
 	if (!S_ISREG(inode->i_mode) || inode->i_nlink != 1)
 		need_cp = true;
 	else if (file_wrong_pino(inode))
-- 
1.8.3.1.437.g0dbd812

