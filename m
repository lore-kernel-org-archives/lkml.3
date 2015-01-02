Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbbABJme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:42:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57609 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbABJm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:42:27 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-b9-54a667ef36f7
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 7/11] xfstests: generic/041: Multi insert range tests
Date: Fri, 02 Jan 2015 18:42:06 +0900
Message-id: <004501d02670$5f3cff10$1db6fd30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmb3Ohghdy1q2yRR+Y5xVEQvFaog==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkRPd9+rIQg2sb+C2WTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYIvisklJzcksSy3St0vgyjjx/jNzwT+Niqc75zE1MP5X7GLk4JAQMJE4dUqv
	i5ETyBSTuHBvPVsXIxeHkMBSRokN+++zQiRMJLY8mM8KkZjOKDH/5m0o5y+jxMTpExlBJrEJ
	aEv82SIK0iAi4Cox7+53RpAaZoETjBLrJy9hAUkIC3hI3Dn0lhHEZhFQlej6s4AdxOYVsJQ4
	3HWDBcIWlPgx+R6YzSygJbF+53EmCFteYvOat8wQFylI7Dj7mhFimZ7Epc8L2SFqRCT2vXgH
	tlhC4B67xORN76GWCUh8m3yIBeJlWYlNB6DmSEocXHGDZQKj2Cwkq2chWT0LyepZSFYsYGRZ
	xSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREYn6f/PZuwg/HeAetDjAIcjEo8vArXloYIsSaW
	FVfmHmI0BbpoIrOUaHI+MAnklcQbGpsZWZiamBobmVuaKYnzvpb6GSwkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBsfug2M1T8/j0/x39G5qwhNV68vYQtwUxs7qmcV95xST+mHO/4MF6/x1/
	7by3b2md557ZrqX/+PjRdbX552eLxKX/8PBzulq9beND9rXy092kud0ubneP/Bq39d3HOKc9
	1ksyfmwwvRBT8Wndgs2761t0DJPOcS6QfNu85YHw6ymXtj02bH7f0arEUpyRaKjFXFScCACB
	VxDrygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoO779GUhBttes1ksnXiJ2eLd5yqL
	LcfuMVrMnHeHzWLP3pMsFpd3zWGzaO35yW6xqO8WowOHx6lFEh5NZ44ye6y+sJXR4/2+q2we
	fVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjxPvPzAX/
	NCqe7pzH1MD4X7GLkZNDQsBEYsuD+awQtpjEhXvr2boYuTiEBKYzSsy/eZsVwvnLKDFx+kTG
	LkYODjYBbYk/W0RBGkQEXCXm3f3OCFLDLHCCUWL95CUsIAlhAQ+JO4feMoLYLAKqEl1/FrCD
	2LwClhKHu26wQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhniIgWJHWdfM0Is05O49HkhO0SN
	iMS+F+8YJzAKzEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOD4
	fya9g3FVg8UhRgEORiUeXoVrS0OEWBPLiitzDzFKcDArifD2yS0JEeJNSaysSi3Kjy8qzUkt
	PsRoCvTpRGYp0eR8YGrKK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+Lg
	lGpgXBP8uLl9B3/jnMUPN6byrAgPXDOF3/58lpdyoM6JjRedAxS3bD+2K/rTm+VrbcwuHXZx
	bHXMmvvEPUfTQ+vSUeFjkYdjP+2XeN+1Mdr1jvvpYA+VSUcK1tx3qji2t/2OyWT9dLdbJj2e
	4mnP/vclu9XILH2VP8fQyr2izK7tzLmscqaG1W0ZSizFGYmGWsxFxYkAod8x9BUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(041) tries to test various corner cases with pre-existing holes
for finsert range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/041     | 65 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/041.out | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 146 insertions(+)
 create mode 100644 tests/generic/041
 create mode 100644 tests/generic/041.out

diff --git a/tests/generic/041 b/tests/generic/041
new file mode 100644
index 0000000..29e0f31
--- /dev/null
+++ b/tests/generic/041
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/041
+#
+# Multi insert range tests
+# This testcase is one of the 4 testcases which tries to
+# test various corner cases for finsert range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
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
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+# we need to include common/punch to get defination fo filter functions
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "finsert"
+
+testfile=$TEST_DIR/$seq.$$
+
+_test_generic_punch -k falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/041.out b/tests/generic/041.out
new file mode 100644
index 0000000..5fe3c5e
--- /dev/null
+++ b/tests/generic/041.out
@@ -0,0 +1,80 @@
+QA output created by 041
+	1. into a hole
+cf845a781c107ec1346e849c9dd1b7e8
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..55]: extent
+64e72217eebcbdf31b1b058f9f5f476a
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..55]: extent
+22b7303d274481990b5401b6263effe0
+	4. hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..55]: extent
+c4fef62ba1de9d91a977cfeec6632f19
+	5. hole -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..55]: extent
+1ca74f7572a0f4ab477fdbb5682e5f61
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..47]: hole
+4: [48..55]: extent
+be0f35d4292a20040766d87883b0abd1
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+bddb1f3895268acce30d516a99cb0f2f
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+4: [40..55]: extent
+f8fc47adc45b7cf72f988b3ddf5bff64
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+c4fef62ba1de9d91a977cfeec6632f19
+	10. hole -> data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+2: [40..63]: extent
+52af1bfcbf43f28af2328de32e0567e5
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+3: [40..47]: hole
+4: [48..63]: extent
+e3a8d52acc4d91a8ed19d7b6f4f26a71
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..63]: extent
+52af1bfcbf43f28af2328de32e0567e5
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..63]: extent
+2b22165f4a24a2c36fd05ef00b41df88
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+2: [40..55]: extent
+aa0f20d1edcdbce60d8ef82700ba30c3
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..55]: extent
+86c9d033be2761385c9cfa203c426bb2
diff --git a/tests/generic/group b/tests/generic/group
index 518cf49..62660cc 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -43,6 +43,7 @@
 038 auto stress
 039 auto quick prealloc
 040 auto quick prealloc
+041 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.5.5

