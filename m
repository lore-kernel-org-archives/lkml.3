Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab3AaW1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:27:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3AaW1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:27:39 -0500
Date: Thu, 31 Jan 2013 14:27:28 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-d288e1cf8e62f3e4034f1f021f047009c4ac0b3c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1356075872-3054-4-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-4-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/common.c: Make have_cpuid_p()
  a global function
Git-Commit-ID: d288e1cf8e62f3e4034f1f021f047009c4ac0b3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:27:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d288e1cf8e62f3e4034f1f021f047009c4ac0b3c
Gitweb:     http://git.kernel.org/tip/d288e1cf8e62f3e4034f1f021f047009c4ac0b3c
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 20 Dec 2012 23:44:23 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 13:18:58 -0800

x86/common.c: Make have_cpuid_p() a global function

Remove static declaration in have_cpuid_p() to make it a global function. The
function will be called in early loading microcode.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1356075872-3054-4-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h | 8 ++++++++
 arch/x86/kernel/cpu/common.c     | 9 +++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index bdee8bd..3cdf4aa 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -190,6 +190,14 @@ extern void init_amd_cacheinfo(struct cpuinfo_x86 *c);
 extern void detect_extended_topology(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
 
+#ifdef CONFIG_X86_32
+extern int have_cpuid_p(void);
+#else
+static inline int have_cpuid_p(void)
+{
+	return 1;
+}
+#endif
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9c3ab43..d7fd246 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -37,6 +37,8 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/pat.h>
+#include <asm/microcode.h>
+#include <asm/microcode_intel.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/uv/uv.h>
@@ -213,7 +215,7 @@ static inline int flag_is_changeable_p(u32 flag)
 }
 
 /* Probe for the CPUID instruction */
-static int __cpuinit have_cpuid_p(void)
+int __cpuinit have_cpuid_p(void)
 {
 	return flag_is_changeable_p(X86_EFLAGS_ID);
 }
@@ -249,11 +251,6 @@ static inline int flag_is_changeable_p(u32 flag)
 {
 	return 1;
 }
-/* Probe for the CPUID instruction */
-static inline int have_cpuid_p(void)
-{
-	return 1;
-}
 static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 {
 }
