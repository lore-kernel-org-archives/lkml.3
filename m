Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3JDVj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:39:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:30824 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab3JDVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="414189161"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, bp@suse.de
Subject: [PATCH 2/6] perf, x86: Make perf amd ibs code depend on PERF_EVENTS and SUP_AMD
Date: Fri,  4 Oct 2013 14:39:44 -0700
Message-Id: <1380922788-23112-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Now that oprofile doesn't need the AMD IBS perf code anymore, we can
make that code dependent on PERF_EVENTS and AMD CPU support,
instead of unconditionally compiling it in.

Cc: bp@suse.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 47b56a7..a735914 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -37,13 +37,16 @@ endif
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
+ifdef CONFIG_X86_LOCAL_APIC
+obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd_ibs.o
+endif
 endif
 
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
 
-obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
+obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o 
 
 obj-$(CONFIG_HYPERVISOR_GUEST)		+= vmware.o hypervisor.o mshyperv.o
 
-- 
1.8.3.1

