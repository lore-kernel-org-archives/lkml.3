Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaHHFIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:08:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26249 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbaHHFGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:06:40 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-33-53e45adabd49
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 5/10] xfstests: generic/029: Standard insert range tests
Date: Fri, 08 Aug 2014 14:06:33 +0900
Message-id: <004601cfb2c6$86035db0$920a1910$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yvrMbr/8vi1gJQX2Wlv/g+rKl6g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkUPdW1JNgg+3LOCzefa6y2HLsHqPF
	sgebWSxmzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	z5vkAlijuGxSUnMyy1KL9O0SuDK29K1jKjirX/H93xOmBsZ/al2MnBwSAiYSa7ZPZYSwxSQu
	3FvP1sXIxSEksJRR4sC/WewwRQuezIdKTAdKHPjMDOH8ZZQ4snoOkMPBwSagLfFniyhIg4iA
	q8S8u9/BpjIL3GGU+LXGGMQWFvCWeDPrLxtIOYuAqsS7eRkgYV4BS4mDO5cxQdiCEj8m32MB
	KWEW0JH4OikCYoq8xOY1b5khzlGQ2HH2NSPEJj2J3TuPMkPUiEjse/GOEeQyCYFL7BI7T18H
	m8kiICDxbfIhsJkSArISmw5AzZGUOLjiBssERrFZSDbPQtg8C8nmWUg2LGBkWcUomlqQXFCc
	lF5krFecmFtcmpeul5yfu4kRGI+n/z3r38F494D1IcZkoO0TmaVEk/OB8ZxXEm9obGZkYWpi
	amxkbmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiPqt9e+WPv4y08nzt1
	zmdM+/jnunAKc/LJmTWy51UqPO9EmTefvrXrUVjHA0fFeamLPzg7+3utfrStYffbSVwG8hxV
	R4KkA3UqlzmJCcnELg5W+RW4mN/yfK7vNiPurDnL5IIvzvz54Zw528tFk5fYaz/zOWJ4arqV
	mhv7nSWNm1f/sY4UUudTYinOSDTUYi4qTgQADY4rA90CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd2bUU+CDb432Vq8+1xlseXYPUaL
	ZQ82s1jMnHeHzWLP3pMsFpd3zWGzaO35yW6xqO8WowOHx6lFEh5NZ44ye6y+sJXR4/2+q2we
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2NK3jqngrH7F939P
	mBoY/6l1MXJySAiYSCx4Mp8NwhaTuHBvPZDNxSEkMJ1R4sCBz8wQzl9GiSOr5wA5HBxsAtoS
	f7aIgjSICLhKzLv7nRHEZha4wyjxa40xiC0s4C3xZtZfNpByFgFViXfzMkDCvAKWEgd3LmOC
	sAUlfky+xwJSwiygI/F1UgTEFHmJzWveMkOcoyCx4+xrRohNehK7dx5lhqgRkdj34h3jBEaB
	WUgmzUKYNAvJpFlIOhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI72Z9I7GFc1WBxi
	FOBgVOLhFeh+HCzEmlhWXJl7iFGCg1lJhLfmM1CINyWxsiq1KD++qDQntfgQoynQmxOZpUST
	84GJKK8k3tDYxMzI0sjc0MLI2FxJnPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUA2POhtnvVh0W
	47xWz7fIUHta0XS3xeKlzn5T9+rbXXJMkuIMvBRj8ffNeiXNsszMtL9V669ob1zV9VGqJe9B
	SlhBlNYFjU+rtn6alOdzNnlpwjPb3vKqx+bl5aGb5iT+UhGvEbf7tz303dHXTy/u4l39+8/+
	0jKvnufmWVNfrH76Z6uPhxvv2YNKLMUZiYZazEXFiQAlZx/TDAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(029) tries to test various corner cases for finsert range
functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 common/punch          |  5 ++++
 common/rc             |  2 +-
 tests/generic/029     | 65 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/029.out | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 5 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 tests/generic/029
 create mode 100644 tests/generic/029.out

diff --git a/common/punch b/common/punch
index f2d538c..4cc50d5 100644
--- a/common/punch
+++ b/common/punch
@@ -527,6 +527,11 @@ _test_generic_punch()
 		return
 	fi
 
+	# If zero_cmd is finsert, don't check unaligned offsets
+	if [ "$zero_cmd" == "finsert" ]; then
+		return
+	fi
+
 	echo "	16. data -> cache cold ->hole"
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
diff --git a/common/rc b/common/rc
index 2c83340..6d805cf 100644
--- a/common/rc
+++ b/common/rc
@@ -1272,7 +1272,7 @@ _require_xfs_io_command()
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
 		;;
-	"fpunch" | "fcollapse" | "zero" | "fzero" )
+	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" )
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
diff --git a/tests/generic/029 b/tests/generic/029
new file mode 100644
index 0000000..2b18069
--- /dev/null
+++ b/tests/generic/029
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/029
+#
+# Standard insert range tests
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
+_test_generic_punch falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/029.out b/tests/generic/029.out
new file mode 100644
index 0000000..572fa45
--- /dev/null
+++ b/tests/generic/029.out
@@ -0,0 +1,78 @@
+QA output created by 029
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
+cf845a781c107ec1346e849c9dd1b7e8
+	4. hole -> data
+0: [0..31]: hole
+1: [32..47]: extent
+2: [48..55]: hole
+adb08a6d94a3b5eff90fdfebb2366d31
+	5. hole -> unwritten
+0: [0..31]: hole
+1: [32..47]: extent
+2: [48..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..55]: hole
+be0f35d4292a20040766d87883b0abd1
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+be0f35d4292a20040766d87883b0abd1
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+adb08a6d94a3b5eff90fdfebb2366d31
+	10. hole -> data -> hole
+0: [0..39]: hole
+1: [40..47]: extent
+2: [48..63]: hole
+0487b3c52810f994c541aa166215375f
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
+0487b3c52810f994c541aa166215375f
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
index e822dfd..b1dc921 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -31,6 +31,7 @@
 026 acl quick auto
 027 auto enospc
 028 auto quick
+029 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

