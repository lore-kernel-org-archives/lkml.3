Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab3DCAVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:21:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab3DCAVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:21:40 -0400
Date: Tue, 2 Apr 2013 17:20:46 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-1423bed239415edd1562c25be8a7408858fdbb19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1362428180-8865-5-git-send-email-bp@alien8.de>
References: <1362428180-8865-5-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, msr: Unify variable names
Git-Commit-ID: 1423bed239415edd1562c25be8a7408858fdbb19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 17:20:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1423bed239415edd1562c25be8a7408858fdbb19
Gitweb:     http://git.kernel.org/tip/1423bed239415edd1562c25be8a7408858fdbb19
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 4 Mar 2013 21:16:19 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Apr 2013 16:03:32 -0700

x86, msr: Unify variable names

Make sure all MSR-accessing primitives which split MSR values in
two 32-bit parts have their variables called 'low' and 'high' for
consistence with the rest of the code and for ease of staring.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1362428180-8865-5-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/msr.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 9264802..cb75028 100644
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
 
