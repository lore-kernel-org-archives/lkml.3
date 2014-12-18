Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaLRQwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:52:03 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:41569 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbaLRQvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:51:51 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: Julian Brost <linux-kernel@0x4a42.net>,
        Fabian Hofmann <fabian.hofmann@fau.de>
Cc: linux-kernel@i4.cs.fau.de, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] perf/x86/intel/uncore: checkpatch: Add newlines after declarations
Date: Thu, 18 Dec 2014 17:51:40 +0100
Message-Id: <1418921500-5630-6-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
References: <1418751050-11725-1-git-send-email-linux-kernel@0x4a42.net>
 <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch complained about missing newlines after declarations which are added
with this patch.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c       | 4 ++++
 arch/x86/kernel/cpu/perf_event_intel_uncore_nhmex.c | 1 +
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 9 +++++++++
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 161655f..32f67c7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -529,6 +529,7 @@ static void uncore_pmu_event_del(struct perf_event *event, int flags)
 void uncore_pmu_event_read(struct perf_event *event)
 {
 	struct intel_uncore_box *box = uncore_event_to_box(event);
+
 	uncore_perf_event_update(box, event);
 }
 
@@ -714,6 +715,7 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 static void __init uncore_types_exit(struct intel_uncore_type **types)
 {
 	int i;
+
 	for (i = 0; types[i]; i++)
 		uncore_type_exit(types[i]);
 }
@@ -805,6 +807,7 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 
 	if (UNCORE_PCI_DEV_TYPE(id->driver_data) == UNCORE_EXTRA_PCI_DEV) {
 		int idx = UNCORE_PCI_DEV_IDX(id->driver_data);
+
 		uncore_extra_pci_dev[phys_id][idx] = pdev;
 		pci_set_drvdata(pdev, NULL);
 		return 0;
@@ -1002,6 +1005,7 @@ static int uncore_cpu_starting(int cpu)
 				if (exist && exist->phys_id == phys_id) {
 					atomic_inc(&exist->refcnt);
 					*per_cpu_ptr(pmu->box, cpu) = exist;
+
 					if (box) {
 						list_add(&box->list,
 							 &boxes_to_free);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_nhmex.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_nhmex.c
index 2749965..d51e06c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_nhmex.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_nhmex.c
@@ -1005,6 +1005,7 @@ again:
 		 * the 0~7 bits and the 8~15 bits respectively.
 		 */
 		u64 mask = 0xff << ((idx - 2) * 8);
+
 		if (!__BITS_VALUE(atomic_read(&er->ref), idx - 2, 8) ||
 				!((er->config ^ config1) & mask)) {
 			atomic_add(1 << ((idx - 2) * 8), &er->ref);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index da905c2..e001cc3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -915,6 +915,7 @@ static void snbep_qpi_enable_event(struct intel_uncore_box *box, struct perf_eve
 	if (reg1->idx != EXTRA_REG_NONE) {
 		int idx = box->pmu->pmu_idx + SNBEP_PCI_QPI_PORT0_FILTER;
 		struct pci_dev *filter_pdev = uncore_extra_pci_dev[box->phys_id][idx];
+
 		if (filter_pdev) {
 			pci_write_config_dword(filter_pdev, reg1->reg,
 						(u32)reg1->config);
@@ -1136,6 +1137,7 @@ static int snbep_pci2phy_map_init(int devid)
 int snbep_uncore_pci_init(void)
 {
 	int ret = snbep_pci2phy_map_init(0x3ce0);
+
 	if (ret)
 		return ret;
 	uncore_pci_uncores = snbep_pci_uncores;
@@ -1148,6 +1150,7 @@ int snbep_uncore_pci_init(void)
 static void ivbep_uncore_msr_init_box(struct intel_uncore_box *box)
 {
 	unsigned msr = uncore_msr_box_ctl(box);
+
 	if (msr)
 		wrmsrl(msr, IVBEP_PMON_BOX_CTL_INT);
 }
@@ -1400,6 +1403,7 @@ static void ivbep_cbox_enable_event(struct intel_uncore_box *box, struct perf_ev
 
 	if (reg1->idx != EXTRA_REG_NONE) {
 		u64 filter = uncore_shared_reg_config(box, 0);
+
 		wrmsrl(reg1->reg, filter & 0xffffffff);
 		wrmsrl(reg1->reg + 6, filter >> 32);
 	}
@@ -1700,6 +1704,7 @@ static struct pci_driver ivbep_uncore_pci_driver = {
 int ivbep_uncore_pci_init(void)
 {
 	int ret = snbep_pci2phy_map_init(0x0e1e);
+
 	if (ret)
 		return ret;
 	uncore_pci_uncores = ivbep_pci_uncores;
@@ -1728,6 +1733,7 @@ static struct attribute_group hswep_uncore_ubox_format_group = {
 static int hswep_ubox_hw_config(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+
 	reg1->reg = HSWEP_U_MSR_PMON_FILTER;
 	reg1->config = event->attr.config1 & HSWEP_U_MSR_PMON_BOX_FILTER_MASK;
 	reg1->idx = 0;
@@ -1835,6 +1841,7 @@ static struct extra_reg hswep_uncore_cbox_extra_regs[] = {
 static u64 hswep_cbox_filter_mask(int fields)
 {
 	u64 mask = 0;
+
 	if (fields & 0x1)
 		mask |= HSWEP_CB0_MSR_PMON_BOX_FILTER_TID;
 	if (fields & 0x2)
@@ -1887,6 +1894,7 @@ static void hswep_cbox_enable_event(struct intel_uncore_box *box,
 
 	if (reg1->idx != EXTRA_REG_NONE) {
 		u64 filter = uncore_shared_reg_config(box, 0);
+
 		wrmsrl(reg1->reg, filter & 0xffffffff);
 		wrmsrl(reg1->reg + 1, filter >> 32);
 	}
@@ -2290,6 +2298,7 @@ static struct pci_driver hswep_uncore_pci_driver = {
 int hswep_uncore_pci_init(void)
 {
 	int ret = snbep_pci2phy_map_init(0x2f1e);
+
 	if (ret)
 		return ret;
 	uncore_pci_uncores = hswep_pci_uncores;
-- 
1.9.1

