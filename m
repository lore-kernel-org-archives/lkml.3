Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaKXGRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:17:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52416 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaKXGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:16:55 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-18-5472cd550dc4
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v6 6/10] xfstests: generic/039: Delayed allocation insert range
Date: Mon, 24 Nov 2014 15:16:53 +0900
Message-id: <002f01d007ae$3d94cbd0$b8be6370$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAHrUqXoFhx1EAzR/GqkF6lIa9eNA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkQDf0bFGIwaFlxhZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NYrLJiU1J7MstUjfLoEr49O5jWwFzzUq7p2ewNLA+Faxi5GTQ0LARGLry11MELaYxIV769m6
	GLk4hASWMkrcWrWBCaZo5dl+VojEIkaJy896oKr+Mkq07//E2MXIwcEmoC3xZ4soSIOIgKvE
	vLvfGUFqmEEmPf76BGySsIC/xL+VvSwgNouAqsShZ12MIDavgKXEzUntLBC2oMSPyffAbGYB
	LYn1O48zQdjyEpvXvGWGuEhBYsfZ14wQy/QkTi65CVUvIrHvxTuwxRIC59glGm79Y4NYJiDx
	bfIhFpBDJQRkJTYdgJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kYle
	cWJucWleul5yfu4mRmA8nv73bMIOxnsHrA8xCnAwKvHwfthYFCLEmlhWXJl7iNEU6KKJzFKi
	yfnAqM8riTc0NjOyMDUxNTYytzRTEud9LfUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj
	dInsB11lhYcHkgVsnz3+8cTt9PX+pK8zl5xa/njDs2gu2YtOpxd+dD208YbqlqtRDhFSttMY
	L9TVqXMmL6u+t6otvb6t7u+mi4dC5z8pWH2uq7rIfuopr5cf5fZsOCns9ORnsXpZxGTn7CZZ
	p+YZzcHSnZyb1gjtPPLbaFEs74fjX2oYBNOClViKMxINtZiLihMBxlgL0cICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAd3Qs0UhBn/naFssnXiJ2WLLsXuM
	FjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowO5xapGER9OZo8weqy9sZfTo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmfzm1kK3iuUXHv9ASWBsa3
	il2MnBwSAiYSK8/2s0LYYhIX7q1n62Lk4hASWMQocflZD5Tzl1Giff8nxi5GDg42AW2JP1tE
	QRpEBFwl5t39zghSwyywlFHi8dcnTCAJYQF/iX8re1lAbBYBVYlDz7oYQWxeAUuJm5PaWSBs
	QYkfk++B2cwCWhLrdx5ngrDlJTavecsMcZGCxI6zrxkhlulJnFxyE6peRGLfi3eMExgFZiEZ
	NQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnC0P5PewbiqweIQowAH
	oxIP74z1RSFCrIllxZW5hxglOJiVRHjP/isMEeJNSaysSi3Kjy8qzUktPsRoCvTpRGYp0eR8
	YCLKK4k3NDYxM7I0Mje0MDI2VxLnvXEzN0RIID2xJDU7NbUgtQimj4mDU6qBUc2/Ujp69sGb
	GofKzsV8PHLSj88rV+kg24nsj+VqEl/730Q8NBLsXqvySudTk+SWx08j9rRYdARyc4sU7djL
	vXdaySXV+RGMJWn3Vi+95y1uHS/6snr5eWdxe4XkfdHb9UT+7Q5Mss/Z81mr8uuefxXP0366
	hmXUibOGJHActFyt/C3q6+8/SizFGYmGWsxFxYkAOIrFDwwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(039) tries to test various corner cases with delayed extents
for finsert range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/039     | 65 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/039.out | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 144 insertions(+)
 create mode 100644 tests/generic/039
 create mode 100644 tests/generic/039.out

diff --git a/tests/generic/039 b/tests/generic/039
new file mode 100644
index 0000000..3421f93
--- /dev/null
+++ b/tests/generic/039
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/039
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
diff --git a/tests/generic/039.out b/tests/generic/039.out
new file mode 100644
index 0000000..d1e8320
--- /dev/null
+++ b/tests/generic/039.out
@@ -0,0 +1,78 @@
+QA output created by 039
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
index 7d6f227..4beb27f 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -41,6 +41,7 @@
 036 auto aio rw stress
 037 metadata auto quick
 038 auto quick prealloc
+039 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

