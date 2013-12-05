Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3LEXdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:33:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44710 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab3LEXcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:32:33 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Kim Naru <kim.naru@amd.com>, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 4/4] x86, microcode: Move to a proper location
Date: Fri,  6 Dec 2013 00:32:28 +0100
Message-Id: <1386286348-5144-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386286348-5144-1-git-send-email-bp@alien8.de>
References: <1386286348-5144-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We've grown a bunch of microcode loader files all prefixed with
"microcode_". They should be under cpu/ because this is strictly
CPU-related functionality so do that and drop the prefix since they're
in their own directory now which gives that prefix. :)

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/Makefile                                      |  9 ---------
 arch/x86/kernel/cpu/Makefile                                  |  1 +
 arch/x86/kernel/cpu/microcode/Makefile                        | 11 +++++++++++
 arch/x86/kernel/{microcode_amd.c => cpu/microcode/amd.c}      |  0
 .../{microcode_amd_early.c => cpu/microcode/amd_early.c}      |  0
 arch/x86/kernel/{microcode_core.c => cpu/microcode/core.c}    |  0
 .../{microcode_core_early.c => cpu/microcode/core_early.c}    |  0
 arch/x86/kernel/{microcode_intel.c => cpu/microcode/intel.c}  |  0
 .../{microcode_intel_early.c => cpu/microcode/intel_early.c}  |  0
 .../{microcode_intel_lib.c => cpu/microcode/intel_lib.c}      |  0
 10 files changed, 12 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/microcode/Makefile
 rename arch/x86/kernel/{microcode_amd.c => cpu/microcode/amd.c} (100%)
 rename arch/x86/kernel/{microcode_amd_early.c => cpu/microcode/amd_early.c} (100%)
 rename arch/x86/kernel/{microcode_core.c => cpu/microcode/core.c} (100%)
 rename arch/x86/kernel/{microcode_core_early.c => cpu/microcode/core_early.c} (100%)
 rename arch/x86/kernel/{microcode_intel.c => cpu/microcode/intel.c} (100%)
 rename arch/x86/kernel/{microcode_intel_early.c => cpu/microcode/intel_early.c} (100%)
 rename arch/x86/kernel/{microcode_intel_lib.c => cpu/microcode/intel_lib.c} (100%)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9b0a34e2cd79..4d0094dbb6c9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -91,15 +91,6 @@ obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
-obj-$(CONFIG_MICROCODE_EARLY)		+= microcode_core_early.o
-obj-$(CONFIG_MICROCODE_INTEL_EARLY)	+= microcode_intel_early.o
-obj-$(CONFIG_MICROCODE_INTEL_LIB)	+= microcode_intel_lib.o
-microcode-y				:= microcode_core.o
-microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
-microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
-obj-$(CONFIG_MICROCODE_AMD_EARLY)	+= microcode_amd_early.o
-obj-$(CONFIG_MICROCODE)			+= microcode.o
-
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6359506a19ee..7fd54f09b011 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -42,6 +42,7 @@ endif
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
+obj-$(CONFIG_MICROCODE)			+= microcode/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
 
diff --git a/arch/x86/kernel/cpu/microcode/Makefile b/arch/x86/kernel/cpu/microcode/Makefile
new file mode 100644
index 000000000000..817fec409267
--- /dev/null
+++ b/arch/x86/kernel/cpu/microcode/Makefile
@@ -0,0 +1,11 @@
+obj-$(CONFIG_MICROCODE_EARLY)		+= core_early.o
+obj-$(CONFIG_MICROCODE_INTEL_EARLY)	+= intel_early.o
+obj-$(CONFIG_MICROCODE_INTEL_LIB)	+= intel_lib.o
+microcode-y				:= core.o
+microcode-$(CONFIG_MICROCODE_INTEL)	+= intel.o
+microcode-$(CONFIG_MICROCODE_AMD)	+= amd.o
+obj-$(CONFIG_MICROCODE_AMD_EARLY)	+= amd_early.o
+obj-$(CONFIG_MICROCODE)			+= microcode.o
+
+
+
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/cpu/microcode/amd.c
similarity index 100%
rename from arch/x86/kernel/microcode_amd.c
rename to arch/x86/kernel/cpu/microcode/amd.c
diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
similarity index 100%
rename from arch/x86/kernel/microcode_amd_early.c
rename to arch/x86/kernel/cpu/microcode/amd_early.c
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/cpu/microcode/core.c
similarity index 100%
rename from arch/x86/kernel/microcode_core.c
rename to arch/x86/kernel/cpu/microcode/core.c
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
similarity index 100%
rename from arch/x86/kernel/microcode_core_early.c
rename to arch/x86/kernel/cpu/microcode/core_early.c
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/cpu/microcode/intel.c
similarity index 100%
rename from arch/x86/kernel/microcode_intel.c
rename to arch/x86/kernel/cpu/microcode/intel.c
diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
similarity index 100%
rename from arch/x86/kernel/microcode_intel_early.c
rename to arch/x86/kernel/cpu/microcode/intel_early.c
diff --git a/arch/x86/kernel/microcode_intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
similarity index 100%
rename from arch/x86/kernel/microcode_intel_lib.c
rename to arch/x86/kernel/cpu/microcode/intel_lib.c
-- 
1.8.4

