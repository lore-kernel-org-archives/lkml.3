Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbbABJnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:43:15 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57743 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbbABJnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:43:09 -0500
X-AuditID: cbfee68e-f79b46d000002b74-5d-54a6682b3703
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 11/11] xfstests: fsx: Add fallocate insert range operation
Date: Fri, 02 Jan 2015 18:43:07 +0900
Message-id: <004901d02670$835ac120$8a104360$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmb+b4hB7if8ceQOKQqTqsl6mwjw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQFc7Y1mIwbV+Y4ulEy8xW7z7XGWx
	5dg9RouZ8+6wWezZe5LF4vKuOWwWrT0/2S0W9d1idODwOLVIwqPpzFFmj9UXtjJ6vN93lc2j
	b8sqRo/Pm+QC2KK4bFJSczLLUov07RK4Mi6c28NW8ESzorMnu4HxhEIXIyeHhICJRO/hI2wQ
	tpjEhXvrgWwuDiGBpYwS094+Y4Ypur/mNCtEYjqjRP/2fywQzl9GiXO3GoBaODjYBLQl/mwR
	BWkQEXCVmHf3OyNIDbPACUaJ9ZOXsIAkhAV8JW40fQabyiKgKvHi9S9WEJtXwFJi8bLHbBC2
	oMSPyffA6pkFtCTW7zzOBGHLS2xe8xbqIgWJHWdfM0Is05N409/NDFEjIrHvxTuwxRICt9gl
	5rxexgKxTEDi2+RDLCCHSgjISmw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHU
	guSC4qT0IiO94sTc4tK8dL3k/NxNjMD4PP3vWd8OxpsHrA8xCnAwKvHwKlxbGiLEmlhWXJl7
	iNEU6KKJzFKiyfnAJJBXEm9obGZkYWpiamxkbmmmJM6bIPUzWEggPbEkNTs1tSC1KL6oNCe1
	+BAjEwenVANj0NR3hm3LmmbwOKx+qNDvM63jgfqXKY258lr+byVarZg4Pl5m4/P973jz9OUp
	a6+nFqwxN/A+EnM1uW738pP85l8SArM6eC4v3Op7w/lb9n3tYzfWZGwNa+pU+vdFwDjszdp/
	hZHtZT69zNMKq89n/p7sVrZV+cyb7k8+95Kal9vf/h+YG86oxFKckWioxVxUnAgAfd74O8oC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoK52xrIQg5PPtCyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx4dwetoIn
	mhWdPdkNjCcUuhg5OSQETCTurznNCmGLSVy4t56ti5GLQ0hgOqNE//Z/LBDOX0aJc7cagDIc
	HGwC2hJ/toiCNIgIuErMu/udEaSGWeAEo8T6yUtYQBLCAr4SN5o+M4PYLAKqEi9e/wLbwCtg
	KbF42WM2CFtQ4sfke2D1zAJaEut3HmeCsOUlNq95ywxxkYLEjrOvGSGW6Um86e9mhqgRkdj3
	4h3jBEaBWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERz9z6R3
	MK5qsDjEKMDBqMTDq3BtaYgQa2JZcWXuIUYJDmYlEd4+uSUhQrwpiZVVqUX58UWlOanFhxhN
	gT6dyCwlmpwPTEx5JfGGxiZmRpZG5oYWRsbmSuK8SvZtIUIC6YklqdmpqQWpRTB9TBycUg2M
	S/V5du8TM/H/aRAl8/f8kQ/CF1pvq0yK+XIicldUaGfC13+LJi03yOpS2z/9Xtnq7Oeqf2b2
	Xvs9J9E9ZXtN2YfjOV3HXie/jxFSOiKjfVB5+nmWrL/LL7DpmpqFpKdwTu5Kzss+fiV8y8Wd
	O9gm+QqFbV5cab1j7VvdLz94lEwzjm6fP2XLPyWW4oxEQy3mouJEANuuVdMUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds fallocate FALLOC_FL_INSERT_RANGE support for fsx.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 ltp/fsx.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 2 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 47d3ee8..9dc1655 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -95,7 +95,8 @@ int			logcount = 0;	/* total ops */
 #define OP_PUNCH_HOLE		6
 #define OP_ZERO_RANGE		7
 #define OP_COLLAPSE_RANGE	8
-#define OP_MAX_FULL		9
+#define OP_INSERT_RANGE	9
+#define OP_MAX_FULL		10
 
 /* operation modifiers */
 #define OP_CLOSEOPEN	100
@@ -145,6 +146,7 @@ int     fallocate_calls = 1;            /* -F flag disables */
 int     punch_hole_calls = 1;           /* -H flag disables */
 int     zero_range_calls = 1;           /* -z flag disables */
 int	collapse_range_calls = 1;	/* -C flag disables */
+int	insert_range_calls = 1;		/* -i flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -339,6 +341,14 @@ logdump(void)
 						     lp->args[0] + lp->args[1])
 				prt("\t******CCCC");
 			break;
+		case OP_INSERT_RANGE:
+			prt("INSERT 0x%x thru 0x%x\t(0x%x bytes)",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1]);
+			if (badoff >= lp->args[0] && badoff <
+						     lp->args[0] + lp->args[1])
+				prt("\t******CCCC");
+			break;
 		case OP_SKIPPED:
 			prt("SKIPPED (no operation)");
 			break;
@@ -1012,6 +1022,59 @@ do_collapse_range(unsigned offset, unsigned length)
 }
 #endif
 
+#ifdef FALLOC_FL_INSERT_RANGE
+void
+do_insert_range(unsigned offset, unsigned length)
+{
+	unsigned end_offset;
+	int mode = FALLOC_FL_INSERT_RANGE;
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length insert range\n");
+		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
+		return;
+	}
+
+	if ((loff_t)offset >= file_size) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping insert range behind EOF\n");
+		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
+		return;
+	}
+
+	log4(OP_INSERT_RANGE, offset, length, 0);
+
+	if (testcalls <= simulatedopcount)
+		return;
+
+	end_offset = offset + length;
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		      end_offset <= monitorend))) {
+		prt("%lu insert\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
+			offset, offset+length, length);
+	}
+	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
+		prt("insert range: %x to %x\n", offset, length);
+		prterr("do_insert_range: fallocate");
+		report_failure(161);
+	}
+
+	memmove(good_buf + end_offset, good_buf + offset,
+		file_size - offset);
+	memset(good_buf + offset, '\0', length);
+	file_size += length;
+}
+
+#else
+void
+do_insert_range(unsigned offset, unsigned length)
+{
+	return;
+}
+#endif
+
 #ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
@@ -1192,6 +1255,12 @@ test(void)
 			goto out;
 		}
 		break;
+	case OP_INSERT_RANGE:
+		if (!insert_range_calls) {
+			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
+			goto out;
+		}
+		break;
 	}
 
 	switch (op) {
@@ -1244,6 +1313,21 @@ test(void)
 		}
 		do_collapse_range(offset, size);
 		break;
+	case OP_INSERT_RANGE:
+		TRIM_OFF_LEN(offset, size, (maxfilelen - 1) - file_size);
+		offset = offset & ~(block_size - 1);
+		size = size & ~(block_size - 1);
+		if (size == 0) {
+			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
+			goto out;
+		}
+		if (file_size + size > maxfilelen) {
+			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
+			goto out;
+		}
+
+		do_insert_range(offset, size);
+		break;
 	default:
 		prterr("test: unknown operation");
 		report_failure(42);
@@ -1307,6 +1391,9 @@ usage(void)
 #ifdef FALLOC_FL_COLLAPSE_RANGE
 "	-C: Do not use collapse range calls\n"
 #endif
+#ifdef FALLOC_FL_INSERT_RANGE
+"	-i: Do not use insert range calls\n"
+#endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -1493,7 +1580,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCLN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCiLN:OP:RS:WZ"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1599,6 +1686,9 @@ main(int argc, char **argv)
 		case 'C':
 			collapse_range_calls = 0;
 			break;
+		case 'i':
+			insert_range_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			break;
@@ -1758,6 +1848,8 @@ main(int argc, char **argv)
 		zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
 	if (collapse_range_calls)
 		collapse_range_calls = test_fallocate(FALLOC_FL_COLLAPSE_RANGE);
+	if (insert_range_calls)
+		insert_range_calls = test_fallocate(FALLOC_FL_INSERT_RANGE);
 
 	while (numops == -1 || numops--)
 		test();
-- 
1.7.11-rc0

