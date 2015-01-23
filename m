Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbbAWUlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:41:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:27345 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbbAWUkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:40:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,456,1418112000"; 
   d="scan'208";a="674998213"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 1/2] x86: Add support for the pcommit instruction
Date: Fri, 23 Jan 2015 13:40:27 -0700
Message-Id: <1422045628-16225-2-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new pcommit instruction.  This instruction was
announced in the document "Intel Architecture Instruction Set Extensions
Programming Reference" with reference number 319433-022.

https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/cpufeature.h    | 1 +
 arch/x86/include/asm/special_insns.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb9b258..dfdd689 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -220,6 +220,7 @@
 #define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		( 9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	( 9*32+20) /* Supervisor Mode Access Prevention */
+#define X86_FEATURE_PCOMMIT	( 9*32+22) /* PCOMMIT instruction */
 #define X86_FEATURE_CLFLUSHOPT	( 9*32+23) /* CLFLUSHOPT instruction */
 #define X86_FEATURE_AVX512PF	( 9*32+26) /* AVX-512 Prefetch */
 #define X86_FEATURE_AVX512ER	( 9*32+27) /* AVX-512 Exponential and Reciprocal */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index e820c08..1709a2e 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -199,6 +199,12 @@ static inline void clflushopt(volatile void *__p)
 		       "+m" (*(volatile char __force *)__p));
 }
 
+static inline void pcommit(void)
+{
+	alternative(ASM_NOP4, ".byte 0x66, 0x0f, 0xae, 0xf8",
+		    X86_FEATURE_PCOMMIT);
+}
+
 #define nop() asm volatile ("nop")
 
 
-- 
1.9.3

