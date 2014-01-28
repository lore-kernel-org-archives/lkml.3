Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaA1X73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:59:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbaA1X7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:59:11 -0500
Date: Tue, 28 Jan 2014 15:58:48 -0800
Message-Id: <201401282358.s0SNwmhb031834@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/intel-mid cleanups for v3.14
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kbuild test robot <fengguang.wu@intel.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 15:58:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Miscellaneous cleanups to the intel-mid code merged earlier in this
merge window.

The following changes since commit 4500cf60dbe4b7f514d11b24c3e1edfda2a6d69d:

  Merge branch 'x86-intel-mid-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-01-20 12:06:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-intel-mid-for-linus

for you to fetch changes up to 790ed7421a973d9773dda8b4e5300c3f7f6fbcf7:

  x86, intel-mid: Cleanup some platform code's header files (2014-01-28 15:13:40 -0800)

----------------------------------------------------------------
David Cohen (2):
      x86, intel-mid: Add missing 'void' to functions without arguments
      x86, intel-mid: Cleanup some platform code's header files

Paul Gortmaker (2):
      x86: Don't introduce more __cpuinit users in intel_mid_weak_decls.h
      x86: Don't add new __cpuinit users to Merrifield platform code

 arch/x86/platform/intel-mid/device_libs/platform_ipc.h  | 5 +++--
 arch/x86/platform/intel-mid/device_libs/platform_msic.h | 4 ++--
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h      | 6 +++---
 arch/x86/platform/intel-mid/mfld.c                      | 6 +++---
 arch/x86/platform/intel-mid/mrfl.c                      | 2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/intel-mid/device_libs/platform_ipc.h b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
index 8f568dd79605..79bb09d4f718 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
+++ b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
@@ -12,6 +12,7 @@
 #ifndef _PLATFORM_IPC_H_
 #define _PLATFORM_IPC_H_
 
-extern void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
-			struct devs_id *dev) __attribute__((weak));
+void __init
+ipc_device_handler(struct sfi_device_table_entry *pentry, struct devs_id *dev);
+
 #endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic.h b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
index 917eb56d77da..b7be1d041da2 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic.h
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
@@ -14,6 +14,6 @@
 
 extern struct intel_msic_platform_data msic_pdata;
 
-extern void *msic_generic_platform_data(void *info,
-			enum intel_msic_block block) __attribute__((weak));
+void *msic_generic_platform_data(void *info, enum intel_msic_block block);
+
 #endif
diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
index a537ffc16299..46aa25c8ce06 100644
--- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
@@ -14,6 +14,6 @@
 /* For every CPU addition a new get_<cpuname>_ops interface needs
  * to be added.
  */
-extern void * __cpuinit get_penwell_ops(void) __attribute__((weak));
-extern void * __cpuinit get_cloverview_ops(void) __attribute__((weak));
-extern void * __init get_tangier_ops(void) __attribute__((weak));
+extern void *get_penwell_ops(void) __attribute__((weak));
+extern void *get_cloverview_ops(void) __attribute__((weak));
+extern void *get_tangier_ops(void) __attribute__((weak));
diff --git a/arch/x86/platform/intel-mid/mfld.c b/arch/x86/platform/intel-mid/mfld.c
index 4f7884eebc14..23381d2174ae 100644
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
 
-void * __cpuinit get_penwell_ops()
+void *get_penwell_ops(void)
 {
 	return &penwell_ops;
 }
 
-void * __cpuinit get_cloverview_ops()
+void *get_cloverview_ops(void)
 {
 	return &penwell_ops;
 }
diff --git a/arch/x86/platform/intel-mid/mrfl.c b/arch/x86/platform/intel-mid/mrfl.c
index 09d10159e7b7..aaca91753d32 100644
--- a/arch/x86/platform/intel-mid/mrfl.c
+++ b/arch/x86/platform/intel-mid/mrfl.c
@@ -97,7 +97,7 @@ static struct intel_mid_ops tangier_ops = {
 	.arch_setup = tangier_arch_setup,
 };
 
-void * __cpuinit get_tangier_ops()
+void *get_tangier_ops(void)
 {
 	return &tangier_ops;
 }
