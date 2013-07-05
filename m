Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3GEI2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 04:28:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32756 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab3GEI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:28:20 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-28-51d683a2b3ec
Message-id: <1373012892.26443.1.camel@kjgkr>
Subject: Re: [PATCH v2] f2fs: fix readdir incorrectness
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Fri, 05 Jul 2013 17:28:12 +0900
In-reply-to: <1373001730-6928-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1373001730-6928-1-git-send-email-jaegeuk.kim@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zfd1FzdcCDa5NlrO4tMjdYs/ekywW
	l3fNYbM4//c4qwOLx+4Fn5k8Pm+S89j05C1TAHMUl01Kak5mWWqRvl0CV8aHmetYCm4KVbzr
	2s/awPiZr4uRk0NCwERi37KDjBC2mMSFe+vZuhi5OIQEljFKTN/7nh2m6N7JS1CJRYwSd17P
	YYJwXjNKXHy3hw2kildAR2LTljtMILawgLnE6mWTgeIcHGwC2hKb9xuAhIUEFCXe7r/LChIW
	AbIvv3cCCTML5Ep0NB9jBrFZBFQlpr2/BmZzCrhLfNl+AGyKkICbxOO2KJAwv4CoxOGF25kh
	WtUlJs1bxAxxppLE7vZOdoi4vMTmNW+ZIQ4TlPgx+R4LyMUSAvvYJaYdecUOsUtA4tvkQywg
	8yUEZCU2HYCaIylxcMUNlgmMErOQrJiFZOwsJGMXMDKvYhRNLUguKE5KLzLRK07MLS7NS9dL
	zs/dxAiJtwk7GO8dsD7EmAy0ciKzlGhyPjBe80riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuESxRquy/srdNvZlafYzI85956jzYRJL+yNzbOZf
	jT2Nnmq/H5/6fWi6dPSv30pvI79r39Zl49CK0l6uZXv8rciEy2ZzFtSXugtmhk4+zSB3LW/5
	zdvFv/R5Tt5JOnY43Kau+LXJ7+hTId/1p25a9k/YqYK9pqpk9XP3aUkZ9jsSTOec3JX4XIml
	OCPRUIu5qDgRAO5GjyTNAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd1FzdcCDWZ+lLS4tMjdYs/ekywW
	l3fNYbM4//c4qwOLx+4Fn5k8Pm+S89j05C1TAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPGh5nrWApuClW869rP2sD4ma+LkZNDQsBE4t7JS2wQtpjEhXvrgWwuDiGB
	RYwSd17PYYJwXjNKXHy3B6yKV0BHYtOWO0wgtrCAucTqZZOB4hwcbALaEpv3G4CEhQQUJd7u
	v8sKEhYBsi+/dwIJMwvkSnQ0H2MGsVkEVCWmvb8GZnMKuEt82X4AbIqQgJvE47YokDC/gKjE
	4YXbmSFa1SUmzVvEDHGmksTu9k52iLi8xOY1b5khDhOU+DH5HssERqFZSFpmISmbhaRsASPz
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgaH4mvYNxVYPFIUYBDkYlHt4H9VcDhVgTy4or
	cw8xSnAwK4nw2idcCxTiTUmsrEotyo8vKs1JLT7EmAz03ERmKdHkfGCiySuJNzQ2MTOyNDKz
	MDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxvwNprybynoeHxZr8/Zq3yKicdvP
	1v/htlsNB/Lk7rroPcxP4nh8qoNVulSI30ykQve+3rZ2/9DmZKNNR3aJBomvLvp6zbZj1vMT
	lqtKj/7484qx1fEJ563nUupznms4/K1bILTJ4qR1xzcGh5QJc5b42QZunDOZ592Hi/suXVy9
	6ZRURUQLoxJLcUaioRZzUXEiANu0+08qAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chang log from v1:
 o fix another scenario

>From 2ee3c8144187ab230d0f47f9b95e5406af87ada8 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Fri, 5 Jul 2013 14:06:04 +0900
Subject: [PATCH] f2fs: fix readdir incorrectness
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

In the previous Al Viro's readdir patch set, there occurs a bug when
running
xfstest: 006 as follows.

[Error output]
alpha size = 4, name length = 6, total files = 4096, nproc=1
1023 files created
rm: cannot remove `/mnt/f2fs/permname.15150/a': Directory not empty

[Correct output]
alpha size = 4, name length = 6, total files = 4096, nproc=1
4097 files created

This bug is due to the misupdate of directory position in ctx.
So, this patch fixes this.

CC: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 9d1cd42..dffc4f7 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -634,19 +634,19 @@ static int f2fs_readdir(struct file *file, struct
dir_context *ctx)
 			if (bit_pos >= NR_DENTRY_IN_BLOCK)
 				break;
 
-			ctx->pos += bit_pos - start_bit_pos;
 			de = &dentry_blk->dentry[bit_pos];
 			if (de->file_type < F2FS_FT_MAX)
 				d_type = f2fs_filetype_table[de->file_type];
 			else
 				d_type = DT_UNKNOWN;
 			if (!dir_emit(ctx,
-				      dentry_blk->filename[bit_pos],
-				      le16_to_cpu(de->name_len),
-				      le32_to_cpu(de->ino), d_type))
-				goto success;
-			slots = GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
-			bit_pos += slots;
+					dentry_blk->filename[bit_pos],
+					le16_to_cpu(de->name_len),
+					le32_to_cpu(de->ino), d_type))
+				goto stop;
+
+			bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
+			ctx->pos = n * NR_DENTRY_IN_BLOCK + bit_ops;
 		}
 		bit_pos = 0;
 		ctx->pos = (n + 1) * NR_DENTRY_IN_BLOCK;
@@ -654,7 +654,7 @@ static int f2fs_readdir(struct file *file, struct
dir_context *ctx)
 		f2fs_put_page(dentry_page, 1);
 		dentry_page = NULL;
 	}
-success:
+stop:
 	if (dentry_page && !IS_ERR(dentry_page)) {
 		kunmap(dentry_page);
 		f2fs_put_page(dentry_page, 1);
-- 
1.8.3.1.437.g0dbd812



-- 
Jaegeuk Kim
Samsung

