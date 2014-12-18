Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaLRJqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:46:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:49877 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaLRJqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:46:46 -0500
X-AuditID: cbfee68d-f79296d000004278-0c-5492a2854fad
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH 11/11] xfstests: Test multiple fallocate insert/collapse range
 calls
Date: Thu, 18 Dec 2014 18:46:44 +0900
Message-id: <002101d01aa7$88b49120$9a1db360$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAaocPEtqyEIaxFT9uC1DRH3ZAq9g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkRLd10aQQg1VzRSyWTrzEbPHuc5XF
	lmP3GC327D3JYnF51xw2i0V9txgd2DxOLZLwWH1hK6PH+31X2Tz6tqxi9Pi8SS6ANYrLJiU1
	J7MstUjfLoEr48LCJWwFt5Qqfn4paGCcLtPFyMkhIWAicenEQkYIW0ziwr31bF2MXBxCAksZ
	JSbOescGU3R++n9WiMR0RonzV44yQjh/GSU6l8wBynBwsAloS/zZIgrSICLgKXH37CmwZmaB
	KolDvffYQWxhgTCJ5VcugsVZBFQlvj58xgbSyitgKXG7ORkkzCsgKPFj8j0WiFYtifU7jzNB
	2PISm9e8ZYa4R0Fix9nXjBCr9CRebrgMVSMise/FO7DTJAQOsUu8Wb0FapeAxLfJh1hAdkkI
	yEpsOgA1R1Li4IobLBMYxWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CJDveLE3OLSvHS9
	5PzcTYzA6Dv971nvDsbbB6wPMQpwMCrx8ErqTQoRYk0sK67MPcRoCnTRRGYp0eR8YIznlcQb
	GpsZWZiamBobmVuaKYnzKkr9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuHJZeOOa/UmH
	OrezbIliM6/P/Do/Olqgu4R7bXDwk0ezQ6Q/F1+aPN3mZ/eeIv6EaUViq29ZfTmxTSosQ+y5
	zL93Ry8VTJx7veLFWbFvHO3VrSunOrWsitgVniXJcVZqp0LsW5dVYVWLxOblP1tT2PzrBMcu
	U7lWlWfVQlY/E4NzT01K57BZocRSnJFoqMVcVJwIANV0mX25AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jQd3WRZNCDB684bZYOvESs8W7z1UW
	W47dY7TYs/cki8XlXXPYLBb13WJ0YPM4tUjCY/WFrYwe7/ddZfPo27KK0ePzJrkA1qgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoAOUFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBkXFi5hK7ilVPHzS0ED43SZLkZODgkB
	E4nz0/+zQthiEhfurWfrYuTiEBKYzihx/spRRgjnL6NE55I5QFUcHGwC2hJ/toiCNIgIeErc
	PXuKDcRmFqiSONR7jx3EFhYIk1h+5SJYnEVAVeLrw2dsIK28ApYSt5uTQcK8AoISPybfY4Fo
	1ZJYv/M4E4QtL7F5zVtmiHsUJHacfc0IsUpP4uWGy1A1IhL7XrxjnMAoMAvJqFlIRs1CMmoW
	kpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJj+5nUDsaVDRaHGAU4GJV4eCX0JoUI
	sSaWFVfmHmKU4GBWEuGNzgEK8aYkVlalFuXHF5XmpBYfYjQFenQis5Rocj4w7eSVxBsam5gZ
	WRqZG1oYGZsrifMq2beFCAmkJ5akZqemFqQWwfQxcXBKNTD2W2SJpGrc58qxDd3w43ti09x4
	fufCSUdWOvDf+B38oyp3adHCznWrFFdVZ1572z1hFnuZr9g2VpNnQQfYFwrd1p8Um6415UJu
	EKNHPHdvyfc3jevvT3uY2+3n9Xip0GuWPd/+C7Pez+R02ftu88K6oAzWLwv6BKTiW3NkWDtz
	vMLn1GsXn1JiKc5INNRiLipOBACpGS6vAwMAAA==
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
+# multiple times until the file is left with 1024 extents and as much
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
+BLOCKS=1024
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
+	# Check if 1024 extents are present
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
+1024
+1
+1024
+1
+1024
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

