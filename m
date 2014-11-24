Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaKXSz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:55:58 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:58509 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaKXSz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:55:56 -0500
From: Zahari Doychev <zahari.doychev@linux.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        bergwolf@gmail.com
Subject: [PATCH 1/2] [drivers] staging/lustre: fix sparse warnings
Date: Mon, 24 Nov 2014 19:55:41 +0100
Message-Id: <76b947454ee1a19847633c913f8ac28520aa0574.1416853961.git.zahari.doychev@linux.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1416853961.git.zahari.doychev@linux.com>
References: <cover.1416853961.git.zahari.doychev@linux.com>
In-Reply-To: <cover.1416853961.git.zahari.doychev@linux.com>
References: <cover.1416853961.git.zahari.doychev@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

lib-lnet.h:787:47: warning: incorrect type in initializer (different address spaces)
lib-lnet.h:787:47:    expected void [noderef] <asn:1>*iov_base
lib-lnet.h:787:47:    got void *dest

Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
---
 drivers/staging/lustre/include/linux/lnet/lib-lnet.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
index 7e89b3b..ec70f40 100644
--- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
+++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
@@ -784,7 +784,8 @@ lnet_copy_iov2flat(int dlen, void *dest, unsigned int doffset,
 		   unsigned int nsiov, struct iovec *siov, unsigned int soffset,
 		   unsigned int nob)
 {
-	struct iovec diov = {/*.iov_base = */ dest, /*.iov_len = */ dlen};
+	struct iovec diov = {/*.iov_base = */ (void __user *)dest,
+			     /*.iov_len = */ dlen};
 
 	lnet_copy_iov2iov(1, &diov, doffset,
 			  nsiov, siov, soffset, nob);
@@ -795,7 +796,8 @@ lnet_copy_kiov2flat(int dlen, void *dest, unsigned int doffset,
 		    unsigned int nsiov, lnet_kiov_t *skiov,
 		    unsigned int soffset, unsigned int nob)
 {
-	struct iovec diov = {/* .iov_base = */ dest, /* .iov_len = */ dlen};
+	struct iovec diov = {/* .iov_base = */ (void __user *)dest,
+			     /* .iov_len = */ dlen};
 
 	lnet_copy_kiov2iov(1, &diov, doffset,
 			   nsiov, skiov, soffset, nob);
@@ -803,9 +805,10 @@ lnet_copy_kiov2flat(int dlen, void *dest, unsigned int doffset,
 
 static inline void
 lnet_copy_flat2iov(unsigned int ndiov, struct iovec *diov, unsigned int doffset,
-		   int slen, void *src, unsigned int soffset, unsigned int nob)
+	   int slen, void *src, unsigned int soffset, unsigned int nob)
 {
-	struct iovec siov = {/*.iov_base = */ src, /*.iov_len = */slen};
+	struct iovec siov = {/*.iov_base = */ (void __user *)src,
+			     /*.iov_len = */ slen};
 
 	lnet_copy_iov2iov(ndiov, diov, doffset,
 			  1, &siov, soffset, nob);
@@ -816,7 +819,8 @@ lnet_copy_flat2kiov(unsigned int ndiov, lnet_kiov_t *dkiov,
 		    unsigned int doffset, int slen, void *src,
 		    unsigned int soffset, unsigned int nob)
 {
-	struct iovec siov = {/* .iov_base = */ src, /* .iov_len = */ slen};
+	struct iovec siov = {/* .iov_base = */ (void __user *)src,
+			     /* .iov_len = */ slen};
 
 	lnet_copy_iov2kiov(ndiov, dkiov, doffset,
 			   1, &siov, soffset, nob);
-- 
2.1.0

