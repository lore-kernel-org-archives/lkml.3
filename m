Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3FPEqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:46:15 -0400
Received: from ozlabs.org ([203.10.76.45]:34974 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3FPEqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:46:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Julia Lawall <julia.lawall@lip6.fr>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 1/9] PTR_RET is now PTR_ERR_OR_ZERO
Date: Sun, 16 Jun 2013 14:12:40 +0930
Message-Id: <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <87ehc2rczo.fsf@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

True, it's often used in return statements, but after much bikeshedding
it's probably better to have an explicit name.

(I tried just putting the IS_ERR check inside PTR_ERR itself and gcc
usually generated no more code.  But that clashes current expectations
of how PTR_ERR behaves, so having a separate function is better).

Suggested-by: Julia Lawall <julia.lawall@lip6.fr>
Suggested-by: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/err.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index f2edce2..ee365c4 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -52,7 +52,7 @@ static inline void * __must_check ERR_CAST(const void *ptr)
 	return (void *) ptr;
 }
 
-static inline int __must_check PTR_RET(const void *ptr)
+static inline int __must_check PTR_ERR_OR_ZERO(const void *ptr)
 {
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
@@ -60,6 +60,9 @@ static inline int __must_check PTR_RET(const void *ptr)
 		return 0;
 }
 
+/* Deprecated */
+#define PTR_RET(p) PTR_ERR_OR_ZERO(p)
+
 #endif
 
 #endif /* _LINUX_ERR_H */
-- 
1.8.1.2

