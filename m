Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3HBIKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:10:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47677 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3HBIKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:10:16 -0400
X-AuditID: cbfee68e-b7f276d000002279-eb-51fb6965c2be
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] libf2fs: check more conditions on mounted filesystem
Date: Fri, 02 Aug 2013 17:09:49 +0900
Message-id: <1375430989-4689-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ93UzN+BBgcbbCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgypj07RVjQad8xdb+
	vcwNjE8luhg5OSQETCQOnn7EDmGLSVy4t56ti5GLQ0hgGaPEzWv7WWCKtsy5xQKRWMQo8fDC
	dGYIp41JYvqjt0AOBwebgLbE5v0GIA0iAswSC6aeZwSpYRaYwCjxf9F7sEnCAq4Sf08cYwWp
	ZxFQlfjxQBwkzCvgJjFx2j9GiGW6EotOHGQF6ZUQuM8m0bX3BNh5LAICEt8mH2IB6ZUQkJXY
	dIAZol5S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAgJwb4djDcPWB9i
	TAYaN5FZSjQ5HxjCeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgXFEf8Elp9VSx1jcTTd3C4qoDZXv0HRK/GfnE8av4LX4RauPCXL2r7PD0E37s
	/qxt1u8vPJ28bC7Lt75wD84vUe94JR+c3cqwXc9NzkMpfY9noJ3fmY673xVYzPx/Vu0/+O39
	9lUi+1iiAqzUioN+9SRf+TDljrad+ed1O93fcszlyrpVLbVciaU4I9FQi7moOBEAcxIYR1cC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd3UzN+BBn0HzC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yY9O0VY0GnfMXW/r3MDYxPJboYOTkkBEwktsy5xQJhi0lcuLeerYuRi0NI
	YBGjxMML05khnDYmiemP3gI5HBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvwSYJC7hK
	/D1xjBWknkVAVeLHA3GQMK+Am8TEaf8YIZbpSiw6cZB1AiP3AkaGVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBAf5MegfjqgaLQ4wCHIxKPLwPMn8FCrEmlhVX5h5ilOBgVhLh/TMbKMSb
	klhZlVqUH19UmpNafIgxGWj5RGYp0eR8YPTllcQbGpuYGVkamVkYmZibkyasJM57sNU6UEgg
	PbEkNTs1tSC1CGYLEwenVAOjw8e2P4s3x2xoPrNWbnHrN/erjOuOG99bm+4m3Luy0iOj4ptV
	YJZwy5tiqx2Lxd/OkNrAb77jqL1wj8Wfyq37lyqcDPpWqn569Z2IRzNvSNVfMb2g4GjOmNn9
	cv9el/bAx1V602yUWgz9luWHX3J7Xahw4dlDMfdDWo37xRr358/X/btL6qeFEktxRqKhFnNR
	cSIAYMc867QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of lazy umount, "umount -l", some processes are able to use the
file system even if its mountpoint was disconnected.
At this moment, we should not allow mkfs.f2fs.
This patch adds this condition check.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fsck/main.c        |  2 +-
 include/f2fs_fs.h  |  2 +-
 lib/libf2fs.c      | 60 +++++++++++++++++++++++++++++++++++++++---------------
 mkfs/f2fs_format.c |  2 +-
 4 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index 80db15d..a0144fc 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -183,7 +183,7 @@ int main (int argc, char **argv)
 
 	f2fs_parse_options(argc, argv);
 
-	if (f2fs_dev_is_mounted(&config) < 0)
+	if (f2fs_dev_is_umounted(&config) < 0)
 		return -1;
 
 	/* Get device */
diff --git a/include/f2fs_fs.h b/include/f2fs_fs.h
index d0fc79e..7081e5e 100644
--- a/include/f2fs_fs.h
+++ b/include/f2fs_fs.h
@@ -641,7 +641,7 @@ extern u_int32_t f2fs_cal_crc32(u_int32_t, void *, int);
 extern int f2fs_crc_valid(u_int32_t blk_crc, void *buf, int len);
 
 extern void f2fs_init_configuration(struct f2fs_configuration *);
-extern int f2fs_dev_is_mounted(struct f2fs_configuration *);
+extern int f2fs_dev_is_umounted(struct f2fs_configuration *);
 extern int f2fs_get_device_info(struct f2fs_configuration *);
 
 extern int dev_read(void *, __u64, size_t);
diff --git a/lib/libf2fs.c b/lib/libf2fs.c
index b02072f..6947425 100644
--- a/lib/libf2fs.c
+++ b/lib/libf2fs.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <errno.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <mntent.h>
@@ -365,31 +366,58 @@ void f2fs_init_configuration(struct f2fs_configuration *c)
 	c->device_name = NULL;
 }
 
-int f2fs_dev_is_mounted(struct f2fs_configuration *c)
+static int is_mounted(const char *mpt, const char *device)
 {
 	FILE *file = NULL;
 	struct mntent *mnt = NULL;
 
-	file = setmntent(MOUNTED, "r");
-	if (file == NULL) {
-		/* if failed due to /etc/mtab file not present
-		   try with /proc/mounts */
-		file = setmntent("/proc/mounts", "r");
-		if (file == NULL)
-			return 0;
-	}
+	file = setmntent(mpt, "r");
+	if (file == NULL)
+		return 0;
 
-	while (1) {
-		mnt = getmntent(file);
-		if (mnt == NULL)
+	while ((mnt = getmntent(file)) != NULL) {
+		if (!strcmp(device, mnt->mnt_fsname))
 			break;
-		if (!strcmp(c->device_name, mnt->mnt_fsname)) {
-			endmntent(file);
-			MSG(0, "\tError: Not available on mounted device!\n");
+	}
+	endmntent(file);
+	return mnt ? 1 : 0;
+}
+
+int f2fs_dev_is_umounted(struct f2fs_configuration *c)
+{
+	struct stat st_buf;
+	int ret = 0;
+
+	ret = is_mounted(MOUNTED, c->device_name);
+	if (ret) {
+		MSG(0, "\tError: Not available on mounted device!\n");
+		return -1;
+	}
+
+	/*
+	 * if failed due to /etc/mtab file not present
+	 * try with /proc/mounts.
+	 */
+	ret = is_mounted("/proc/mounts", c->device_name);
+	if (ret) {
+		MSG(0, "\tError: Not available on mounted device!\n");
+		return -1;
+	}
+
+	/*
+	 * If f2fs is umounted with -l, the process can still use
+	 * the file system. In this case, we should not format.
+	 */
+	if (stat(c->device_name, &st_buf) == 0 && S_ISBLK(st_buf.st_mode)) {
+		int fd = open(c->device_name, O_RDONLY | O_EXCL);
+
+		if (fd >= 0) {
+			close(fd);
+		} else if (errno == EBUSY) {
+			MSG(0, "\tError: In use by the system!\n");
 			return -1;
 		}
 	}
-	endmntent(file);
 	return 0;
 }
 
diff --git a/mkfs/f2fs_format.c b/mkfs/f2fs_format.c
index d60f990..5b017c7 100644
--- a/mkfs/f2fs_format.c
+++ b/mkfs/f2fs_format.c
@@ -998,7 +998,7 @@ int main(int argc, char *argv[])
 
 	f2fs_parse_options(argc, argv);
 
-	if (f2fs_dev_is_mounted(&config) < 0)
+	if (f2fs_dev_is_umounted(&config) < 0)
 		return -1;
 
 	if (f2fs_get_device_info(&config) < 0)
-- 
1.8.3.1.437.g0dbd812

