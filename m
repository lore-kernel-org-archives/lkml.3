Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3EXOR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:17:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab3EXOR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:17:26 -0400
Date: Fri, 24 May 2013 17:17:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: [PATCH v3 01/11] asm-generic: uaccess s/might_sleep/might_fault/
Message-ID: <1369404522-12927-1-git-send-email-mst@redhat.com>
References: <cover.1368702323.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1368702323.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/asm-generic/uaccess.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index c184aa8..dc1269c 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -163,7 +163,7 @@ static inline __must_check long __copy_to_user(void __user *to,
 
 #define put_user(x, ptr)					\
 ({								\
-	might_sleep();						\
+	might_fault();						\
 	access_ok(VERIFY_WRITE, ptr, sizeof(*ptr)) ?		\
 		__put_user(x, ptr) :				\
 		-EFAULT;					\
@@ -225,7 +225,7 @@ extern int __put_user_bad(void) __attribute__((noreturn));
 
 #define get_user(x, ptr)					\
 ({								\
-	might_sleep();						\
+	might_fault();						\
 	access_ok(VERIFY_READ, ptr, sizeof(*ptr)) ?		\
 		__get_user(x, ptr) :				\
 		-EFAULT;					\
@@ -255,7 +255,7 @@ extern int __get_user_bad(void) __attribute__((noreturn));
 static inline long copy_from_user(void *to,
 		const void __user * from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (access_ok(VERIFY_READ, from, n))
 		return __copy_from_user(to, from, n);
 	else
@@ -265,7 +265,7 @@ static inline long copy_from_user(void *to,
 static inline long copy_to_user(void __user *to,
 		const void *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (access_ok(VERIFY_WRITE, to, n))
 		return __copy_to_user(to, from, n);
 	else
@@ -336,7 +336,7 @@ __clear_user(void __user *to, unsigned long n)
 static inline __must_check unsigned long
 clear_user(void __user *to, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (!access_ok(VERIFY_WRITE, to, n))
 		return n;
 
-- 
MST
