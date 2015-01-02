Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbbABJmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:42:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33930 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbABJly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:41:54 -0500
X-AuditID: cbfee68e-f79b46d000002b74-cf-54a667dfb900
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 6/11] xfstests: generic/040: Delayed allocation insert range
Date: Fri, 02 Jan 2015 18:41:51 +0900
Message-id: <004401d02670$562f2fb0$028d8f10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmb1mvFZCrPyYqTfaHrTqEAFbO+Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkSPdB+rIQg+N/mC2WTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYIvisklJzcksSy3St0vgyli6bilbwV2Niql7YxsYnyp2MXJwSAiYSKx/FtTF
	yAlkiklcuLeerYuRi0NIYCmjxMc9/awQCROJiUf2M0IkpjNKXHt2hgXC+cso0XRoPxvIJDYB
	bYk/W0RBGkQEXCXm3f0O1sAscIJRYv3kJSwgCWEBf4lVvVvYQGwWAVWJF6/nsIPYvAKWEp1X
	pkHZghI/Jt8Dq2cW0JJYv/M4E4QtL7F5zVtmiIsUJHacfc0IsUxP4veUp+wQNSIS+168Y4So
	ucUusXyeCMQuAYlvkw+xQHwsK7HpANQYSYmDK26wTGAUm4Vk8ywkm2ch2TwLyYYFjCyrGEVT
	C5ILipPSi4z0ihNzi0vz0vWS83M3MQJj8/S/Z307GG8esD7EKMDBqMTDq3BtaYgQa2JZcWXu
	IUZToIsmMkuJJucDE0BeSbyhsZmRhamJqbGRuaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU
	4kOMTBycUg2M5kvFTx7+Ir2Ha4bCk2daB71nzwqt+63YWS1hFSw72cmw/tvMpVX6kXffR7d3
	tdf9OxyX8Ph/VGyHdarXnteV862Wd1xZuFn4+WHzxmudfypmiWf5zHe7wHlGNY77/o//D3gP
	VbxZVcSu97Tt/WfhxKmZs9UED8ddvpdm/v1X3fw372dIxHgfVWIpzkg01GIuKk4EAMgigu3I	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoO799GUhBvdnWlgsnXiJ2eLd5yqL
	LcfuMVrMnHeHzWLP3pMsFpd3zWGzaO35yW6xqO8WowOHx6lFEh5NZ44ye6y+sJXR4/2+q2we
	fVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj6bqlbAV3
	NSqm7o1tYHyq2MXIySEhYCIx8ch+RghbTOLCvfVsXYxcHEIC0xklrj07wwLh/GWUaDq0HyjD
	wcEmoC3xZ4soSIOIgKvEvLvfGUFqmAVOMEqsn7yEBSQhLOAvsap3CxuIzSKgKvHi9Rx2EJtX
	wFKi88o0KFtQ4sfke2D1zAJaEut3HmeCsOUlNq95ywxxkYLEjrOvGSGW6Un8nvKUHaJGRGLf
	i3eMExgFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnD0P5Pe
	wbiqweIQowAHoxIPr8K1pSFCrIllxZW5hxglOJiVRHj75JaECPGmJFZWpRblxxeV5qQWH2I0
	Bfp0IrOUaHI+MDHllcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphakFsH0MXFwSjUw
	RgfqnlCWldVb28fPd2ubb0zED+NTLcE6ml0i17vEOC+W/z52PHxu4j+DLE0RM+8/q3PvLZ64
	Xk6eV4DJadPcpQyxdWEvtZPWtCzh6tt5LXf5v9zpExpz9Q41Gez80vaTd3FYk1TQrqhFDd5+
	sZwViaLKlf/37dS+oCZl5/H9zPVq919P+xSUWIozEg21mIuKEwHl6Fk6FAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(040) tries to test various corner cases with delayed extents
for finsert range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/040     | 65 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/040.out | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 144 insertions(+)
 create mode 100644 tests/generic/040
 create mode 100644 tests/generic/040.out

diff --git a/tests/generic/040 b/tests/generic/040
new file mode 100644
index 0000000..0c49080
--- /dev/null
+++ b/tests/generic/040
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/040
+#
+# Delayed allocation insert range tests
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
+_test_generic_punch -d falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/040.out b/tests/generic/040.out
new file mode 100644
index 0000000..34b38f9
--- /dev/null
+++ b/tests/generic/040.out
@@ -0,0 +1,78 @@
+QA output created by 040
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
index d764c78..518cf49 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -42,6 +42,7 @@
 037 metadata auto quick
 038 auto stress
 039 auto quick prealloc
+040 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.5.5

