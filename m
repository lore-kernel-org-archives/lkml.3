Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3CKSRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:17:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44249 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3CKSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:17:46 -0400
Date: Mon, 11 Mar 2013 11:15:26 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-c391c7884633cdc317a60fbf152d1764282fe633@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yangyongqiang01@baidu.com, jbeulich@suse.com, gorcunov@gmail.com,
        sruffell@digium.com, vincent.weaver@maine.edu, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yangyongqiang01@baidu.com, jbeulich@suse.com, sruffell@digium.com,
        gorcunov@gmail.com, vincent.weaver@maine.edu, JBeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <513DB84502000078000C4880@nat28.tlf.novell.com>
References: <513DB84502000078000C4880@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Constify a few items
Git-Commit-ID: c391c7884633cdc317a60fbf152d1764282fe633
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Mar 2013 11:15:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c391c7884633cdc317a60fbf152d1764282fe633
Gitweb:     http://git.kernel.org/tip/c391c7884633cdc317a60fbf152d1764282fe633
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 11 Mar 2013 09:56:05 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Mar 2013 15:11:03 +0100

x86: Constify a few items

This in particular re-does the compiler warning fix 9faec5b
("perf/x86: Fix P6 driver section warning"), tightening the
section attributes rather than relaxing them.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Shaun Ruffell <sruffell@digium.com>
Cc: yangyongqiang <yangyongqiang01@baidu.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: http://lkml.kernel.org/r/513DB84502000078000C4880@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/amd_nb.c             | 2 +-
 arch/x86/kernel/cpu/perf_event_knc.c | 4 ++--
 arch/x86/kernel/cpu/perf_event_p6.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index aadf335..3684129 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -24,7 +24,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
-static struct pci_device_id amd_nb_link_ids[] = {
+static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{}
 };
diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index 4b7731b..838fa87 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -17,7 +17,7 @@ static const u64 knc_perfmon_event_map[] =
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
 };
 
-static __initconst u64 knc_hw_cache_event_ids
+static const u64 __initconst knc_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -284,7 +284,7 @@ static struct attribute *intel_knc_formats_attr[] = {
 	NULL,
 };
 
-static __initconst struct x86_pmu knc_pmu = {
+static const struct x86_pmu knc_pmu __initconst = {
 	.name			= "knc",
 	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 4820c23..b1e2fe1 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[] =
 
 };
 
-static u64 p6_hw_cache_event_ids
+static const u64 __initconst p6_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
