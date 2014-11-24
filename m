Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaKXGRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:17:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24605 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaKXGRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:17:06 -0500
X-AuditID: cbfee68d-f79296d000004278-32-5472cd605b25
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v6 8/10] xfstests: generic/041: Delayed allocation multi insert
Date: Mon, 24 Nov 2014 15:17:03 +0900
Message-id: <003101d007ae$43db3dd0$cb91b970$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAHrYBh9OZ4pxRDR0y7jADD+YLUvA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkQDfhbFGIwfX7PBZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NYrLJiU1J7MstUjfLoErY21jI1PBFs2K3dPWsTQwrlXqYuTkkBAwkXhy5AAThC0mceHeerYu
	Ri4OIYGljBIvzpxmhym6fWImE0RiOqPExkdroar+AjnzrjJ3MXJwsAloS/zZIgrSICLgKjHv
	7ndGkBpmkEkXHz9hBEkIC/hL9D9ZyAxiswioSux4cg1sNa+ApcTxWcdZIWxBiR+T77GA2MwC
	WhLrdx5ngrDlJTavecsMcZGCxI6zrxkhlulJHNjxlRmiRkRi34t3jBA159glvnWnQewSkPg2
	+RALyJ0SArISmw5AjZGUOLjiBssERrFZSDbPQrJ5FpLNs5BsWMDIsopRNLUguaA4Kb3IUK84
	Mbe4NC9dLzk/dxMjMBpP/3vWu4Px9gHrQ4wCHIxKPLwfNhaFCLEmlhVX5h5iNAW6aCKzlGhy
	PjDm80riDY3NjCxMTUyNjcwtzZTEeRWlfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJTY
	wH3O9bjNn5wVk5KbCpZ5yjvtlBJLP6109OX3bM3u9jmXFhXPkxOSLe+zsS2vdNxVHXllW1X4
	+7DTkpZbD9+am8Fzo2+WR1LVSfWDeUVHt17IOWAXELG3f6N2okeXUdxkzSLbPxY1W7ZI/3nb
	JxXmkRyXerzzx9ldjLfzd2pvdLvv/T+hQYmlOCPRUIu5qDgRAKboBD/BAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd2Es0UhBo9/sFgsnXiJ2WLLsXuM
	FjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowO5xapGER9OZo8weqy9sZfTo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBlrGxuZCrZoVuyeto6lgXGt
	UhcjJ4eEgInE7RMzmSBsMYkL99azdTFycQgJTGeU2PhoLZTzF8iZd5W5i5GDg01AW+LPFlGQ
	BhEBV4l5d78zgtQwCyxllLj4+AkjSEJYwF+i/8lCZhCbRUBVYseTa2AbeAUsJY7POs4KYQtK
	/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIixQkdpx9zQixTE/iwI6vzBA1IhL7XrxjnMAoMAvJ
	qFlIRs1CMmoWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKj/ZnUDsaVDRaHGAU4
	GJV4eD9sLAoRYk0sK67MPcQowcGsJMJ79l9hiBBvSmJlVWpRfnxRaU5q8SFGU6BPJzJLiSbn
	AxNRXkm8obGJmZGlkbmhhZGxuZI4742buSFCAumJJanZqakFqUUwfUwcnFINjFo8SjZfm2yP
	1Wop3FyU9Xa7R9JhNc5rW7fuyH0f38z/6riFm4T9X4Ycx0MeW+87G39dUFi072NuzoSMpxaH
	c45wFJnditQR+fKdt0b9VcRM3rOfEnREg0oyHNa1ny6z+JGXdMkyuuzwRc4J+b//5jHY9HN6
	74l5+kwvgutG1rq5976Lq76XUGIpzkg01GIuKk4EABQnOlUMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(041) tries to test various corner cases with delayed extents and
pre-existing holes for finsert range functionality over different type of
extents.

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
index 0000000..abaa2f4
--- /dev/null
+++ b/tests/generic/041
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/041
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
index 9d5f72d..34e223d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -43,6 +43,7 @@
 038 auto quick prealloc
 039 auto quick prealloc
 040 auto quick prealloc
+041 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

