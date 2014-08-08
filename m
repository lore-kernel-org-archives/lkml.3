Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaHHFHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:07:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50936 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaHHFGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:06:52 -0400
X-AuditID: cbfee690-b7f526d000003627-6a-53e45ae98268
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 7/10] xfstests: generic/031: Multi insert range tests
Date: Fri, 08 Aug 2014 14:06:49 +0900
Message-id: <004801cfb2c6$8f712760$ae537620$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yvyLkil/6/WKKSBymP0M64Z84eA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkUPdV1JNgg947rBbvPldZbDl2j9Fi
	2YPNLBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKpvH
	501yAaxRXDYpqTmZZalF+nYJXBkrDp9jKmjQrJj6dBpLA2OjUhcjJ4eEgInEnoMtzBC2mMSF
	e+vZQGwhgaWMErOO68PUnDj3n72LkQsoPp1RYvmXo4wQzl9GifYpd4AcDg42AW2JP1tEQRpE
	BFwl5t39zghiMwvcYZT4tcYYxBYW8JDY+PU42AIWAVWJn3s3sIDYvAKWEnvaZjBB2IISPybf
	YwEZySygI/F1UgTEGHmJzWveQt2pILHj7GtGiFV6Epfnf2GFqBGR2PfiHSNEzSV2ibed/hCr
	BCS+TT4ENlJCQFZi0wGoMZISB1fcYJnAKDYLyeJZCItnIVk8C8mCBYwsqxhFUwuSC4qT0otM
	9IoTc4tL89L1kvNzNzECo/H0v2cTdjDeO2B9iDEZaPtEZinR5HxgNOeVxBsamxlZmJqYGhuZ
	W5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2P1miKN1rWzbJr3nJr/J+R9
	cu8XDnO5mz93rrjK4bZuWUnTz7mnhF0EAq3D5M393ar7G+W/izjPy7ZjTuzaE31+/pr2/qDZ
	VassOCxqFzmuFFLvCuebvnSu74EbCtI/GrrPuAu/Kn6540xhNvfZ+w2zUiI7K3eeuNndvo9H
	Omri3MwTW54bGSmxFGckGmoxFxUnAgB/lpsZ3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd2XUU+CDXouWVm8+1xlseXYPUaL
	ZQ82s1jMnHeHzWLP3pMsFpd3zWGzaO35yW6xqO8WowOHx6lFEh5NZ44ye6y+sJXR4/2+q2we
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWHH4HFNBg2bF1KfT
	WBoYG5W6GDk5JARMJE6c+88OYYtJXLi3nq2LkYtDSGA6o8TyL0cZIZy/jBLtU+4AORwcbALa
	En+2iII0iAi4Ssy7+50RxGYWuMMo8WuNMYgtLOAhsfHrcTYQm0VAVeLn3g0sIDavgKXEnrYZ
	TBC2oMSPyfdYQEYyC+hIfJ0UATFGXmLzmrfMEPcoSOw4+5oRYpWexOX5X1ghakQk9r14xziB
	UWAWkkmzECbNQjJpFpKOBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC4/2Z1A7GlQ0W
	hxgFOBiVeHgFuh8HC7EmlhVX5h5ilOBgVhLhrfkMFOJNSaysSi3Kjy8qzUktPsRoCvTnRGYp
	0eR8YCrKK4k3NDYxM7I0Mje0MDI2VxLnPdBqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAuGtiBx+7
	0HP7th03/QP9buzZXqAXFfH+s9atrYYvlGIj3xyqzn3ZPCk0aplTjHDIfm+mg/f31iz77pu3
	b9PJB4duPGU8tJqb+88XZsH6GRNq16ts0Kq8a6bf1f/inYnRNlnRbMEpvAbnJ2863VyeEicm
	oSY3I8098sqx/YqXVbI9p2fc0rr9T4mlOCPRUIu5qDgRACXKRfsNAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(031) tries to test various corner cases with pre-existing holes
for finsert range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/031     | 65 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/031.out | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 146 insertions(+)
 create mode 100644 tests/generic/031
 create mode 100644 tests/generic/031.out

diff --git a/tests/generic/031 b/tests/generic/031
new file mode 100644
index 0000000..0e18f87
--- /dev/null
+++ b/tests/generic/031
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/031
+#
+# Multi insert range tests
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
+_test_generic_punch -k falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/031.out b/tests/generic/031.out
new file mode 100644
index 0000000..ae45352
--- /dev/null
+++ b/tests/generic/031.out
@@ -0,0 +1,80 @@
+QA output created by 031
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
index b847c47..544d422 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -33,6 +33,7 @@
 028 auto quick
 029 auto quick prealloc
 030 auto quick prealloc
+031 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

