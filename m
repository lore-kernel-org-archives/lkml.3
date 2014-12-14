Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaLNQxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:53:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaLNQxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:53:12 -0500
Date: Sun, 14 Dec 2014 18:52:51 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 13/18] powerpc/uaccess: fix sparse errors
Message-ID: <1418575877-21488-14-git-send-email-mst@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418575877-21488-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio wants to read bitwise types from userspace using get_user.  At the
moment this triggers sparse errors, since the value is passed through an
integer.

Fix that up using __force.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/powerpc/include/asm/uaccess.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 9485b43..a0c071d 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -284,7 +284,7 @@ do {								\
 	if (!is_kernel_addr((unsigned long)__gu_addr))		\
 		might_fault();					\
 	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;			\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
 })
 #endif /* __powerpc64__ */
@@ -297,7 +297,7 @@ do {								\
 	might_fault();							\
 	if (access_ok(VERIFY_READ, __gu_addr, (size)))			\
 		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;				\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
 	__gu_err;							\
 })
 
@@ -308,7 +308,7 @@ do {								\
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
 	__chk_user_ptr(ptr);					\
 	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;			\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
 })
 
-- 
MST

