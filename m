Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbbABJmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:42:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25255 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbABJmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:42:44 -0500
X-AuditID: cbfee691-f79b86d000004a5a-78-54a66812a824
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 9/11] xfstests: generic/043: Test multiple fallocate
 insert/collapse range calls
Date: Fri, 02 Jan 2015 18:42:41 +0900
Message-id: <004701d02670$73dcb0a0$5b9611e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmb7FIVvw3UFAaQdC7xO8IHm0eYA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkRFcoY1mIwYsrhhZLJ15itnj3ucpi
	y7F7jBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKptH
	35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZZz8+ZSt4IpSxfXNuQ2ME2W6GDk5JARMJGY3zGOD
	sMUkLtxbD2YLCSxllNixWBymZsWV5yxdjFxA8UWMEp/eb2WFcP4ySuz8exKog4ODTUBb4s8W
	UZAGEQFXiXl3vzOC1DALnGCUWD95CQtIQlggVaJx0nl2EJtFQFXi/sl7zCA2r4ClxLYb31gh
	bEGJH5PvgdUzC2hJrN95nAnClpfYvOYtM8RFChI7zr5mBNkrIqAn8fmLAESJiMS+F+/A9koI
	3GKXOPR4GxvELgGJb5MPsYDUSwjISmw6ADVGUuLgihssExjFZiHZPAvJ5llINs9CsmIBI8sq
	RtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjMDYPP3v2cQdjPcPWB9iFOBgVOLhVbi2NESINbGs
	uDL3EKMp0EUTmaVEk/OBCSCvJN7Q2MzIwtTE1NjI3NJMSZxXR/pnsJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQbGwvM6lyaGGxx6FbQ9mZ9z2fpXDqefv7r1/dznjfHsi01qf+75O0GgPbgq
	56cUI3uHcOZ+H+17VQma/1xn5Pm8SDFferaglXfuc4PoVJUTNv/EvCSfLtrtZ8O/p/DDf82N
	mvz7n7vJNUzrlJdhUGco9Hzp9P5lRXDb9s3bj3anb/xgt01OLbhJiaU4I9FQi7moOBEAdfBH
	P8gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xgK5QxrIQg8UPNSyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx8udTtoIr
	ShXXN+c2ME6U6WLk5JAQMJFYceU5C4QtJnHh3nq2LkYuDiGBRYwSn95vZYVw/jJK7Px7EijD
	wcEmoC3xZ4soSIOIgKvEvLvfGUFqmAVOMEqsn7wEbJKwQKpE46Tz7CA2i4CqxP2T95hBbF4B
	S4ltN76xQtiCEj8m3wOrZxbQkli/8zgThC0vsXnNW2aIixQkdpx9zQiyV0RAT+LzFwGIEhGJ
	fS/eMU5gFJiFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBsf9M
	egfjqgaLQ4wCHIxKPLwK15aGCLEmlhVX5h5ilOBgVhLh7ZNbEiLEm5JYWZValB9fVJqTWnyI
	0RTo0YnMUqLJ+cC0lFcSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnV
	wCjW/tqSvTs5M3HRir5amWjDbOOiRZsMJ8nlbt5jZb9W3Vp+lmCk2Yl5h6yc5C8X1LNadasc
	iZ+uzvFz8g+DQ30VzaUCH5Us/uVvK73qNS05/vJOwVg37vx5Dc1mc2uLFp2YYX9UWH5liHW5
	YXhlRGdfnveUzFWds9Jmn4369nC3gKeJ1+lNSizFGYmGWsxFxYkATm8i4BMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(043) tries to test finsert range a single alternate block
mulitiple times and test merge code of collase range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Cc: Brian Foster <bfoster@redhat.com>
---
 tests/generic/043     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/043.out |   7 ++++
 tests/generic/group   |   1 +
 3 files changed, 115 insertions(+)
 create mode 100644 tests/generic/043
 create mode 100644 tests/generic/043.out

diff --git a/tests/generic/043 b/tests/generic/043
new file mode 100644
index 0000000..6aebc1e
--- /dev/null
+++ b/tests/generic/043
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. generic/043
+#
+# Test multiple fallocate insert/collapse range calls on same file.
+# For different blocksizes, Call insert range a single alternate block
+# multiple times until the file is left with 100 extents and as much
+# number of extents. And Call collapse range about the previously inserted
+# ranges to test merge code of collapse range.
+# Also check for file system consistency after completing this operation
+# for each blocksize.
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Samsung Electronics.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "fcollapse"
+_do_die_on_error=y
+testfile=$SCRATCH_MNT/$seq.$$
+BLOCKS=100
+
+for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
+
+	length=$(($BLOCKS * $BSIZE))
+	case $FSTYP in
+	xfs)
+	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
+	;;
+	ext4)
+	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
+	;;
+	esac
+	_scratch_mount >> $seqres.full 2>&1
+
+	# Write file
+	$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
+
+
+	# Insert alternate blocks 
+	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+		offset=$((($j*$BSIZE)*2))
+		$XFS_IO_PROG -c "finsert $offset $BSIZE" $testfile > /dev/null
+	done
+
+	# Check if 100 extents are present
+	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
+
+	_check_scratch_fs
+	if [ $? -ne 0 ]; then
+		status=1
+		exit
+	fi
+
+	# Collapse alternate blocks 
+	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+		offset=$((($j*$BSIZE)))
+		$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
+	done
+
+	# Check if 1 extents are present
+	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
+
+	_check_scratch_fs
+	if [ $? -ne 0 ]; then
+		status=1
+		exit
+	fi
+
+	umount $SCRATCH_MNT
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/043.out b/tests/generic/043.out
new file mode 100644
index 0000000..fd4b804
--- /dev/null
+++ b/tests/generic/043.out
@@ -0,0 +1,7 @@
+QA output created by 043
+100
+1
+100
+1
+100
+1
diff --git a/tests/generic/group b/tests/generic/group
index c0944b3..0a10bdd 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -45,6 +45,7 @@
 040 auto quick prealloc
 041 auto quick prealloc
 042 auto quick prealloc
+043 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.5.5

