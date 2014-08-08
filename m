Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaHHFGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:06:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25804 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbaHHFGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:06:43 -0400
X-AuditID: cbfee690-b7f526d000003627-ff-53e45ae04b59
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 6/10] xfstests: generic/030: Delayed allocation insert range
Date: Fri, 08 Aug 2014 14:06:40 +0900
Message-id: <004701cfb2c6$89be69e0$9d3b3da0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yvtHopGdANkC+RMuDGWG+wb1Ftw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkQPdB1JNgg79rFSzefa6y2HLsHqPF
	sgebWSxmzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	z5vkAlijuGxSUnMyy1KL9O0SuDK2LUkuuK5RMfH7f5YGxgeKXYycHBICJhJ9l7cwQdhiEhfu
	rWfrYuTiEBJYyigxdc5fdpiiJQseM0EkFjFKLP2/hBnC+csoce3xYtYuRg4ONgFtiT9bREEa
	RARcJebd/c4IYjML3GGU+LXGGMQWFvCX+L26G2wbi4CqxJueA8wgNq+ApcTxd5dZIGxBiR+T
	77GAjGQW0JH4OikCYoy8xOY1b5kh7lGQ2HH2NSPEKj2Jpz372SBqRCT2vXjHCFFziV1iy181
	iFUCEt8mHwIbKSEgK7HpANQYSYmDK26wTGAUm4Vk8SyExbOQLJ6FZMECRpZVjKKpBckFxUnp
	RSZ6xYm5xaV56XrJ+bmbGIHRePrfswk7GO8dsD7EmAy0fSKzlGhyPjCa80riDY3NjCxMTUyN
	jcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUaBgKjMLf3ROyTnh203Z
	s/I2Kb6YGrqw53Nesq1OTdLDEwXOj8P0ebSfbDjF+064eGO7vHj6sytNbfPE1hvnbjr++Ulz
	xZFlTEcW/No368m0+vrC94tSWZrdasxM/QyXpd2x/SfJ1HzEwrtFo85JtuKfcyv3vTuHV8aw
	X+qTW5p40HAnx+kdSizFGYmGWsxFxYkAmhsEm9wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAd0HUU+CDc5OkrB497nKYsuxe4wW
	yx5sZrGYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYsW1JcsF1jYqJ3/+z
	NDA+UOxi5OSQEDCRWLLgMROELSZx4d56ti5GLg4hgUWMEkv/L2GGcP4ySlx7vJi1i5GDg01A
	W+LPFlGQBhEBV4l5d78zgtjMAncYJX6tMQaxhQX8JX6v7gYbyiKgKvGm5wAziM0rYClx/N1l
	FghbUOLH5HssICOZBXQkvk6KgBgjL7F5zVtmiHsUJHacfc0IsUpP4mnPfjaIGhGJfS/eMU5g
	FJiFZNIshEmzkEyahaRjASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgaH8mtYNxZYPF
	IUYBDkYlHl6B7sfBQqyJZcWVuYcYJTiYlUR4az4DhXhTEiurUovy44tKc1KLDzGaAv05kVlK
	NDkfmIjySuINjU3MjCyNzA0tjIzNlcR5D7RaBwoJpCeWpGanphakFsH0MXFwSjUwmkycedMq
	5+6/NYwfupZfW/1mqZlr1FbtvW7h7JO6r5zdnylzYxlfzuTDrHqiRuz/rtd1zDkadf/eRsNt
	821nbJYKECl0zjDsUZczqCxq+7A8LKRtdujyLqWd9ksfPSuPmqBf/zds1a4ZEpEfJp+3Wf7V
	1WKJcpWiy6Fbdmem9Sc+3cx5IFSwWomlOCPRUIu5qDgRAN0D+bYMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(030) tries to test various corner cases with delayed extents
for finsert range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/030     | 65 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/030.out | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 144 insertions(+)
 create mode 100644 tests/generic/030
 create mode 100644 tests/generic/030.out

diff --git a/tests/generic/030 b/tests/generic/030
new file mode 100644
index 0000000..7cbfa88
--- /dev/null
+++ b/tests/generic/030
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/030
+#
+# Delayed allocation insert range tests
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
+_test_generic_punch -d falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/030.out b/tests/generic/030.out
new file mode 100644
index 0000000..5812622
--- /dev/null
+++ b/tests/generic/030.out
@@ -0,0 +1,78 @@
+QA output created by 030
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
index b1dc921..b847c47 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -32,6 +32,7 @@
 027 auto enospc
 028 auto quick
 029 auto quick prealloc
+030 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

