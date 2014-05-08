Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaEHKav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:30:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26368 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaEHKat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:30:49 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-6b-536b5cd7247f
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
Subject: [PATCH v2 4/10] xfsprogs: xfs_io: add finsert command for insert range
 via fallocate
Date: Thu, 08 May 2014 19:30:47 +0900
Message-id: <003a01cf6aa8$933f6890$b9be39b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qqDqdsqLPPTg5S2q44W4B1WcK7w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkRPd6THawwfevehZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NYrLJiU1J7MstUjfLoEr43jXCraCR4IVX6edY2pgnMvXxcjJISFgInHt/WtmCFtM4sK99Wwg
	tpDAUkaJU2tjYGp2fPvD2MXIBRRfxCixbO8qVgjnL6PEpm0HgTo4ONgEtCX+bBEFaRAR8JRY
	fHwrG0gNs8BKRol7xz+CTRUWiJf4+2E3K4jNIqAq8ab7OzuIzStgKXHp/AI2CFtQ4sfkeywg
	NrOAlsT6nceZIGx5ic1r3kJdqiCx4+xrRohlehKPty5hhqgRkdj34h3YpRICl9gl/n5pZIJY
	JiDxbfIhFpBDJQRkJTYdgJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6
	kaFecWJucWleul5yfu4mRmA0nv73rHcH4+0D1ocYk4HWT2SWEk3OB0ZzXkm8obGZkYWpiamx
	kbmlGWnCSuK8SQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwTvy15JDFq+WNN9z1S5fr
	7wwQuHhs0/2Vy6er7ZI4f90p8e93tdKw3b3LfyS3+VeWzH8xf+P232GlRSqOmvI31vjLb0g8
	KfTj2rMDv8LfBs1k2X3gXxv3ydcht2fHaPwO3Shs1VVy61XJruB8ozlpLxfl9u+49393fOpy
	DSeuyUopdx8dfhDObarEUpyRaKjFXFScCADTkw9q3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAd3rMdnBBt2vVC2WTrzEbLHl2D1G
	i5nz7rBZ7Nl7ksXi8q45bBatPT/ZLRb13WJ0YPc4tUjCo+nMUWaP1Re2Mnr0bVnF6PF5k1wA
	a1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozjXSvYCh4JVnyddo6pgXEu
	XxcjJ4eEgInEjm9/GCFsMYkL99azdTFycQgJLGKUWLZ3FSuE85dRYtO2g0AZDg42AW2JP1tE
	QRpEBDwlFh/fCtbALLCSUeLe8Y9sIAlhgXiJvx92s4LYLAKqEm+6v7OD2LwClhKXzi9gg7AF
	JX5MvscCYjMLaEms33mcCcKWl9i85i0zxEUKEjvOvmaEWKYn8XjrEmaIGhGJfS/eMU5gFJiF
	ZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB0f5MegfjqgaLQ4wC
	HIxKPLwZzlnBQqyJZcWVuYcYJTiYlUR4efyzg4V4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5
	H5iI8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUfpVv/IH
	cZ0cDRupegMmhTtP/qrtlxD9+/X8WTW2Yw2Hdv3dJGZaPnHyyfNrTDwjt145J1UkGVV7a8G5
	2gkZ51MMs+W5307X4Tnz85W7x7SNzbeXuipHNkz+bbrv/rG+4n+H+24t9J0Z2WM12dDKQX3W
	j5jcO/VPvyz4JvNSTkdFSkj3VsWhu0osxRmJhlrMRcWJAPrXMYs6AwAA
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
+	_("allocates zeroes space after creating the hole by shifting extents");
+	add_command(&finsert_cmd);
+
 	fzero_cmd.name = "fzero";
 	fzero_cmd.cfunc = fzero_f;
 	fzero_cmd.argmin = 2;
-- 
1.7.11-rc0

