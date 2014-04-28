Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaD1JvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:51:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25289 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaD1JvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:51:03 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-99-535e24846d40
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: return i_size if the hole is outside of i_size
Date: Mon, 28 Apr 2014 18:48:48 +0900
Message-id: <1398678529-11067-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA90Wlbhgg6WnjS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvh3/AJrwR3Wil8P
	PzA3MF5k6WLk5JAQMJFYuGw6K4QtJnHh3nq2LkYuDiGBZYwS0/5tYIUp+vboFStEYjqjxN6p
	k6CqOpkkDj+dydjFyMHBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0HmydsICnxOtl69hA
	bBYBVYnz718xg/TyCrhLHGv2hFimLbHt+USwXgmB+2wS895/ZYSoF5D4NvkQC0i9hICsxKYD
	zBD1khIHV9xgmcAouICRYRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSAhO2MF474D1IcZk
	oHETmaVEk/OBIZxXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYyG7rPXX/ofeKnVyLH9v1nh5T4bdRn9L46K2SsytSMvJ25haKr0lfBR960JenR/
	T5xyFWvbB9bHt+2PHNjR6HG4X0I9XSFaisfvU6d48UKBXxFrste46Vs9nMfw+XuOQ4Ppyf12
	t5emuN2J3O1cmf3EkOFTw8K1+56EPyvWeDxrt+vs4xl1tkosxRmJhlrMRcWJAJ+e86hXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd0Wlbhgg2en9S2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8z4d/wCa8Ed1opfDz8wNzBeZOli5OSQEDCR+PboFSuELSZx4d56ti5GLg4h
	gemMEnunToJyOpkkDj+dydjFyMHBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0HmyqsICn
	xOtl69hAbBYBVYnz718xg/TyCrhLHGv2hFimLbHt+UTGCYzcCxgZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEB/gz6R2MqxosDjEKcDAq8fBGzIkNFmJNLCuuzD3EKMHBrCTCu18iLliI
	NyWxsiq1KD++qDQntfgQYzLQ8onMUqLJ+cDoyyuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQ
	QHpiSWp2ampBahHMFiYOTqkGxrmdNrc2tqVPMTN7kmM/84WY3wx9E9Xf81YrLPf1qS9T5Xu4
	roAh1mv3/6SaZ6fKV23yZlxVmFO0U/Cp5vLzYnKsh48UsT2L37F+YWTQnIPsWZ4cf9KenUxM
	/VEraR7Kc96xpXf20r8u2h+MuwvfzX7+0ufhnkuusWE/o45F9SwUXefYwui3Q4mlOCPRUIu5
	qDgRALYNRsi0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SEEK_HOLE is requeted, it should return i_size if the hole position is
found outside of i_size.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d99d173..3112857 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -255,9 +255,9 @@ static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 
 	if (whence == SEEK_DATA)
 		goto fail;
-	else
-		data_ofs = isize;
 found:
+	if (whence == SEEK_HOLE && data_ofs > isize)
+		data_ofs = isize;
 	mutex_unlock(&inode->i_mutex);
 	return vfs_setpos(file, data_ofs, maxbytes);
 fail:
-- 
1.8.4.474.g128a96c

