Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaKKSpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:45:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:15362 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaKKSn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:43:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414941153"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Subject: [PATCH 1/6] x86: Add support for the pcommit instruction
Date: Tue, 11 Nov 2014 11:43:11 -0700
Message-Id: <1415731396-19364-2-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: x86@kernel.org
---
 arch/x86/include/asm/cpufeature.h    | 1 +
 arch/x86/include/asm/special_insns.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0bb1335..b3e6b89 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -225,6 +225,7 @@
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

