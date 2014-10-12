Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaJLEyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 00:54:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:38935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaJLEvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 00:51:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,703,1406617200"; 
   d="scan'208";a="604027264"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v9 04/12] x86, mpx: add MPX to disaabled features
Date: Sun, 12 Oct 2014 12:41:47 +0800
Message-Id: <1413088915-13428-5-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to use cpu_feature_enabled(X86_FEATURE_MPX) as
both a runtime and compile-time check.

When CONFIG_X86_INTEL_MPX is disabled,
cpu_feature_enabled(X86_FEATURE_MPX) will evaluate at
compile-time to 0. If CONFIG_X86_INTEL_MPX=y, then the cpuid
flag will be checked at runtime.

This patch must be applied after another Dave's commit:
  381aa07a9b4e1f82969203e9e4863da2a157781d

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/include/asm/disabled-features.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 97534a7..f226df0 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -10,6 +10,12 @@
  * cpu_feature_enabled().
  */
 
+#ifdef CONFIG_X86_INTEL_MPX
+# define DISABLE_MPX	0
+#else
+# define DISABLE_MPX	(1<<(X86_FEATURE_MPX & 31))
+#endif
+
 #ifdef CONFIG_X86_64
 # define DISABLE_VME		(1<<(X86_FEATURE_VME & 31))
 # define DISABLE_K6_MTRR	(1<<(X86_FEATURE_K6_MTRR & 31))
@@ -34,6 +40,6 @@
 #define DISABLED_MASK6	0
 #define DISABLED_MASK7	0
 #define DISABLED_MASK8	0
-#define DISABLED_MASK9	0
+#define DISABLED_MASK9	(DISABLE_MPX)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
-- 
1.7.1

