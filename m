Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaIKJET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:04:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:30409 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbaIKIyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="589733169"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v8 03/10] x86, mpx: add macro cpu_has_mpx
Date: Thu, 11 Sep 2014 16:46:43 +0800
Message-Id: <1410425210-24789-4-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to do performance optimization, this patch adds macro
cpu_has_mpx which will directly return 0 when MPX is not supported
by kernel.

Community gave a lot of comments on this macro cpu_has_mpx in previous
version. Dave will introduce a patchset about disabled features to fix
it later.

In this code:
        if (cpu_has_mpx)
                do_some_mpx_thing();

The patch series from Dave will introduce a new macro cpu_feature_enabled()
(if merged after this patchset) to replace the cpu_has_mpx.
        if (cpu_feature_enabled(X86_FEATURE_MPX))
                do_some_mpx_thing();

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/include/asm/cpufeature.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb9b258..82ec7ed 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -353,6 +353,12 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
+#ifdef CONFIG_X86_INTEL_MPX
+#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX)
+#else
+#define cpu_has_mpx 0
+#endif /* CONFIG_X86_INTEL_MPX */
+
 #ifdef CONFIG_X86_64
 
 #undef  cpu_has_vme
-- 
1.7.1

