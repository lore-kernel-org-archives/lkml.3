Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3KOFWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:22:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40386 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3KOFVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:21:25 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-b0-5285af4acca8
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/5] f2fs: add a sysfs entry to control max_discards
Date: Fri, 15 Nov 2013 14:20:22 +0900
Message-id: <1384492824-32483-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1384492824-32483-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1384492824-32483-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zA12v9a1BBtNfKFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbFs4Rn2gv+cFe0z
	PrI3MB7h6GLk5JAQMJGYuewCM4QtJnHh3no2EFtIYBmjxMMPWTA1/zbfY4WIT2eUOL+Mr4uR
	C8huZpJYP+UXUIKDg01AW2LzfgOQGhEBZokFU88zgtQwC0xglPi/6D0LSEJYwEXi+YG/YMtY
	BFQl7jT8BlvGK+AuMWVxCxvEMm2Jbc8nMoLYnAIeEp0TTzBDLHaXuLRoEjtEzXc2iQ8L6yHm
	CEh8m3yIBeQGCQFZiU0HoH6RlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNz
	NzFCwnXCDsZ7B6wPMSYDjZvILCWanA8M97ySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYIywFX+yOZRP1OJR7tTmqVr6B/lvljKH+QnfifDM3MK2
	IoChYpv4x9hij+v/nVgljx6d6H0ucFvo2yNpYX+3nInr7OLKU2sLXLBu1/JNmsFHfkf9P1R+
	9f6mZgHj2ZOXcFcJ83VcV9ZNd5mhMOXg18XT231FmU4/17w7tbJ+3f0jHslynGzfTiixFGck
	GmoxFxUnAgB+sVxQbQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQV2v9a1BBhd2yltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ixbOEZ9oL/nBXtMz6yNzAe4ehi5OSQEDCR+Lf5HiuELSZx4d56NhBbSGA6
	o8T5ZXxdjFxAdjOTxPopv4CKODjYBLQlNu83AKkREWCWWDD1PCNIDbPABEaJ/4ves4AkhAVc
	JJ4f+MsMYrMIqErcafgNNpRXwF1iyuIWNohl2hLbnk9kBLE5BTwkOieeYIZY7C5xadEk9gmM
	vAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEfEM+kdjKsaLA4xCnAwKvHwRki3Bgmx
	JpYVV+YeYpTgYFYS4X2WABTiTUmsrEotyo8vKs1JLT7EmAx01URmKdHkfGC05pXEGxqbmBlZ
	GplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDI2OP5GY5hqMW6fLHd7ZyxEpr
	nm4w/KbGKP0wSuKvNOss+QTBy29XM/RPW9IjpmoW8uTqyqtTHV2VgyzmzKxq0wzfcHDdg1UK
	m3Wk7SbMnv1t24Um/wTbmGQT3nz//pIPfqWnpZJZXlg+nzWH3S5+15lW+Z8r3RPbFss4G3qe
	Wv/vHQuT92wnJZbijERDLeai4kQAWN0viswCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If frequent small discards are issued to the device, the performance would
be degraded significantly.
So, this patch adds a sysfs entry to control the number of discards to be
issued during a checkpoint procedure.

By default, f2fs does not issue any small discards, which means max_discards
is zero.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index e9aa3f7..a022412 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -175,6 +175,7 @@ F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_max_sleep_time, max_sleep_time);
 F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_no_gc_sleep_time, no_gc_sleep_time);
 F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_idle, gc_idle);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, reclaim_segments, rec_prefree_segments);
+F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, max_small_discards, max_discards);
 
 #define ATTR_LIST(name) (&f2fs_attr_##name.attr)
 static struct attribute *f2fs_attrs[] = {
@@ -183,6 +184,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(gc_no_gc_sleep_time),
 	ATTR_LIST(gc_idle),
 	ATTR_LIST(reclaim_segments),
+	ATTR_LIST(max_small_discards),
 	NULL,
 };
 
-- 
1.8.4.474.g128a96c

