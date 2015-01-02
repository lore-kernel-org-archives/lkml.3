Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbbABJlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:41:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51101 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbABJlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:41:25 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-18-54a667c37e09
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 4/11] xfsprogs: xfs_io: add finsert command for insert range
 via fallocate
Date: Fri, 02 Jan 2015 18:41:23 +0900
Message-id: <004201d02670$45154980$cf3fdc80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmbxHNouSJ6TVcQxKsCqf66EHtKg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkRPdw+rIQgwMrxCyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYIvisklJzcksSy3St0vgyvh14DVLwV3BimcTVrE1MM7g62Lk5JAQMJF4/OUr
	C4QtJnHh3nq2LkYuDiGBpYwSB47fZ4Qp2vJwCgtEYjqjxNl7L1ghnL+MEotalrJ3MXJwsAlo
	S/zZIgrSICLgKjHv7ndGkBpmgROMEusnLwFbISwQLzFx4msmEJtFQFXi6d3LYHFeAUuJQ9PX
	sEHYghI/Jt8DizMLaEms33mcCcKWl9i85i0zxEUKEjvOvmaEWKYn0Tb1HCNEjYjEvhfvoK6+
	xy7RMdEaYpeAxLfJh1hA7pQQkJXYdABqjKTEwRU3WCYwis1CsnkWks2zkGyehWTDAkaWVYyi
	qQXJBcVJ6UUmesWJucWleel6yfm5mxiB8Xn637MJOxjvHbA+xCjAwajEw6twbWmIEGtiWXFl
	7iFGU6CLJjJLiSbnA5NAXkm8obGZkYWpiamxkbmlmZI472upn8FCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGDnUplw7b/hi+d1usWsfG9u5rKZ/mnpNzSn454r1pxhytBafrF59LfBUzL+d
	s3je3mC9ZXEhJjjiZ/KOCcH13+/MOagUdfu0rDazjk0+tytDo/uXfZ6Prq/v61vxiUU01Cta
	95Xc5uBd2i/Pecnl35qQ2x52a86ddPXJ5gfr0s2Cjuk9Dd48t0yJpTgj0VCLuag4EQDWsc+5
	ygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoO7h9GUhBnfa+SyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx68BrloK7
	ghXPJqxia2CcwdfFyMkhIWAiseXhFBYIW0ziwr31bF2MXBxCAtMZJc7ee8EK4fxllFjUspS9
	i5GDg01AW+LPFlGQBhEBV4l5d78zgtQwC5xglFg/eQnYJGGBeImJE18zgdgsAqoST+9eBovz
	ClhKHJq+hg3CFpT4MfkeWJxZQEti/c7jTBC2vMTmNW+ZIS5SkNhx9jUjxDI9ibap5xghakQk
	9r14xziBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx/8z
	qR2MKxssDjEKcDAq8fAqXFsaIsSaWFZcmXuIUYKDWUmEt09uSYgQb0piZVVqUX58UWlOavEh
	RlOgTycyS4km5wNTU15JvKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6YklqdmpqQWoRTB8TB6cU
	MH2wWwYd/n26c3rGgwZW/cVMBm++p9hF5D3m/l4VIze5dvndllbPp0s8pi9K+eKuaPc0WPPk
	n7tVdo+DQs4du/iaeW/kUnaj+Tes58x7Nz03uLRu5XcVixmuD128Z8meV2oV+sr/WDbkoeuu
	+jmfDWPa6h0zmA21T6YvWLJx9/pifYG5V8K1LyqxFGckGmoxFxUnAgD522aqFQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add finsert command for fallocate FALLOC_FL_INSERT_RANGE flag.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 io/prealloc.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index aba6b44..11b1e12 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -37,6 +37,10 @@
 #define FALLOC_FL_ZERO_RANGE 0x10
 #endif
 
+#ifndef FALLOC_FL_INSERT_RANGE
+#define FALLOC_FL_INSERT_RANGE 0x20
+#endif
+
 static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
@@ -46,6 +50,7 @@ static cmdinfo_t zero_cmd;
 static cmdinfo_t falloc_cmd;
 static cmdinfo_t fpunch_cmd;
 static cmdinfo_t fcollapse_cmd;
+static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
 #endif
 
@@ -169,11 +174,14 @@ fallocate_f(
 	int		mode = 0;
 	int		c;
 
-	while ((c = getopt(argc, argv, "ckp")) != EOF) {
+	while ((c = getopt(argc, argv, "cikp")) != EOF) {
 		switch (c) {
 		case 'c':
 			mode = FALLOC_FL_COLLAPSE_RANGE;
 			break;
+		case 'i':
+			mode = FALLOC_FL_INSERT_RANGE;
+			break;
 		case 'k':
 			mode = FALLOC_FL_KEEP_SIZE;
 			break;
@@ -237,6 +245,25 @@ fcollapse_f(
 }
 
 static int
+finsert_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_INSERT_RANGE;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	if (fallocate(file->fd, mode,
+			segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		return 0;
+	}
+	return 0;
+}
+
+static int
 fzero_f(
 	int		argc,
 	char		**argv)
@@ -345,6 +372,16 @@ prealloc_init(void)
 	_("de-allocates space and eliminates the hole by shifting extents");
 	add_command(&fcollapse_cmd);
 
+	finsert_cmd.name = "finsert";
+	finsert_cmd.cfunc = finsert_f;
+	finsert_cmd.argmin = 2;
+	finsert_cmd.argmax = 2;
+	finsert_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	finsert_cmd.args = _("off len");
+	finsert_cmd.oneline =
+	_("creates new space for writing within file by shifting extents");
+	add_command(&finsert_cmd);
+
 	fzero_cmd.name = "fzero";
 	fzero_cmd.cfunc = fzero_f;
 	fzero_cmd.argmin = 2;
-- 
1.7.11-rc0

