Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaHHFGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:06:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25690 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbaHHFGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:06:32 -0400
X-AuditID: cbfee691-b7f306d000003d81-e5-53e45ad24e57
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 4/10] xfsprogs: xfs_io: add finsert command for insert range
 via fallocate
Date: Fri, 08 Aug 2014 14:06:26 +0900
Message-id: <004501cfb2c6$81801f80$84805e80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yvoP/t8Q4vyYeTd2Z+8W0I8agCw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkQPdS1JNgg0WNWhbvPldZbDl2j9Fi
	2YPNLBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKpvH
	501yAaxRXDYpqTmZZalF+nYJXBm/DrxmKbgrWPFswiq2BsYZfF2MnBwSAiYSM+//Z4OwxSQu
	3FsPZgsJLGWUmP5JCaZm9pP3zF2MXEDxRYwSWw9MY4Io+ssoseyRRxcjBwebgLbEny2iIGER
	AVeJeXe/M4LYzAJ3GCV+rTEGsYUF4iW2zZkBNp9FQFXiwOReMJtXwFJiyoz77BC2oMSPyfdY
	QEYyC+hIfJ0UATFGXmLzmrfMEOcoSOw4+5oRYpWexMbONcwQNSIS+168YwQ5U0LgGrtEa9tO
	qF0CEt8mHwKbKSEgK7HpANQcSYmDK26wTGAUm4Vk8yyEzbOQbJ6FZMMCRpZVjKKpBckFxUnp
	RaZ6xYm5xaV56XrJ+bmbGIHRePrfs4k7GO8fsD7EmAy0fSKzlGhyPjCa80riDY3NjCxMTUyN
	jcwtzUgTVhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMVNiBU/Cw8nL9hx30ZXd
	OjVeouPC+5UsRfpv970N0LxxacHG6hV1x9n+xFULxfuohypJCorWLcsMY0xhqp6g6aQ/o3Db
	w65PfNPee9bvujy5siYoTOxyQU3xR/+U080h4bG7bE5OE45XWXLOTaym1OrnykcRnxnOKN3e
	aX8p9VLqJFf/51s3KLEUZyQaajEXFScCAPJo+cXcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAd1LUU+CDZ5/VLR497nKYsuxe4wW
	yx5sZrGYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8evAa5aCu4IVzyas
	YmtgnMHXxcjJISFgIjH7yXtmCFtM4sK99WxdjFwcQgKLGCW2HpjGBJIQEvjLKLHskUcXIwcH
	m4C2xJ8toiBhEQFXiXl3vzOC2MwCdxglfq0xBrGFBeIlts2ZwQZiswioShyY3Atm8wpYSkyZ
	cZ8dwhaU+DH5HgvISGYBHYmvkyIgxshLbF7zFuocBYkdZ18zQqzSk9jYuYYZokZEYt+Ld4wT
	GAVmIZk0C2HSLCSTZiHpWMDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjONqfSe9gXNVg
	cYhRgINRiYdXoPtxsBBrYllxZe4hRgkOZiUR3prPQCHelMTKqtSi/Pii0pzU4kOMpkB/TmSW
	Ek3OByaivJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjNJyPyuc
	J/93fm7x+MCcZx+8Lhw20Tq0cRVjVdiPr9rvswx4J/6dOO3cTHUJbUcry0+np/5bl1D1Uiz+
	0Lab97pM2y7Y/zlpGr95ZnJt+f575r9/pm98X7rrZY609gl9e2bhn1+q1i10sz74oJFtRX7J
	7JlpLX3qTpobXBSaDYweLqo70XPRp0GJpTgj0VCLuag4EQBPBNwiDAMAAA==
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

