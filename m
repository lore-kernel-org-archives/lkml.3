Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaEHKiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:38:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9730 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaEHKiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:38:14 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-86-536b5e948d1b
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
Subject: [PATCH v2 10/10] xfstests: fsx: Add fallocate insert range operation
Date: Thu, 08 May 2014 19:38:12 +0900
Message-id: <004001cf6aa9$9c6dc2d0$d5494870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qqX37GwFfohzQSTekN4KH7xYYQg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkSHdKXHawweT/BhZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NYrLJiU1J7MstUjfLoErY9/ZJywFTzQr3k++y9LAeEKhi5GTQ0LAROLYvB4WCFtM4sK99Wxd
	jFwcQgJLGSXuHmhkgSm6P/E1M0RiEaPE4+enGCGcv4wSd358Bari4GAT0Jb4s0UUpEFEwFNi
	8fGtYJOYBVYyStw7/pENJCEs4CuxeMkEZhCbRUBV4sKM62AbeAUsJTadP8YGYQtK/Jh8DyzO
	LKAlsX7ncSYIW15i85q3zBAXKUjsOPuaEWKZnsTkJ11sEDUiEvtevGOEqLnELjG/qx5il4DE
	t8mHwO6UEJCV2HQAaoykxMEVN1gmMIrNQrJ5FpLNs5BsnoVkwwJGllWMoqkFyQXFSelFhnrF
	ibnFpXnpesn5uZsYgdF4+t+z3h2Mtw9YH2JMBlo/kVlKNDkfGM15JfGGxmZGFqYmpsZG5pZm
	pAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDo18Vb/WSbttCaPb37CzYd2xBz
	40XRjKi+6nrXHA7d5A+vLW/OWdkiYTp1zZ3+M9en+D4X2Lf919JnLLsvhcUerVleszvlfR5b
	1+Hz9R+vT5u9QebB8tqy5+H/H7+YrBto519kMM1BMFjWQtI1x4plqfPdTYkpUmWmV+6/VXk5
	Z/9bm5sHeJmPKLEUZyQaajEXFScCAKJEDojcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAd0pcdnBBs+vqFssnXiJ2WLLsXuM
	FjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowO5xapGER9OZo8weqy9sZfTo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBn7zj5hKXiiWfF+8l2WBsYT
	Cl2MnBwSAiYS9ye+ZoawxSQu3FvP1sXIxSEksIhR4vHzU4wQzl9GiTs/vrJ0MXJwsAloS/zZ
	IgrSICLgKbH4+FawBmaBlYwS945/ZANJCAv4SixeMgFsKouAqsSFGddZQGxeAUuJTeePsUHY
	ghI/Jt8DizMLaEms33mcCcKWl9i85i3URQoSO86+ZoRYpicx+UkXG0SNiMS+F+8YJzAKzEIy
	ahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBofya9g3FVg8UhRgEO
	RiUe3gznrGAh1sSy4srcQ4wSHMxKIrw8/tnBQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwP
	TER5JfGGxiZmRpZG5oYWRsbmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cA44facCRlL
	m3KUGp01/bjM7TT3BAaUCgccfntmzQyTWo5ciQLW74tV3s0T7VcKCDv9+eF7boaCig/Ha4VW
	WQne0b3DsTR71RJ+3d5LOT+uHN3+zNNzego/9517+fNtrhyfceMcT+dOwc/zXZKbPZ49nqPV
	dujIxisN9bme9xnPeGUFbG7PLV6nxFKckWioxVxUnAgAC785RzoDAAA=
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
index 47d3ee8..875460e 100644
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

