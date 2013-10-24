Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3JXH65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:58:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29546 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3JXH6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:58:22 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-91-5268d31c6257
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Changman Lee <cm224.lee@samsung.com>
Subject: [PATCH 3/3] f2fs: add reclaiming control by sysfs
Date: Thu, 24 Oct 2013 16:57:42 +0900
Message-id: <1382601462-7989-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1382601462-7989-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1382601462-7989-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t8zY13ZyxlBBt+bmCyu7Wtksri+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY/6SZsaC
	1WoV89pfsTcw/pDrYuTkkBAwkXj+/gM7hC0mceHeerYuRi4OIYFljBIbPk9mgimac+IpE0Ri
	OqNE45avLCAJIYFmJomTl5K6GDk42AS0JTbvNwAJiwgwSyyYep4RpJ5ZYAejxKmJexhBEsIC
	VhIdU8+B2SwCqhJvTzwDW8Ar4CYxZ+5lFohl2hLbnk8Eq+EUcJeYOm8bM8QuN4ljnyaxgAyV
	EGhml1i4fjcLxCABiW+TD7GAHCEhICux6QAzxBxJiYMrbrBMYBRewMiwilE0tSC5oDgpvchI
	rzgxt7g0L10vOT93EyMkePt2MN48YH2IMRlo3ERmKdHkfGDw55XEGxqbGVmYmpgaG5lbmpEm
	rCTOu+hhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRss+NVUTjul3A4wfLNl/0Vaz78ZW
	F79Dcu9X1DNFPtPN193TIJ/rrrs4OrFyY9LFaZMa5XaGMDyX6yr6vp5Hdvtqs8sPTi6/ZBF5
	7fs56QzvVWt0VHgi1yp0d5S8eZxx7um0aR68ezNDC37saj375PekbqXrxi5hzWdW7NfhLdrB
	tFFpytGwe0osxRmJhlrMRcWJANjXRA10AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jQV2ZyxlBBrsPWVlc29fIZHF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8b8Jc2MBavVKua1v2JvYPwh18XIySEhYCIx58RTJghbTOLCvfVs
	XYxcHEIC0xklGrd8ZQFJCAk0M0mcvJTUxcjBwSagLbF5vwFIWESAWWLB1POMIPXMAjsYJU5N
	3MMIkhAWsJLomHoOzGYRUJV4e+IZ2AJeATeJOXMvs0As05bY9nwiWA2ngLvE1HnbmCF2uUkc
	+zSJZQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwbHxTHoH46oGi0OMAhyMSjy8
	Gh/Sg4RYE8uKK3MPMUpwMCuJ8HpWZAQJ8aYkVlalFuXHF5XmpBYfYkwGumois5Rocj4wbvNK
	4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgXHVtTtfJzGvi+d9
	5R4r1sa48XuS0IoIzhuqvS+/uZ+VvCRzotFwSbXpt7BfE1a6t8cvUbHff7zyz9PSLC+tN09r
	NfvTVm4tdrte52Kh8qdY78u29cfvMF2TyH5qceFQhvgVXgZextJ9ygzXZ9z1aVx6VO/Dk2O9
	5hwVrHIL/jyPlj5y4zq/5wUlluKMREMt5qLiRAC7l1Zv0QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a control method in sysfs to reclaim prefree segments.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/filesystems/f2fs.txt |  6 +++++
 fs/f2fs/super.c                    | 50 +++++++++++++++++++++++++++-----------
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 3cd27be..4c647c2 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -164,6 +164,12 @@ Files in /sys/fs/f2fs/<devname>
                               gc_idle = 1 will select the Cost Benefit approach
                               & setting gc_idle = 2 will select the greedy aproach.
 
+ reclaim_segments             This parameter controls the number of prefree
+                              segments to be reclaimed. If the number of prefree
+			      segments is larger than this number, f2fs tries to
+			      conduct checkpoint to reclaim the prefree segments
+			      to free segments. By default, 100 segments, 200MB.
+
 ================================================================================
 USAGE
 ================================================================================
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 9a09459..e42351c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -69,24 +69,40 @@ static match_table_t f2fs_tokens = {
 };
 
 /* Sysfs support for f2fs */
+enum {
+	GC_THREAD,	/* struct f2fs_gc_thread */
+	SM_INFO,	/* struct f2fs_sm_info */
+};
+
 struct f2fs_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct f2fs_attr *, struct f2fs_sb_info *, char *);
 	ssize_t (*store)(struct f2fs_attr *, struct f2fs_sb_info *,
 			 const char *, size_t);
+	int struct_type;
 	int offset;
 };
 
+static unsigned char *__struct_ptr(struct f2fs_sb_info *sbi, int struct_type)
+{
+	if (struct_type == GC_THREAD)
+		return (unsigned char *)sbi->gc_thread;
+	else if (struct_type == SM_INFO)
+		return (unsigned char *)SM_I(sbi);
+	return NULL;
+}
+
 static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 			struct f2fs_sb_info *sbi, char *buf)
 {
-	struct f2fs_gc_kthread *gc_kth = sbi->gc_thread;
+	unsigned char *ptr = NULL;
 	unsigned int *ui;
 
-	if (!gc_kth)
+	ptr = __struct_ptr(sbi, a->struct_type);
+	if (!ptr)
 		return -EINVAL;
 
-	ui = (unsigned int *)(((char *)gc_kth) + a->offset);
+	ui = (unsigned int *)(ptr + a->offset);
 
 	return snprintf(buf, PAGE_SIZE, "%u\n", *ui);
 }
@@ -95,15 +111,16 @@ static ssize_t f2fs_sbi_store(struct f2fs_attr *a,
 			struct f2fs_sb_info *sbi,
 			const char *buf, size_t count)
 {
-	struct f2fs_gc_kthread *gc_kth = sbi->gc_thread;
+	unsigned char *ptr;
 	unsigned long t;
 	unsigned int *ui;
 	ssize_t ret;
 
-	if (!gc_kth)
+	ptr = __struct_ptr(sbi, a->struct_type);
+	if (!ptr)
 		return -EINVAL;
 
-	ui = (unsigned int *)(((char *)gc_kth) + a->offset);
+	ui = (unsigned int *)(ptr + a->offset);
 
 	ret = kstrtoul(skip_spaces(buf), 0, &t);
 	if (ret < 0)
@@ -139,21 +156,25 @@ static void f2fs_sb_release(struct kobject *kobj)
 	complete(&sbi->s_kobj_unregister);
 }
 
-#define F2FS_ATTR_OFFSET(_name, _mode, _show, _store, _elname) \
+#define F2FS_ATTR_OFFSET(_struct_type, _name, _mode, _show, _store, _offset) \
 static struct f2fs_attr f2fs_attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
 	.store	= _store,					\
-	.offset = offsetof(struct f2fs_gc_kthread, _elname),	\
+	.struct_type = _struct_type,				\
+	.offset = _offset					\
 }
 
-#define F2FS_RW_ATTR(name, elname)	\
-	F2FS_ATTR_OFFSET(name, 0644, f2fs_sbi_show, f2fs_sbi_store, elname)
+#define F2FS_RW_ATTR(struct_type, struct_name, name, elname)	\
+	F2FS_ATTR_OFFSET(struct_type, name, 0644,		\
+		f2fs_sbi_show, f2fs_sbi_store,			\
+		offsetof(struct struct_name, elname))
 
-F2FS_RW_ATTR(gc_min_sleep_time, min_sleep_time);
-F2FS_RW_ATTR(gc_max_sleep_time, max_sleep_time);
-F2FS_RW_ATTR(gc_no_gc_sleep_time, no_gc_sleep_time);
-F2FS_RW_ATTR(gc_idle, gc_idle);
+F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_min_sleep_time, min_sleep_time);
+F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_max_sleep_time, max_sleep_time);
+F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_no_gc_sleep_time, no_gc_sleep_time);
+F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_idle, gc_idle);
+F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, reclaim_segments, rec_prefree_segments);
 
 #define ATTR_LIST(name) (&f2fs_attr_##name.attr)
 static struct attribute *f2fs_attrs[] = {
@@ -161,6 +182,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(gc_max_sleep_time),
 	ATTR_LIST(gc_no_gc_sleep_time),
 	ATTR_LIST(gc_idle),
+	ATTR_LIST(reclaim_segments),
 	NULL,
 };
 
-- 
1.8.4.474.g128a96c

