Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaBTWTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:19:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaBTWT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:19:28 -0500
Date: Thu, 20 Feb 2014 14:19:10 -0800
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-8e5780fdeef7dc490b3f0b3a62704593721fa4f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1392931491-33237-1-git-send-email-fenghua.yu@intel.com>
References: <1392931491-33237-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, AVX-512: AVX-512 Feature Detection
Git-Commit-ID: 8e5780fdeef7dc490b3f0b3a62704593721fa4f3
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

Commit-ID:  8e5780fdeef7dc490b3f0b3a62704593721fa4f3
Gitweb:     http://git.kernel.org/tip/8e5780fdeef7dc490b3f0b3a62704593721fa4f3
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 20 Feb 2014 13:24:50 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Feb 2014 13:56:55 -0800

x86, AVX-512: AVX-512 Feature Detection

AVX-512 is an extention of AVX2. Its spec can be found at:
http://download-software.intel.com/sites/default/files/managed/71/2e/319433-017.pdf

This patch detects AVX-512 features by CPUID.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1392931491-33237-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> # hw enabling
---
 arch/x86/include/asm/cpufeature.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e099f95..5f12968 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -217,9 +217,13 @@
 #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
 #define X86_FEATURE_MPX		(9*32+14) /* Memory Protection Extension */
+#define X86_FEATURE_AVX512F	(9*32+16) /* AVX-512 Foundation */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
+#define X86_FEATURE_AVX512PF	(9*32+26) /* AVX-512 Prefetch */
+#define X86_FEATURE_AVX512ER	(9*32+27) /* AVX-512 Exponential and Reciprocal */
+#define X86_FEATURE_AVX512CD	(9*32+28) /* AVX-512 Conflict Detection */
 
 /*
  * BUG word(s)
