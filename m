Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaHHFHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:07:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25669 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaHHFHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:07:14 -0400
X-AuditID: cbfee691-b7f306d000003d81-43-53e45b00a669
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 10/10] xfstests: fsx: Add fallocate insert range operation
Date: Fri, 08 Aug 2014 14:07:12 +0900
Message-id: <004b01cfb2c6$9d084f70$d718ee50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+ywE/fM47JiJviQBS4QsLNnH/91g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkWJch+kmwwd6dehbvPldZbDl2j9Fi
	2YPNLBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKpvH
	501yAaxRXDYpqTmZZalF+nYJXBkXzu1hK3iiWdHZk93AeEKhi5GTQ0LARGLfkk4mCFtM4sK9
	9WxdjFwcQgJLGSV+zdzMDlO0qnMlM0RiOqNE7+oZjBDOX0aJKY3TgFo4ONgEtCX+bBEFaRAR
	cJWYd/c7I4jNLHAHaNIaYxBbWMBX4v3ll2BxFgFViY0z14Jt5hWwlFi9rJERwhaU+DH5HgvI
	SGYBHYmvkyIgxshLbF7zlhniHgWJHWdfM0Ks0pOYt/sqO0SNiMS+F+/ATpMQOMcu0bt0NRPE
	LgGJb5MPgc2UEJCV2HQAao6kxMEVN1gmMIrNQrJ5FsLmWUg2z0KyYQEjyypG0dSC5ILipPQi
	U73ixNzi0rx0veT83E2MwHg8/e/ZxB2M9w9YH2JMBto+kVlKNDkfGM95JfGGxmZGFqYmpsZG
	5pZmpAkrifOmP0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCoYfv67TSWR0vnOK9e4r5F
	5NZElZPxWbE7P/LHT+lvnZLFuuxI5ed3YQ3rj28+1ioUtHB5gOOBfw+Xy3yWbwyO+ZlVcFDE
	S41hVlrJ0cJCJonaJ9e+p3ocTr1yd2GgZ8zHnYoq3PK/PL2j9rx7nN4WeWW7pHmDwWyfnGnt
	ize2NzGJvn0477+cEktxRqKhFnNRcSIApKm72N0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQV2G6CfBBp2vVC3efa6y2HLsHqPF
	sgebWSxmzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	z5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmXDi3h63giWZFZ092
	A+MJhS5GTg4JAROJVZ0rmSFsMYkL99azdTFycQgJTGeU6F09gxHC+csoMaVxGlCGg4NNQFvi
	zxZRkAYRAVeJeXe/M4LYzAJ3GCV+rTEGsYUFfCXeX34JFmcRUJXYOHMtE4jNK2ApsXpZIyOE
	LSjxY/I9FpCRzAI6El8nRUCMkZfYvOYt1D0KEjvOvmaEWKUnMW/3VXaIGhGJfS/eMU5gFJiF
	ZNIshEmzkEyahaRjASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgaH8mtYNxZYPFIUYB
	DkYlHl6B7sfBQqyJZcWVuYcYJTiYlUR4az4DhXhTEiurUovy44tKc1KLDzGaAv05kVlKNDkf
	mIjySuINjU3MjCyNzA0tjIzNlcR5D7RaBwoJpCeWpGanphakFsH0MXFwSjUwzms7nvvLyvuA
	6GqO5y1fw2KzU+T43jPZfJee1h9nddvlEpuG8aLEJe7t5yIipy28yD45a1Giz00/z3iv8O93
	2UKKd2+Sm7S0zu2c1cVANxE558g934K6jhdtvtuTdTuOpZxVWGml/KQJfw5d0WRynLnCevPr
	DN07L3MtlpTNfF7KdCzkMsdUJZbijERDLeai4kQAWCq12QwDAAA=
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

