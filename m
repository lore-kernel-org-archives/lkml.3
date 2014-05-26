Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaEZRDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:03:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:43464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaEZQ5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122311"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 02/15] x86/xsaves: Add kernel parameter to disable xsaves/xrstors
Date: Mon, 26 May 2014 10:01:09 -0700
Message-Id: <1401123682-5384-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Add kernel parameter noxsaves to disable xsaves/xrstors feature.

Add kernel parameter noxsaveopt in doc.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/kernel-parameters.txt | 9 +++++++++
 arch/x86/kernel/cpu/common.c        | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4384217..8541752 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2124,6 +2124,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
 
+	noxsaveopt	[X86] Disables x86 extended register state context
+			switch using xsaveopt. The kernel wil fallback to use
+			not optimized xsave to do context switch.
+
+	noxsaves	[X86] Disables x86 extended register state context
+			switch and save/restore compacted formated xsave
+			area using xsaves. Then the kernel uses standard
+			xsave area for xstate.
+
 	eagerfpu=	[X86]
 			on	enable eager fpu restore
 			off	disable eager fpu restore
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239..409f47c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -146,6 +146,7 @@ static int __init x86_xsave_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
+	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
 	setup_clear_cpu_cap(X86_FEATURE_AVX);
 	setup_clear_cpu_cap(X86_FEATURE_AVX2);
 	return 1;
@@ -159,6 +160,13 @@ static int __init x86_xsaveopt_setup(char *s)
 }
 __setup("noxsaveopt", x86_xsaveopt_setup);
 
+static int __init x86_xsaves_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
+	return 1;
+}
+__setup("noxsaves", x86_xsaves_setup);
+
 #ifdef CONFIG_X86_32
 static int cachesize_override = -1;
 static int disable_x86_serial_nr = 1;
-- 
1.8.1.2

