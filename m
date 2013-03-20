Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964922Ab3CTJ0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:26:07 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37693 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab3CTJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:24:54 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 27/30] compat: embrace LINUX_BACKPORT() for kfifo
Date: Wed, 20 Mar 2013 02:22:52 -0700
Message-Id: <1363771375-31715-28-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/linux/kfifo.h |  146 ++++++++++++++++++++++++++++---------------------
 1 file changed, 83 insertions(+), 63 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index e30bb54..398b00d 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -187,6 +187,89 @@ __kfifo_int_must_check_helper(int val)
 	return val;
 }
 
+#define __kfifo_alloc LINUX_BACKPORT(__kfifo_alloc)
+extern int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
+	size_t esize, gfp_t gfp_mask);
+#define __kfifo_free LINUX_BACKPORT(__kfifo_free)
+extern void __kfifo_free(struct __kfifo *fifo);
+
+#define __kfifo_init LINUX_BACKPORT(__kfifo_init)
+extern int __kfifo_init(struct __kfifo *fifo, void *buffer,
+	unsigned int size, size_t esize);
+
+#define __kfifo_in LINUX_BACKPORT(__kfifo_in)
+extern unsigned int __kfifo_in(struct __kfifo *fifo,
+	const void *buf, unsigned int len);
+
+#define __kfifo_out LINUX_BACKPORT(__kfifo_out)
+extern unsigned int __kfifo_out(struct __kfifo *fifo,
+	void *buf, unsigned int len);
+
+#define __kfifo_from_user LINUX_BACKPORT(__kfifo_from_user)
+extern int __kfifo_from_user(struct __kfifo *fifo,
+	const void __user *from, unsigned long len, unsigned int *copied);
+
+#define __kfifo_to_user LINUX_BACKPORT(__kfifo_to_user)
+extern int __kfifo_to_user(struct __kfifo *fifo,
+	void __user *to, unsigned long len, unsigned int *copied);
+
+#define __kfifo_dma_in_prepare LINUX_BACKPORT(__kfifo_dma_in_prepare)
+extern unsigned int __kfifo_dma_in_prepare(struct __kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len);
+
+#define __kfifo_dma_out_prepare LINUX_BACKPORT(__kfifo_dma_out_prepare)
+extern unsigned int __kfifo_dma_out_prepare(struct __kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len);
+
+#define __kfifo_out_peek LINUX_BACKPORT(__kfifo_out_peek)
+extern unsigned int __kfifo_out_peek(struct __kfifo *fifo,
+	void *buf, unsigned int len);
+
+#define __kfifo_in_r LINUX_BACKPORT(__kfifo_in_r)
+extern unsigned int __kfifo_in_r(struct __kfifo *fifo,
+	const void *buf, unsigned int len, size_t recsize);
+
+#define __kfifo_out_r LINUX_BACKPORT(__kfifo_out_r)
+extern unsigned int __kfifo_out_r(struct __kfifo *fifo,
+	void *buf, unsigned int len, size_t recsize);
+
+#define __kfifo_from_user_r LINUX_BACKPORT(__kfifo_from_user_r)
+extern int __kfifo_from_user_r(struct __kfifo *fifo,
+	const void __user *from, unsigned long len, unsigned int *copied,
+	size_t recsize);
+
+#define __kfifo_to_user_r LINUX_BACKPORT(__kfifo_to_user_r)
+extern int __kfifo_to_user_r(struct __kfifo *fifo, void __user *to,
+	unsigned long len, unsigned int *copied, size_t recsize);
+
+#define __kfifo_dma_in_prepare_r LINUX_BACKPORT(__kfifo_dma_in_prepare_r)
+extern unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize);
+
+#define __kfifo_dma_in_finish_r LINUX_BACKPORT(__kfifo_dma_in_finish_r)
+extern void __kfifo_dma_in_finish_r(struct __kfifo *fifo,
+	unsigned int len, size_t recsize);
+
+#define __kfifo_dma_out_prepare_r LINUX_BACKPORT(__kfifo_dma_out_prepare_r)
+extern unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize);
+
+#define __kfifo_dma_out_finish_r LINUX_BACKPORT(__kfifo_dma_out_finish_r)
+extern void __kfifo_dma_out_finish_r(struct __kfifo *fifo, size_t recsize);
+
+#define __kfifo_len_r LINUX_BACKPORT(__kfifo_len_r)
+extern unsigned int __kfifo_len_r(struct __kfifo *fifo, size_t recsize);
+
+#define __kfifo_skip_r LINUX_BACKPORT(__kfifo_skip_r)
+extern void __kfifo_skip_r(struct __kfifo *fifo, size_t recsize);
+
+#define __kfifo_out_peek_r LINUX_BACKPORT(__kfifo_out_peek_r)
+extern unsigned int __kfifo_out_peek_r(struct __kfifo *fifo,
+	void *buf, unsigned int len, size_t recsize);
+
+#define __kfifo_max_r LINUX_BACKPORT(__kfifo_max_r)
+extern unsigned int __kfifo_max_r(unsigned int len, size_t recsize);
+
 /**
  * kfifo_initialized - Check if the fifo is initialized
  * @fifo: address of the fifo to check
@@ -790,68 +873,5 @@ __kfifo_uint_must_check_helper( \
 	__kfifo_out_peek(__kfifo, __buf, __n); \
 }) \
 )
-
-extern int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
-	size_t esize, gfp_t gfp_mask);
-
-extern void __kfifo_free(struct __kfifo *fifo);
-
-extern int __kfifo_init(struct __kfifo *fifo, void *buffer,
-	unsigned int size, size_t esize);
-
-extern unsigned int __kfifo_in(struct __kfifo *fifo,
-	const void *buf, unsigned int len);
-
-extern unsigned int __kfifo_out(struct __kfifo *fifo,
-	void *buf, unsigned int len);
-
-extern int __kfifo_from_user(struct __kfifo *fifo,
-	const void __user *from, unsigned long len, unsigned int *copied);
-
-extern int __kfifo_to_user(struct __kfifo *fifo,
-	void __user *to, unsigned long len, unsigned int *copied);
-
-extern unsigned int __kfifo_dma_in_prepare(struct __kfifo *fifo,
-	struct scatterlist *sgl, int nents, unsigned int len);
-
-extern unsigned int __kfifo_dma_out_prepare(struct __kfifo *fifo,
-	struct scatterlist *sgl, int nents, unsigned int len);
-
-extern unsigned int __kfifo_out_peek(struct __kfifo *fifo,
-	void *buf, unsigned int len);
-
-extern unsigned int __kfifo_in_r(struct __kfifo *fifo,
-	const void *buf, unsigned int len, size_t recsize);
-
-extern unsigned int __kfifo_out_r(struct __kfifo *fifo,
-	void *buf, unsigned int len, size_t recsize);
-
-extern int __kfifo_from_user_r(struct __kfifo *fifo,
-	const void __user *from, unsigned long len, unsigned int *copied,
-	size_t recsize);
-
-extern int __kfifo_to_user_r(struct __kfifo *fifo, void __user *to,
-	unsigned long len, unsigned int *copied, size_t recsize);
-
-extern unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
-	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize);
-
-extern void __kfifo_dma_in_finish_r(struct __kfifo *fifo,
-	unsigned int len, size_t recsize);
-
-extern unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
-	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize);
-
-extern void __kfifo_dma_out_finish_r(struct __kfifo *fifo, size_t recsize);
-
-extern unsigned int __kfifo_len_r(struct __kfifo *fifo, size_t recsize);
-
-extern void __kfifo_skip_r(struct __kfifo *fifo, size_t recsize);
-
-extern unsigned int __kfifo_out_peek_r(struct __kfifo *fifo,
-	void *buf, unsigned int len, size_t recsize);
-
-extern unsigned int __kfifo_max_r(unsigned int len, size_t recsize);
-
 #endif
 #endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)) */
-- 
1.7.10.4

