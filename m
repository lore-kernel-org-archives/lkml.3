Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3KXGSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 01:18:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:65091 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3KXGSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 01:18:10 -0500
X-AuditID: cbfee691-b7f666d0000048b0-cc-52919a214314
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: add detailed information of bio types in the tracepoints
Date: Sun, 24 Nov 2013 15:17:12 +0900
Message-id: <1385273832-32167-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zA13FWRODDO52clhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXH/9G7Ggl3iFb8W
	v2RtYDwn1MXIySEhYCKxcPUkFghbTOLCvfVsILaQwDJGibOr82Bqfp69z9jFyAUUX8QoseDG
	P3aIomYmid6thV2MHBxsAtoSm/cbgIRFBJglFkw9D1bPLDCBUeL/ovdgC4QF/CWeTuhnBrFZ
	BFQlrt8+ARbnFXCX6L2zEeoIbYltzycyQtiP2SSe3dOEqBeQ+Db5EAvILgkBWYlNB5ghSiQl
	Dq64wTKBUXABI8MqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJDwm7iD8f4B60OMyUDjJjJL
	iSbnA8M3ryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoY1x5btP51uQtvxv37smrm8nsKdJyOah4yTBa4OuGlfvexF4bx/hYhL3in6Cs8Kd9x8MrZ
	G0sKbY71r7qfyTzTwDrqfWRMedyauX85LTc5pEhPMNz+p3t1pOACn1eTanp+XVaIOqTQ7R6j
	b7Buy/KEr0tfMi4+djTsZKzxP6MG9oSCfQuks6sNlFiKMxINtZiLihMBPZcgX1UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAV3FWRODDOa/Y7a4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj/undjAW7xCt+LX7J2sB4TqiLkZNDQsBE4ufZ+4wQtpjEhXvr2boYuTiE
	BBYxSiy48Y8dJCEk0Mwk0bu1sIuRg4NNQFti834DkLCIALPEgqnnGUHqmQUmMEr8X/SeBSQh
	LOAv8XRCPzOIzSKgKnH99gmwOK+Au0TvnY0sEMu0JbY9n8g4gZF7ASPDKkbR1ILkguKk9Fwj
	veLE3OLSvHS95PzcTYzgAH8mvYNxVYPFIUYBDkYlHt5Gx4lBQqyJZcWVuYcYJTiYlUR4vVuB
	QrwpiZVVqUX58UWlOanFhxiTgbZPZJYSTc4HRl9eSbyhsYmZkaWRmYWRibk5acJK4rwHW60D
	hQTSE0tSs1NTC1KLYLYwcXBKNTBKHziaPGG2SFvXrnvuZ8RvnCpxNC2+6L9cPfnFlenKm8Pe
	y4Tl7pl28yujA2fh/qk1jyM69a7G5bd2Hmo+H2+fnezDdrd448U/kaoNii9duavSnwgaLxZx
	LrtZdGAW99HtxtsN3qa+ydp6uF5sz/JffVVWIjzuR79O8Y49O2PxfHnRI3lNGV+VWIozEg21
	mIuKEwFrz8XdtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch inserts information of bio types in more detail.
So, we can now see REQ_META and REQ_PRIO too.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c           |  4 ++--
 include/trace/events/f2fs.h | 22 +++++++++++++++++-----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b86b1bd..501a5dc 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -848,11 +848,11 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 	if (type >= META_FLUSH)
 		rw = WRITE_FLUSH_FUA;
 
-	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
-
 	if (btype == META)
 		rw |= REQ_META;
 
+	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
+
 	p = io->bio->bi_private;
 	p->sbi = sbi;
 	io->bio->bi_end_io = f2fs_end_io_write;
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 1f59f5d..204fcc3 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -16,8 +16,13 @@
 		{ META,		"META" },				\
 		{ META_FLUSH,	"META_FLUSH" })
 
-#define show_bio_type(type)						\
-	__print_symbolic(type,						\
+#define F2FS_BIO_MASK(t)	(t & (READA | WRITE_FLUSH_FUA))
+#define F2FS_BIO_EXTRA_MASK(t)	(t & (REQ_META | REQ_PRIO))
+
+#define show_bio_type(type)	show_bio_base(type), show_bio_extra(type)
+
+#define show_bio_base(type)						\
+	__print_symbolic(F2FS_BIO_MASK(type),				\
 		{ READ, 		"READ" },			\
 		{ READA, 		"READAHEAD" },			\
 		{ READ_SYNC, 		"READ_SYNC" },			\
@@ -27,6 +32,13 @@
 		{ WRITE_FUA, 		"WRITE_FUA" },			\
 		{ WRITE_FLUSH_FUA,	"WRITE_FLUSH_FUA" })
 
+#define show_bio_extra(type)						\
+	__print_symbolic(F2FS_BIO_EXTRA_MASK(type),			\
+		{ REQ_META, 		"(M)" },			\
+		{ REQ_PRIO, 		"(P)" },			\
+		{ REQ_META | REQ_PRIO,	"(MP)" },			\
+		{ 0, " \b" })
+
 #define show_data_type(type)						\
 	__print_symbolic(type,						\
 		{ CURSEG_HOT_DATA, 	"Hot DATA" },			\
@@ -447,7 +459,7 @@ TRACE_EVENT_CONDITION(f2fs_readpage,
 	),
 
 	TP_printk("dev = (%d,%d), ino = %lu, page_index = 0x%lx, "
-		"blkaddr = 0x%llx, bio_type = %s",
+		"blkaddr = 0x%llx, bio_type = %s%s",
 		show_dev_ino(__entry),
 		(unsigned long)__entry->index,
 		(unsigned long long)__entry->blkaddr,
@@ -621,7 +633,7 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 		__entry->size		= bio->bi_size;
 	),
 
-	TP_printk("dev = (%d,%d), %s, %s, sector = %lld, size = %u",
+	TP_printk("dev = (%d,%d), %s%s, %s, sector = %lld, size = %u",
 		show_dev(__entry),
 		show_bio_type(__entry->rw),
 		show_block_type(__entry->type),
@@ -713,7 +725,7 @@ DECLARE_EVENT_CLASS(f2fs_io_page,
 		__entry->block	= blk_addr;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, %s, %s, index = %lu, blkaddr = 0x%llx",
+	TP_printk("dev = (%d,%d), ino = %lu, %s%s, %s, index = %lu, blkaddr = 0x%llx",
 		show_dev_ino(__entry),
 		show_bio_type(__entry->rw),
 		show_block_type(__entry->type),
-- 
1.8.4.474.g128a96c

