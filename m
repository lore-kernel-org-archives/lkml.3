Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3CKJ4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:56:14 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60945 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3CKJ4M convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Mon, 11 Mar 2013 05:56:12 -0400
Message-Id: <513DB84502000078000C4880@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 11 Mar 2013 09:56:05 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <yangyongqiang01@baidu.com>, <sruffell@digium.com>,
        "Cyrill Gorcunov" <gorcunov@gmail.com>, <vincent.weaver@maine.edu>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: constify a few items
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This in particular re-does the compiler warning fix 9faec5b ("perf/x86:
Fix P6 driver section warning"), tightening the section attributes
rather than relaxing them.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Shaun Ruffell <sruffell@digium.com>
Cc: yangyongqiang <yangyongqiang01@baidu.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>

---
 arch/x86/kernel/amd_nb.c             |    2 +-
 arch/x86/kernel/cpu/perf_event_knc.c |    4 ++--
 arch/x86/kernel/cpu/perf_event_p6.c  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- 3.9-rc2/arch/x86/kernel/amd_nb.c
+++ 3.9-rc2-x86-const-sections/arch/x86/kernel/amd_nb.c
@@ -24,7 +24,7 @@ const struct pci_device_id amd_nb_misc_i
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
-static struct pci_device_id amd_nb_link_ids[] = {
+static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{}
 };
--- 3.9-rc2/arch/x86/kernel/cpu/perf_event_knc.c
+++ 3.9-rc2-x86-const-sections/arch/x86/kernel/cpu/perf_event_knc.c
@@ -17,7 +17,7 @@ static const u64 knc_perfmon_event_map[]
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
 };
 
-static __initconst u64 knc_hw_cache_event_ids
+static const u64 __initconst knc_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -284,7 +284,7 @@ static struct attribute *intel_knc_forma
 	NULL,
 };
 
-static __initconst struct x86_pmu knc_pmu = {
+static const struct x86_pmu knc_pmu __initconst = {
 	.name			= "knc",
 	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
--- 3.9-rc2/arch/x86/kernel/cpu/perf_event_p6.c
+++ 3.9-rc2-x86-const-sections/arch/x86/kernel/cpu/perf_event_p6.c
@@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[]
 
 };
 
-static u64 p6_hw_cache_event_ids
+static const u64 __initconst p6_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =



