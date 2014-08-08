Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaHHFHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:07:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26392 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaHHFHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:07:02 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-38-53e45af5a7b2
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 8/10] xfstests: generic/032: Delayed allocation multi insert
Date: Fri, 08 Aug 2014 14:07:00 +0900
Message-id: <004901cfb2c6$9631d270$c2957750$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yv1ABYEBXbeu8QnOYnI+26EVbpw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkSPdr1JNgg0ufBCzefa6y2HLsHqPF
	sgebWSxmzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	z5vkAlijuGxSUnMyy1KL9O0SuDIWXbvOVrBFs2LV41VMDYxrlboYOTkkBEwkJs06zARhi0lc
	uLeerYuRi0NIYCmjxMZzj9hhiiYf3ccEkVjEKLF35hGoqr+MEjMvL2PsYuTgYBPQlvizRRSk
	QUTAVWLe3e+MIDazwB1GiV9rjEFsYQF/iV8NN8G2sQioSkxsvs0MYvMKWEr87fvCAmELSvyY
	fI8FZCSzgI7E10kREGPkJTavecsMcY+CxI6zrxkhVulJHPp+gh2iRkRi34t3jCCnSQhcYpc4
	cXsqK8QuAYlvkw+BzZQQkJXYdABqjqTEwRU3WCYwis1CsnkWwuZZSDbPQrJhASPLKkbR1ILk
	guKk9CJDveLE3OLSvHS95PzcTYzAiDz971nvDsbbB6wPMSYDbZ/ILCWanA+M6LySeENjMyML
	UxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYKw06Dly4Y7B5NfX
	Xc68OnPTQ/NYU3naYuv1LgIZa3t25W9lOBXxg6vl5q3Qo03nL0Y2T1dg+Zf7anPgQ62fd2U7
	36Wbff4764Rptrqe+asD25dnfbd871e//Pbi1pktX6LsjZSEuF7JG75oXrt+WoeJaErArdb0
	qWuYdGqKAioz7++892E51x4lluKMREMt5qLiRAB72YkU3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd2vUU+CDU5/4LB497nKYsuxe4wW
	yx5sZrGYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYsejadbaCLZoVqx6v
	YmpgXKvUxcjJISFgIjH56D4mCFtM4sK99WxdjFwcQgKLGCX2zjwC5fxllJh5eRljFyMHB5uA
	tsSfLaIgDSICrhLz7n5nBLGZBe4wSvxaYwxiCwv4S/xquAk2lEVAVWJi821mEJtXwFLib98X
	FghbUOLH5HssICOZBXQkvk6KgBgjL7F5zVtmiHsUJHacfc0IsUpP4tD3E+wQNSIS+168Y5zA
	KDALyaRZCJNmIZk0C0nHAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB8f5MagfjygaL
	Q4wCHIxKPLwC3Y+DhVgTy4orcw8xSnAwK4nw1nwGCvGmJFZWpRblxxeV5qQWH2I0BfpzIrOU
	aHI+MBXllcQbGpuYGVkamRtaGBmbK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpg3Ky2R53/
	nuqm6H19uUZuW77FzrW4L5h4YF/FVCHHeVKzru5tFbLYeVL8jPwshYikS+rrl8h3i79ekZk4
	ParuDmPMMycpc46lLYfnKf1ex3pwY/D+f322h9I1TyjGH7JSLhdeahxtz/Vtf+s0v4g3roxd
	rFnOd/XFTij9694j+XDhPvPDf82WKbEUZyQaajEXFScCAInfvkcNAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(032) tries to test various corner cases with delayed extents and
pre-existing holes for finsert range functionality over different type of
extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/032     | 65 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/032.out | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 146 insertions(+)
 create mode 100644 tests/generic/032
 create mode 100644 tests/generic/032.out

diff --git a/tests/generic/032 b/tests/generic/032
new file mode 100644
index 0000000..32798f3
--- /dev/null
+++ b/tests/generic/032
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/032
+#
+# Delayed allocation multi insert range tests
+# This testcase is one of the 4 testcases which tries to
+# test various corner cases for finsert range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
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
+_test_generic_punch -d -k falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/032.out b/tests/generic/032.out
new file mode 100644
index 0000000..6d7acfd
--- /dev/null
+++ b/tests/generic/032.out
@@ -0,0 +1,80 @@
+QA output created by 032
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
index 544d422..01d719b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -34,6 +34,7 @@
 029 auto quick prealloc
 030 auto quick prealloc
 031 auto quick prealloc
+032 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

