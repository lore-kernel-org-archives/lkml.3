Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080Ab3E1NSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:18:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986Ab3E1NSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:18:54 -0400
Date: Tue, 28 May 2013 06:18:13 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-01682576d5fd1c92b96d79560b17208a6567c331@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, mst@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1369577426-26721-4-git-send-email-mst@redhat.com>
References: <1369577426-26721-4-git-send-email-mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/mm] m32r: uaccess s/might_sleep/might_fault/
Git-Commit-ID: 01682576d5fd1c92b96d79560b17208a6567c331
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01682576d5fd1c92b96d79560b17208a6567c331
Gitweb:     http://git.kernel.org/tip/01682576d5fd1c92b96d79560b17208a6567c331
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 26 May 2013 17:30:51 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:41:07 +0200

m32r: uaccess s/might_sleep/might_fault/

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1369577426-26721-4-git-send-email-mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
