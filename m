Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab3EPLN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:13:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab3EPLN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:13:26 -0400
Date: Thu, 16 May 2013 14:11:04 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        microblaze-uclinux@itee.uq.edu.au, linux-am33-list@redhat.com,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org
Subject: [PATCH v2 04/10] m32r: uaccess s/might_sleep/might_fault/
Message-ID: <8b99c8a5fb9dc4ee9a39f96ecb3b9c02c97a8ba2.1368702323.git.mst@redhat.com>
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
 arch/m32r/include/asm/uaccess.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/m32r/include/asm/uaccess.h b/arch/m32r/include/asm/uaccess.h
index 1c7047b..84fe7ba 100644
--- a/arch/m32r/include/asm/uaccess.h
+++ b/arch/m32r/include/asm/uaccess.h
@@ -216,7 +216,7 @@ extern int fixup_exception(struct pt_regs *regs);
 ({									\
 	long __gu_err = 0;						\
 	unsigned long __gu_val;						\
-	might_sleep();							\
+	might_fault();							\
 	__get_user_size(__gu_val,(ptr),(size),__gu_err);		\
 	(x) = (__typeof__(*(ptr)))__gu_val;				\
 	__gu_err;							\
@@ -227,7 +227,7 @@ extern int fixup_exception(struct pt_regs *regs);
 	long __gu_err = -EFAULT;					\
 	unsigned long __gu_val = 0;					\
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
-	might_sleep();							\
+	might_fault();							\
 	if (access_ok(VERIFY_READ,__gu_addr,size))			\
 		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
 	(x) = (__typeof__(*(ptr)))__gu_val;				\
@@ -295,7 +295,7 @@ do {									\
 #define __put_user_nocheck(x,ptr,size)					\
 ({									\
 	long __pu_err;							\
-	might_sleep();							\
+	might_fault();							\
 	__put_user_size((x),(ptr),(size),__pu_err);			\
 	__pu_err;							\
 })
@@ -305,7 +305,7 @@ do {									\
 ({									\
 	long __pu_err = -EFAULT;					\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
-	might_sleep();							\
+	might_fault();							\
 	if (access_ok(VERIFY_WRITE,__pu_addr,size))			\
 		__put_user_size((x),__pu_addr,(size),__pu_err);		\
 	__pu_err;							\
@@ -597,7 +597,7 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  */
 #define copy_to_user(to,from,n)				\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__generic_copy_to_user((to),(from),(n));	\
 })
 
@@ -638,7 +638,7 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  */
 #define copy_from_user(to,from,n)			\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__generic_copy_from_user((to),(from),(n));	\
 })
 
-- 
MST

