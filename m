Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaAVWRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:17:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:34907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbaAVWRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:17:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,702,1384329600"; 
   d="scan'208";a="470960395"
From: David Cohen <david.a.cohen@linux.intel.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] x86: intel-mid: add missing 'void' to functions without arguments
Date: Wed, 22 Jan 2014 14:22:49 -0800
Message-Id: <1390429369-13761-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <52E0404E.4010403@linux.intel.com>
References: <52E0404E.4010403@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing 'void' to functions that doesn't receive
arguments.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

Hi,

Please, apply on top of Paul Gortmaker's patches:
[PATCH v2] x86: don't introduce more __cpuinit users in intel_mid_weak_decls.h
[PATCH] x86: don't add new __cpuinit users to Merrifield platform code

Br, David

---
 arch/x86/platform/intel-mid/mfld.c | 6 +++---
 arch/x86/platform/intel-mid/mrfl.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/intel-mid/mfld.c b/arch/x86/platform/intel-mid/mfld.c
index 88b06fcf9959..23381d2174ae 100644
--- a/arch/x86/platform/intel-mid/mfld.c
+++ b/arch/x86/platform/intel-mid/mfld.c
@@ -58,18 +58,18 @@ static unsigned long __init mfld_calibrate_tsc(void)
 	return 0;
 }
 
-static void __init penwell_arch_setup()
+static void __init penwell_arch_setup(void)
 {
 	x86_platform.calibrate_tsc = mfld_calibrate_tsc;
 	pm_power_off = mfld_power_off;
 }
 
-void *get_penwell_ops()
+void *get_penwell_ops(void)
 {
 	return &penwell_ops;
 }
 
-void *get_cloverview_ops()
+void *get_cloverview_ops(void)
 {
 	return &penwell_ops;
 }
diff --git a/arch/x86/platform/intel-mid/mrfl.c b/arch/x86/platform/intel-mid/mrfl.c
index 28b636a21887..aaca91753d32 100644
--- a/arch/x86/platform/intel-mid/mrfl.c
+++ b/arch/x86/platform/intel-mid/mrfl.c
@@ -97,7 +97,7 @@ static struct intel_mid_ops tangier_ops = {
 	.arch_setup = tangier_arch_setup,
 };
 
-void *get_tangier_ops()
+void *get_tangier_ops(void)
 {
 	return &tangier_ops;
 }
-- 
1.8.4.2

