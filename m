Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3AUNI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:08:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42364 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab3AUNIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:08:55 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, msr: Unify variable names
Date: Mon, 21 Jan 2013 14:11:51 +0100
Message-Id: <1358773911-4544-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Make sure all MSR-accessing primitives which split MSR values in
two 32-bit parts have their variables called 'low' and 'high' for
consistence with the rest of the code and for ease of staring.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/msr.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 9264802e2824..cb7502852acb 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -137,11 +137,11 @@ static inline unsigned long long native_read_pmc(int counter)
  * pointer indirection), this allows gcc to optimize better
  */
 
-#define rdmsr(msr, val1, val2)					\
+#define rdmsr(msr, low, high)					\
 do {								\
 	u64 __val = native_read_msr((msr));			\
-	(void)((val1) = (u32)__val);				\
-	(void)((val2) = (u32)(__val >> 32));			\
+	(void)((low) = (u32)__val);				\
+	(void)((high) = (u32)(__val >> 32));			\
 } while (0)
 
 static inline void wrmsr(unsigned msr, unsigned low, unsigned high)
@@ -162,12 +162,12 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 }
 
 /* rdmsr with exception handling */
-#define rdmsr_safe(msr, p1, p2)					\
+#define rdmsr_safe(msr, low, high)				\
 ({								\
 	int __err;						\
 	u64 __val = native_read_msr_safe((msr), &__err);	\
-	(*p1) = (u32)__val;					\
-	(*p2) = (u32)(__val >> 32);				\
+	(*low) = (u32)__val;					\
+	(*high) = (u32)(__val >> 32);				\
 	__err;							\
 })
 
@@ -208,7 +208,7 @@ do {                                                            \
 #define wrmsrl_safe(msr, val) wrmsr_safe((msr), (u32)(val),		\
 					     (u32)((val) >> 32))
 
-#define write_tsc(val1, val2) wrmsr(MSR_IA32_TSC, (val1), (val2))
+#define write_tsc(low, high) wrmsr(MSR_IA32_TSC, (low), (high))
 
 #define write_rdtscp_aux(val) wrmsr(MSR_TSC_AUX, (val), 0)
 
-- 
1.8.1.rc3

