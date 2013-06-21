Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422875Ab3FUAwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:52:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52102 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab3FUAwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:52:07 -0400
Date: Thu, 20 Jun 2013 17:51:37 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-c3b83598c1eeb1507603b461f5843ec2a49e3033@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1370772454-6106-2-git-send-email-bp@alien8.de>
References: <1370772454-6106-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, cpu: Add a synthetic, always true, cpu feature
Git-Commit-ID: c3b83598c1eeb1507603b461f5843ec2a49e3033
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 17:51:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3b83598c1eeb1507603b461f5843ec2a49e3033
Gitweb:     http://git.kernel.org/tip/c3b83598c1eeb1507603b461f5843ec2a49e3033
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 9 Jun 2013 12:07:30 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Jun 2013 17:06:07 -0700

x86, cpu: Add a synthetic, always true, cpu feature

This will be used in alternatives later as an always-replace flag.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1370772454-6106-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h | 2 +-
 arch/x86/kernel/cpu/common.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e99ac27..043d61e 100644
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
index d4dd993..d388ce1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -723,6 +723,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 	if (this_cpu->c_bsp_init)
 		this_cpu->c_bsp_init(c);
+
+	setup_force_cpu_cap(X86_FEATURE_ALWAYS);
 }
 
 void __init early_cpu_init(void)
