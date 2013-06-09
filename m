Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3FIKHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 06:07:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47451 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab3FIKHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 06:07:37 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/5] x86, cpu: Add a synthetic cpu feature
Date: Sun,  9 Jun 2013 12:07:30 +0200
Message-Id: <1370772454-6106-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370772454-6106-1-git-send-email-bp@alien8.de>
References: <1370772454-6106-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This will be used in alternatives later as an always-replace flag.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 2 +-
 arch/x86/kernel/cpu/common.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e99ac27f95b2..043d61e66efc 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -92,7 +92,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-					  /* 21 available, was AMD_C1E */
+#define X86_FEATURE_ALWAYS	(3*32+21) /* "" Always-present feature */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22018f70a671..6a0361d7132c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -724,6 +724,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 	if (this_cpu->c_bsp_init)
 		this_cpu->c_bsp_init(c);
+
+	setup_force_cpu_cap(X86_FEATURE_ALWAYS);
 }
 
 void __init early_cpu_init(void)
-- 
1.8.3

