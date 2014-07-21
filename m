Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaGUFmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:42:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:61456 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbaGUFm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:42:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="576270787"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v7 03/10] x86, mpx: add macro cpu_has_mpx
Date: Mon, 21 Jul 2014 13:38:37 +0800
Message-Id: <1405921124-4230-4-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
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
index e265ff9..f302d08 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -339,6 +339,12 @@ extern const char * const x86_power_flags[32];
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

