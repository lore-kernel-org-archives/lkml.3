Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaHMI0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:26:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaHMI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:26:05 -0400
Date: Wed, 13 Aug 2014 01:25:28 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8559jke61dsyr7d0i74iutli@git.kernel.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        acme@kernel.org, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eranian@google.com, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, zheng.z.yan@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore: Rename IvyTown to IvyBridge-EP
Git-Commit-ID: ddcd0973fe02aad3d4bdc59dd0f1db90f51105a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddcd0973fe02aad3d4bdc59dd0f1db90f51105a9
Gitweb:     http://git.kernel.org/tip/ddcd0973fe02aad3d4bdc59dd0f1db90f51105a9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 12 Aug 2014 09:15:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:18 +0200

perf/x86/uncore: Rename IvyTown to IvyBridge-EP

Keeping track of all the various CPU names is hard enough; adding extra
silly names for no reason is just not helping. If we know the base arch
name (IvyBridge) then we can do the client/server parts with the well
known {,EP,EX} postfixes, no need to remember endless amounts of
unrelated and pointless names for this.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-8559jke61dsyr7d0i74iutli@git.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   8 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |   4 +-
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 340 ++++++++++-----------
 3 files changed, 176 insertions(+), 176 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b1f84d9..4785ee8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -880,8 +880,8 @@ static int __init uncore_pci_init(void)
 	case 45: /* Sandy Bridge-EP */
 		ret = snbep_uncore_pci_init();
 		break;
-	case 62: /* IvyTown */
-		ret = ivt_uncore_pci_init();
+	case 62: /* Ivy Bridge-EP */
+		ret = ivbep_uncore_pci_init();
 		break;
 	case 42: /* Sandy Bridge */
 		ret = snb_uncore_pci_init();
@@ -1187,8 +1187,8 @@ static int __init uncore_cpu_init(void)
 	case 47: /* Westmere-EX aka. Xeon E7 */
 		nhmex_uncore_cpu_init();
 		break;
-	case 62: /* IvyTown */
-		ivt_uncore_cpu_init();
+	case 62: /* Ivy Bridge-EP */
+		ivbep_uncore_cpu_init();
 		break;
 
 	default:
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index b915599..1d7e894 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -330,8 +330,8 @@ void nhm_uncore_cpu_init(void);
 /* perf_event_intel_uncore_snbep.c */
 int snbep_uncore_pci_init(void);
 void snbep_uncore_cpu_init(void);
-int ivt_uncore_pci_init(void);
-void ivt_uncore_cpu_init(void);
+int ivbep_uncore_pci_init(void);
+void ivbep_uncore_cpu_init(void);
 
 /* perf_event_intel_uncore_nhmex.c */
 void nhmex_uncore_cpu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 00bd048..d3e9c55 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -111,43 +111,43 @@
 #define SNBEP_PCU_MSR_CORE_C3_CTR		0x3fc
 #define SNBEP_PCU_MSR_CORE_C6_CTR		0x3fd
 
-/* IVT event control */
-#define IVT_PMON_BOX_CTL_INT		(SNBEP_PMON_BOX_CTL_RST_CTRL | \
+/* IVBEP event control */
+#define IVBEP_PMON_BOX_CTL_INT		(SNBEP_PMON_BOX_CTL_RST_CTRL | \
 					 SNBEP_PMON_BOX_CTL_RST_CTRS)
-#define IVT_PMON_RAW_EVENT_MASK		(SNBEP_PMON_CTL_EV_SEL_MASK | \
+#define IVBEP_PMON_RAW_EVENT_MASK		(SNBEP_PMON_CTL_EV_SEL_MASK | \
 					 SNBEP_PMON_CTL_UMASK_MASK | \
 					 SNBEP_PMON_CTL_EDGE_DET | \
 					 SNBEP_PMON_CTL_TRESH_MASK)
-/* IVT Ubox */
-#define IVT_U_MSR_PMON_GLOBAL_CTL		0xc00
-#define IVT_U_PMON_GLOBAL_FRZ_ALL		(1 << 31)
-#define IVT_U_PMON_GLOBAL_UNFRZ_ALL		(1 << 29)
+/* IVBEP Ubox */
+#define IVBEP_U_MSR_PMON_GLOBAL_CTL		0xc00
+#define IVBEP_U_PMON_GLOBAL_FRZ_ALL		(1 << 31)
+#define IVBEP_U_PMON_GLOBAL_UNFRZ_ALL		(1 << 29)
 
-#define IVT_U_MSR_PMON_RAW_EVENT_MASK	\
+#define IVBEP_U_MSR_PMON_RAW_EVENT_MASK	\
 				(SNBEP_PMON_CTL_EV_SEL_MASK | \
 				 SNBEP_PMON_CTL_UMASK_MASK | \
 				 SNBEP_PMON_CTL_EDGE_DET | \
 				 SNBEP_U_MSR_PMON_CTL_TRESH_MASK)
-/* IVT Cbo */
-#define IVT_CBO_MSR_PMON_RAW_EVENT_MASK		(IVT_PMON_RAW_EVENT_MASK | \
+/* IVBEP Cbo */
+#define IVBEP_CBO_MSR_PMON_RAW_EVENT_MASK		(IVBEP_PMON_RAW_EVENT_MASK | \
 						 SNBEP_CBO_PMON_CTL_TID_EN)
 
-#define IVT_CB0_MSR_PMON_BOX_FILTER_TID		(0x1fULL << 0)
-#define IVT_CB0_MSR_PMON_BOX_FILTER_LINK	(0xfULL << 5)
-#define IVT_CB0_MSR_PMON_BOX_FILTER_STATE	(0x3fULL << 17)
-#define IVT_CB0_MSR_PMON_BOX_FILTER_NID		(0xffffULL << 32)
-#define IVT_CB0_MSR_PMON_BOX_FILTER_OPC		(0x1ffULL << 52)
-#define IVT_CB0_MSR_PMON_BOX_FILTER_C6		(0x1ULL << 61)
-#define IVT_CB0_MSR_PMON_BOX_FILTER_NC		(0x1ULL << 62)
-#define IVT_CB0_MSR_PMON_BOX_FILTER_IOSC	(0x1ULL << 63)
-
-/* IVT home agent */
-#define IVT_HA_PCI_PMON_CTL_Q_OCC_RST		(1 << 16)
-#define IVT_HA_PCI_PMON_RAW_EVENT_MASK		\
-				(IVT_PMON_RAW_EVENT_MASK | \
-				 IVT_HA_PCI_PMON_CTL_Q_OCC_RST)
-/* IVT PCU */
-#define IVT_PCU_MSR_PMON_RAW_EVENT_MASK	\
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_TID		(0x1fULL << 0)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_LINK	(0xfULL << 5)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_STATE	(0x3fULL << 17)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_NID		(0xffffULL << 32)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_OPC		(0x1ffULL << 52)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_C6		(0x1ULL << 61)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_NC		(0x1ULL << 62)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_IOSC	(0x1ULL << 63)
+
+/* IVBEP home agent */
+#define IVBEP_HA_PCI_PMON_CTL_Q_OCC_RST		(1 << 16)
+#define IVBEP_HA_PCI_PMON_RAW_EVENT_MASK		\
+				(IVBEP_PMON_RAW_EVENT_MASK | \
+				 IVBEP_HA_PCI_PMON_CTL_Q_OCC_RST)
+/* IVBEP PCU */
+#define IVBEP_PCU_MSR_PMON_RAW_EVENT_MASK	\
 				(SNBEP_PMON_CTL_EV_SEL_MASK | \
 				 SNBEP_PMON_CTL_EV_SEL_EXT | \
 				 SNBEP_PCU_MSR_PMON_CTL_OCC_SEL_MASK | \
@@ -155,9 +155,9 @@
 				 SNBEP_PCU_MSR_PMON_CTL_TRESH_MASK | \
 				 SNBEP_PCU_MSR_PMON_CTL_OCC_INVERT | \
 				 SNBEP_PCU_MSR_PMON_CTL_OCC_EDGE_DET)
-/* IVT QPI */
-#define IVT_QPI_PCI_PMON_RAW_EVENT_MASK	\
-				(IVT_PMON_RAW_EVENT_MASK | \
+/* IVBEP QPI */
+#define IVBEP_QPI_PCI_PMON_RAW_EVENT_MASK	\
+				(IVBEP_PMON_RAW_EVENT_MASK | \
 				 SNBEP_PMON_CTL_EV_SEL_EXT)
 
 #define __BITS_VALUE(x, i, n)  ((typeof(x))(((x) >> ((i) * (n))) & \
@@ -1088,34 +1088,34 @@ int snbep_uncore_pci_init(void)
 /* end of Sandy Bridge-EP uncore support */
 
 /* IvyTown uncore support */
-static void ivt_uncore_msr_init_box(struct intel_uncore_box *box)
+static void ivbep_uncore_msr_init_box(struct intel_uncore_box *box)
 {
 	unsigned msr = uncore_msr_box_ctl(box);
 	if (msr)
-		wrmsrl(msr, IVT_PMON_BOX_CTL_INT);
+		wrmsrl(msr, IVBEP_PMON_BOX_CTL_INT);
 }
 
-static void ivt_uncore_pci_init_box(struct intel_uncore_box *box)
+static void ivbep_uncore_pci_init_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev = box->pci_dev;
 
-	pci_write_config_dword(pdev, SNBEP_PCI_PMON_BOX_CTL, IVT_PMON_BOX_CTL_INT);
+	pci_write_config_dword(pdev, SNBEP_PCI_PMON_BOX_CTL, IVBEP_PMON_BOX_CTL_INT);
 }
 
-#define IVT_UNCORE_MSR_OPS_COMMON_INIT()			\
-	.init_box	= ivt_uncore_msr_init_box,		\
+#define IVBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
+	.init_box	= ivbep_uncore_msr_init_box,		\
 	.disable_box	= snbep_uncore_msr_disable_box,		\
 	.enable_box	= snbep_uncore_msr_enable_box,		\
 	.disable_event	= snbep_uncore_msr_disable_event,	\
 	.enable_event	= snbep_uncore_msr_enable_event,	\
 	.read_counter	= uncore_msr_read_counter
 
-static struct intel_uncore_ops ivt_uncore_msr_ops = {
-	IVT_UNCORE_MSR_OPS_COMMON_INIT(),
+static struct intel_uncore_ops ivbep_uncore_msr_ops = {
+	IVBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 };
 
-static struct intel_uncore_ops ivt_uncore_pci_ops = {
-	.init_box	= ivt_uncore_pci_init_box,
+static struct intel_uncore_ops ivbep_uncore_pci_ops = {
+	.init_box	= ivbep_uncore_pci_init_box,
 	.disable_box	= snbep_uncore_pci_disable_box,
 	.enable_box	= snbep_uncore_pci_enable_box,
 	.disable_event	= snbep_uncore_pci_disable_event,
@@ -1123,15 +1123,15 @@ static struct intel_uncore_ops ivt_uncore_pci_ops = {
 	.read_counter	= snbep_uncore_pci_read_counter,
 };
 
-#define IVT_UNCORE_PCI_COMMON_INIT()				\
+#define IVBEP_UNCORE_PCI_COMMON_INIT()				\
 	.perf_ctr	= SNBEP_PCI_PMON_CTR0,			\
 	.event_ctl	= SNBEP_PCI_PMON_CTL0,			\
-	.event_mask	= IVT_PMON_RAW_EVENT_MASK,		\
+	.event_mask	= IVBEP_PMON_RAW_EVENT_MASK,		\
 	.box_ctl	= SNBEP_PCI_PMON_BOX_CTL,		\
-	.ops		= &ivt_uncore_pci_ops,			\
-	.format_group	= &ivt_uncore_format_group
+	.ops		= &ivbep_uncore_pci_ops,			\
+	.format_group	= &ivbep_uncore_format_group
 
-static struct attribute *ivt_uncore_formats_attr[] = {
+static struct attribute *ivbep_uncore_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
@@ -1140,7 +1140,7 @@ static struct attribute *ivt_uncore_formats_attr[] = {
 	NULL,
 };
 
-static struct attribute *ivt_uncore_ubox_formats_attr[] = {
+static struct attribute *ivbep_uncore_ubox_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
@@ -1149,7 +1149,7 @@ static struct attribute *ivt_uncore_ubox_formats_attr[] = {
 	NULL,
 };
 
-static struct attribute *ivt_uncore_cbox_formats_attr[] = {
+static struct attribute *ivbep_uncore_cbox_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
@@ -1163,7 +1163,7 @@ static struct attribute *ivt_uncore_cbox_formats_attr[] = {
 	NULL,
 };
 
-static struct attribute *ivt_uncore_pcu_formats_attr[] = {
+static struct attribute *ivbep_uncore_pcu_formats_attr[] = {
 	&format_attr_event_ext.attr,
 	&format_attr_occ_sel.attr,
 	&format_attr_edge.attr,
@@ -1177,7 +1177,7 @@ static struct attribute *ivt_uncore_pcu_formats_attr[] = {
 	NULL,
 };
 
-static struct attribute *ivt_uncore_qpi_formats_attr[] = {
+static struct attribute *ivbep_uncore_qpi_formats_attr[] = {
 	&format_attr_event_ext.attr,
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
@@ -1203,32 +1203,32 @@ static struct attribute *ivt_uncore_qpi_formats_attr[] = {
 	NULL,
 };
 
-static struct attribute_group ivt_uncore_format_group = {
+static struct attribute_group ivbep_uncore_format_group = {
 	.name = "format",
-	.attrs = ivt_uncore_formats_attr,
+	.attrs = ivbep_uncore_formats_attr,
 };
 
-static struct attribute_group ivt_uncore_ubox_format_group = {
+static struct attribute_group ivbep_uncore_ubox_format_group = {
 	.name = "format",
-	.attrs = ivt_uncore_ubox_formats_attr,
+	.attrs = ivbep_uncore_ubox_formats_attr,
 };
 
-static struct attribute_group ivt_uncore_cbox_format_group = {
+static struct attribute_group ivbep_uncore_cbox_format_group = {
 	.name = "format",
-	.attrs = ivt_uncore_cbox_formats_attr,
+	.attrs = ivbep_uncore_cbox_formats_attr,
 };
 
-static struct attribute_group ivt_uncore_pcu_format_group = {
+static struct attribute_group ivbep_uncore_pcu_format_group = {
 	.name = "format",
-	.attrs = ivt_uncore_pcu_formats_attr,
+	.attrs = ivbep_uncore_pcu_formats_attr,
 };
 
-static struct attribute_group ivt_uncore_qpi_format_group = {
+static struct attribute_group ivbep_uncore_qpi_format_group = {
 	.name = "format",
-	.attrs = ivt_uncore_qpi_formats_attr,
+	.attrs = ivbep_uncore_qpi_formats_attr,
 };
 
-static struct intel_uncore_type ivt_uncore_ubox = {
+static struct intel_uncore_type ivbep_uncore_ubox = {
 	.name		= "ubox",
 	.num_counters   = 2,
 	.num_boxes	= 1,
@@ -1236,14 +1236,14 @@ static struct intel_uncore_type ivt_uncore_ubox = {
 	.fixed_ctr_bits	= 48,
 	.perf_ctr	= SNBEP_U_MSR_PMON_CTR0,
 	.event_ctl	= SNBEP_U_MSR_PMON_CTL0,
-	.event_mask	= IVT_U_MSR_PMON_RAW_EVENT_MASK,
+	.event_mask	= IVBEP_U_MSR_PMON_RAW_EVENT_MASK,
 	.fixed_ctr	= SNBEP_U_MSR_PMON_UCLK_FIXED_CTR,
 	.fixed_ctl	= SNBEP_U_MSR_PMON_UCLK_FIXED_CTL,
-	.ops		= &ivt_uncore_msr_ops,
-	.format_group	= &ivt_uncore_ubox_format_group,
+	.ops		= &ivbep_uncore_msr_ops,
+	.format_group	= &ivbep_uncore_ubox_format_group,
 };
 
-static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
+static struct extra_reg ivbep_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
@@ -1284,37 +1284,37 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
 	EVENT_EXTRA_END
 };
 
-static u64 ivt_cbox_filter_mask(int fields)
+static u64 ivbep_cbox_filter_mask(int fields)
 {
 	u64 mask = 0;
 
 	if (fields & 0x1)
-		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_TID;
+		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_TID;
 	if (fields & 0x2)
-		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_LINK;
+		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_LINK;
 	if (fields & 0x4)
-		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_STATE;
+		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_STATE;
 	if (fields & 0x8)
-		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_NID;
+		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_NID;
 	if (fields & 0x10)
-		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_OPC;
+		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_OPC;
 
 	return mask;
 }
 
 static struct event_constraint *
-ivt_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
+ivbep_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
 {
-	return __snbep_cbox_get_constraint(box, event, ivt_cbox_filter_mask);
+	return __snbep_cbox_get_constraint(box, event, ivbep_cbox_filter_mask);
 }
 
-static int ivt_cbox_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+static int ivbep_cbox_hw_config(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
 	struct extra_reg *er;
 	int idx = 0;
 
-	for (er = ivt_uncore_cbox_extra_regs; er->msr; er++) {
+	for (er = ivbep_uncore_cbox_extra_regs; er->msr; er++) {
 		if (er->event != (event->hw.config & er->config_mask))
 			continue;
 		idx |= er->idx;
@@ -1323,13 +1323,13 @@ static int ivt_cbox_hw_config(struct intel_uncore_box *box, struct perf_event *e
 	if (idx) {
 		reg1->reg = SNBEP_C0_MSR_PMON_BOX_FILTER +
 			SNBEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
-		reg1->config = event->attr.config1 & ivt_cbox_filter_mask(idx);
+		reg1->config = event->attr.config1 & ivbep_cbox_filter_mask(idx);
 		reg1->idx = idx;
 	}
 	return 0;
 }
 
-static void ivt_cbox_enable_event(struct intel_uncore_box *box, struct perf_event *event)
+static void ivbep_cbox_enable_event(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
@@ -1343,78 +1343,78 @@ static void ivt_cbox_enable_event(struct intel_uncore_box *box, struct perf_even
 	wrmsrl(hwc->config_base, hwc->config | SNBEP_PMON_CTL_EN);
 }
 
-static struct intel_uncore_ops ivt_uncore_cbox_ops = {
-	.init_box		= ivt_uncore_msr_init_box,
+static struct intel_uncore_ops ivbep_uncore_cbox_ops = {
+	.init_box		= ivbep_uncore_msr_init_box,
 	.disable_box		= snbep_uncore_msr_disable_box,
 	.enable_box		= snbep_uncore_msr_enable_box,
 	.disable_event		= snbep_uncore_msr_disable_event,
-	.enable_event		= ivt_cbox_enable_event,
+	.enable_event		= ivbep_cbox_enable_event,
 	.read_counter		= uncore_msr_read_counter,
-	.hw_config		= ivt_cbox_hw_config,
-	.get_constraint		= ivt_cbox_get_constraint,
+	.hw_config		= ivbep_cbox_hw_config,
+	.get_constraint		= ivbep_cbox_get_constraint,
 	.put_constraint		= snbep_cbox_put_constraint,
 };
 
-static struct intel_uncore_type ivt_uncore_cbox = {
+static struct intel_uncore_type ivbep_uncore_cbox = {
 	.name			= "cbox",
 	.num_counters		= 4,
 	.num_boxes		= 15,
 	.perf_ctr_bits		= 44,
 	.event_ctl		= SNBEP_C0_MSR_PMON_CTL0,
 	.perf_ctr		= SNBEP_C0_MSR_PMON_CTR0,
-	.event_mask		= IVT_CBO_MSR_PMON_RAW_EVENT_MASK,
+	.event_mask		= IVBEP_CBO_MSR_PMON_RAW_EVENT_MASK,
 	.box_ctl		= SNBEP_C0_MSR_PMON_BOX_CTL,
 	.msr_offset		= SNBEP_CBO_MSR_OFFSET,
 	.num_shared_regs	= 1,
 	.constraints		= snbep_uncore_cbox_constraints,
-	.ops			= &ivt_uncore_cbox_ops,
-	.format_group		= &ivt_uncore_cbox_format_group,
+	.ops			= &ivbep_uncore_cbox_ops,
+	.format_group		= &ivbep_uncore_cbox_format_group,
 };
 
-static struct intel_uncore_ops ivt_uncore_pcu_ops = {
-	IVT_UNCORE_MSR_OPS_COMMON_INIT(),
+static struct intel_uncore_ops ivbep_uncore_pcu_ops = {
+	IVBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 	.hw_config		= snbep_pcu_hw_config,
 	.get_constraint		= snbep_pcu_get_constraint,
 	.put_constraint		= snbep_pcu_put_constraint,
 };
 
-static struct intel_uncore_type ivt_uncore_pcu = {
+static struct intel_uncore_type ivbep_uncore_pcu = {
 	.name			= "pcu",
 	.num_counters		= 4,
 	.num_boxes		= 1,
 	.perf_ctr_bits		= 48,
 	.perf_ctr		= SNBEP_PCU_MSR_PMON_CTR0,
 	.event_ctl		= SNBEP_PCU_MSR_PMON_CTL0,
-	.event_mask		= IVT_PCU_MSR_PMON_RAW_EVENT_MASK,
+	.event_mask		= IVBEP_PCU_MSR_PMON_RAW_EVENT_MASK,
 	.box_ctl		= SNBEP_PCU_MSR_PMON_BOX_CTL,
 	.num_shared_regs	= 1,
-	.ops			= &ivt_uncore_pcu_ops,
-	.format_group		= &ivt_uncore_pcu_format_group,
+	.ops			= &ivbep_uncore_pcu_ops,
+	.format_group		= &ivbep_uncore_pcu_format_group,
 };
 
-static struct intel_uncore_type *ivt_msr_uncores[] = {
-	&ivt_uncore_ubox,
-	&ivt_uncore_cbox,
-	&ivt_uncore_pcu,
+static struct intel_uncore_type *ivbep_msr_uncores[] = {
+	&ivbep_uncore_ubox,
+	&ivbep_uncore_cbox,
+	&ivbep_uncore_pcu,
 	NULL,
 };
 
-void ivt_uncore_cpu_init(void)
+void ivbep_uncore_cpu_init(void)
 {
-	if (ivt_uncore_cbox.num_boxes > boot_cpu_data.x86_max_cores)
-		ivt_uncore_cbox.num_boxes = boot_cpu_data.x86_max_cores;
-	uncore_msr_uncores = ivt_msr_uncores;
+	if (ivbep_uncore_cbox.num_boxes > boot_cpu_data.x86_max_cores)
+		ivbep_uncore_cbox.num_boxes = boot_cpu_data.x86_max_cores;
+	uncore_msr_uncores = ivbep_msr_uncores;
 }
 
-static struct intel_uncore_type ivt_uncore_ha = {
+static struct intel_uncore_type ivbep_uncore_ha = {
 	.name		= "ha",
 	.num_counters   = 4,
 	.num_boxes	= 2,
 	.perf_ctr_bits	= 48,
-	IVT_UNCORE_PCI_COMMON_INIT(),
+	IVBEP_UNCORE_PCI_COMMON_INIT(),
 };
 
-static struct intel_uncore_type ivt_uncore_imc = {
+static struct intel_uncore_type ivbep_uncore_imc = {
 	.name		= "imc",
 	.num_counters   = 4,
 	.num_boxes	= 8,
@@ -1423,64 +1423,64 @@ static struct intel_uncore_type ivt_uncore_imc = {
 	.fixed_ctr	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
 	.fixed_ctl	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
 	.event_descs	= snbep_uncore_imc_events,
-	IVT_UNCORE_PCI_COMMON_INIT(),
+	IVBEP_UNCORE_PCI_COMMON_INIT(),
 };
 
 /* registers in IRP boxes are not properly aligned */
-static unsigned ivt_uncore_irp_ctls[] = {0xd8, 0xdc, 0xe0, 0xe4};
-static unsigned ivt_uncore_irp_ctrs[] = {0xa0, 0xb0, 0xb8, 0xc0};
+static unsigned ivbep_uncore_irp_ctls[] = {0xd8, 0xdc, 0xe0, 0xe4};
+static unsigned ivbep_uncore_irp_ctrs[] = {0xa0, 0xb0, 0xb8, 0xc0};
 
-static void ivt_uncore_irp_enable_event(struct intel_uncore_box *box, struct perf_event *event)
+static void ivbep_uncore_irp_enable_event(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct pci_dev *pdev = box->pci_dev;
 	struct hw_perf_event *hwc = &event->hw;
 
-	pci_write_config_dword(pdev, ivt_uncore_irp_ctls[hwc->idx],
+	pci_write_config_dword(pdev, ivbep_uncore_irp_ctls[hwc->idx],
 			       hwc->config | SNBEP_PMON_CTL_EN);
 }
 
-static void ivt_uncore_irp_disable_event(struct intel_uncore_box *box, struct perf_event *event)
+static void ivbep_uncore_irp_disable_event(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct pci_dev *pdev = box->pci_dev;
 	struct hw_perf_event *hwc = &event->hw;
 
-	pci_write_config_dword(pdev, ivt_uncore_irp_ctls[hwc->idx], hwc->config);
+	pci_write_config_dword(pdev, ivbep_uncore_irp_ctls[hwc->idx], hwc->config);
 }
 
-static u64 ivt_uncore_irp_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+static u64 ivbep_uncore_irp_read_counter(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct pci_dev *pdev = box->pci_dev;
 	struct hw_perf_event *hwc = &event->hw;
 	u64 count = 0;
 
-	pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx], (u32 *)&count);
-	pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx] + 4, (u32 *)&count + 1);
+	pci_read_config_dword(pdev, ivbep_uncore_irp_ctrs[hwc->idx], (u32 *)&count);
+	pci_read_config_dword(pdev, ivbep_uncore_irp_ctrs[hwc->idx] + 4, (u32 *)&count + 1);
 
 	return count;
 }
 
-static struct intel_uncore_ops ivt_uncore_irp_ops = {
-	.init_box	= ivt_uncore_pci_init_box,
+static struct intel_uncore_ops ivbep_uncore_irp_ops = {
+	.init_box	= ivbep_uncore_pci_init_box,
 	.disable_box	= snbep_uncore_pci_disable_box,
 	.enable_box	= snbep_uncore_pci_enable_box,
-	.disable_event	= ivt_uncore_irp_disable_event,
-	.enable_event	= ivt_uncore_irp_enable_event,
-	.read_counter	= ivt_uncore_irp_read_counter,
+	.disable_event	= ivbep_uncore_irp_disable_event,
+	.enable_event	= ivbep_uncore_irp_enable_event,
+	.read_counter	= ivbep_uncore_irp_read_counter,
 };
 
-static struct intel_uncore_type ivt_uncore_irp = {
+static struct intel_uncore_type ivbep_uncore_irp = {
 	.name			= "irp",
 	.num_counters		= 4,
 	.num_boxes		= 1,
 	.perf_ctr_bits		= 48,
-	.event_mask		= IVT_PMON_RAW_EVENT_MASK,
+	.event_mask		= IVBEP_PMON_RAW_EVENT_MASK,
 	.box_ctl		= SNBEP_PCI_PMON_BOX_CTL,
-	.ops			= &ivt_uncore_irp_ops,
-	.format_group		= &ivt_uncore_format_group,
+	.ops			= &ivbep_uncore_irp_ops,
+	.format_group		= &ivbep_uncore_format_group,
 };
 
-static struct intel_uncore_ops ivt_uncore_qpi_ops = {
-	.init_box	= ivt_uncore_pci_init_box,
+static struct intel_uncore_ops ivbep_uncore_qpi_ops = {
+	.init_box	= ivbep_uncore_pci_init_box,
 	.disable_box	= snbep_uncore_pci_disable_box,
 	.enable_box	= snbep_uncore_pci_enable_box,
 	.disable_event	= snbep_uncore_pci_disable_event,
@@ -1491,129 +1491,129 @@ static struct intel_uncore_ops ivt_uncore_qpi_ops = {
 	.put_constraint	= uncore_put_constraint,
 };
 
-static struct intel_uncore_type ivt_uncore_qpi = {
+static struct intel_uncore_type ivbep_uncore_qpi = {
 	.name			= "qpi",
 	.num_counters		= 4,
 	.num_boxes		= 3,
 	.perf_ctr_bits		= 48,
 	.perf_ctr		= SNBEP_PCI_PMON_CTR0,
 	.event_ctl		= SNBEP_PCI_PMON_CTL0,
-	.event_mask		= IVT_QPI_PCI_PMON_RAW_EVENT_MASK,
+	.event_mask		= IVBEP_QPI_PCI_PMON_RAW_EVENT_MASK,
 	.box_ctl		= SNBEP_PCI_PMON_BOX_CTL,
 	.num_shared_regs	= 1,
-	.ops			= &ivt_uncore_qpi_ops,
-	.format_group		= &ivt_uncore_qpi_format_group,
+	.ops			= &ivbep_uncore_qpi_ops,
+	.format_group		= &ivbep_uncore_qpi_format_group,
 };
 
-static struct intel_uncore_type ivt_uncore_r2pcie = {
+static struct intel_uncore_type ivbep_uncore_r2pcie = {
 	.name		= "r2pcie",
 	.num_counters   = 4,
 	.num_boxes	= 1,
 	.perf_ctr_bits	= 44,
 	.constraints	= snbep_uncore_r2pcie_constraints,
-	IVT_UNCORE_PCI_COMMON_INIT(),
+	IVBEP_UNCORE_PCI_COMMON_INIT(),
 };
 
-static struct intel_uncore_type ivt_uncore_r3qpi = {
+static struct intel_uncore_type ivbep_uncore_r3qpi = {
 	.name		= "r3qpi",
 	.num_counters   = 3,
 	.num_boxes	= 2,
 	.perf_ctr_bits	= 44,
 	.constraints	= snbep_uncore_r3qpi_constraints,
-	IVT_UNCORE_PCI_COMMON_INIT(),
+	IVBEP_UNCORE_PCI_COMMON_INIT(),
 };
 
 enum {
-	IVT_PCI_UNCORE_HA,
-	IVT_PCI_UNCORE_IMC,
-	IVT_PCI_UNCORE_IRP,
-	IVT_PCI_UNCORE_QPI,
-	IVT_PCI_UNCORE_R2PCIE,
-	IVT_PCI_UNCORE_R3QPI,
-};
-
-static struct intel_uncore_type *ivt_pci_uncores[] = {
-	[IVT_PCI_UNCORE_HA]	= &ivt_uncore_ha,
-	[IVT_PCI_UNCORE_IMC]	= &ivt_uncore_imc,
-	[IVT_PCI_UNCORE_IRP]	= &ivt_uncore_irp,
-	[IVT_PCI_UNCORE_QPI]	= &ivt_uncore_qpi,
-	[IVT_PCI_UNCORE_R2PCIE]	= &ivt_uncore_r2pcie,
-	[IVT_PCI_UNCORE_R3QPI]	= &ivt_uncore_r3qpi,
+	IVBEP_PCI_UNCORE_HA,
+	IVBEP_PCI_UNCORE_IMC,
+	IVBEP_PCI_UNCORE_IRP,
+	IVBEP_PCI_UNCORE_QPI,
+	IVBEP_PCI_UNCORE_R2PCIE,
+	IVBEP_PCI_UNCORE_R3QPI,
+};
+
+static struct intel_uncore_type *ivbep_pci_uncores[] = {
+	[IVBEP_PCI_UNCORE_HA]	= &ivbep_uncore_ha,
+	[IVBEP_PCI_UNCORE_IMC]	= &ivbep_uncore_imc,
+	[IVBEP_PCI_UNCORE_IRP]	= &ivbep_uncore_irp,
+	[IVBEP_PCI_UNCORE_QPI]	= &ivbep_uncore_qpi,
+	[IVBEP_PCI_UNCORE_R2PCIE]	= &ivbep_uncore_r2pcie,
+	[IVBEP_PCI_UNCORE_R3QPI]	= &ivbep_uncore_r3qpi,
 	NULL,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(ivt_uncore_pci_ids) = {
+static DEFINE_PCI_DEVICE_TABLE(ivbep_uncore_pci_ids) = {
 	{ /* Home Agent 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe30),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_HA, 0),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_HA, 0),
 	},
 	{ /* Home Agent 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe38),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_HA, 1),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_HA, 1),
 	},
 	{ /* MC0 Channel 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb4),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 0),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 0),
 	},
 	{ /* MC0 Channel 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb5),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 1),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 1),
 	},
 	{ /* MC0 Channel 3 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb0),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 2),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 2),
 	},
 	{ /* MC0 Channel 4 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb1),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 3),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 3),
 	},
 	{ /* MC1 Channel 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef4),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 4),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 4),
 	},
 	{ /* MC1 Channel 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef5),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 5),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 5),
 	},
 	{ /* MC1 Channel 3 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef0),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 6),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 6),
 	},
 	{ /* MC1 Channel 4 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef1),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 7),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 7),
 	},
 	{ /* IRP */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe39),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IRP, 0),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IRP, 0),
 	},
 	{ /* QPI0 Port 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe32),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 0),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_QPI, 0),
 	},
 	{ /* QPI0 Port 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe33),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 1),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_QPI, 1),
 	},
 	{ /* QPI1 Port 2 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3a),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 2),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_QPI, 2),
 	},
 	{ /* R2PCIe */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe34),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R2PCIE, 0),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_R2PCIE, 0),
 	},
 	{ /* R3QPI0 Link 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe36),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 0),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_R3QPI, 0),
 	},
 	{ /* R3QPI0 Link 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe37),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 1),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_R3QPI, 1),
 	},
 	{ /* R3QPI1 Link 2 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3e),
-		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 2),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_R3QPI, 2),
 	},
 	{ /* QPI Port 0 filter  */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe86),
@@ -1628,18 +1628,18 @@ static DEFINE_PCI_DEVICE_TABLE(ivt_uncore_pci_ids) = {
 	{ /* end: all zeroes */ }
 };
 
-static struct pci_driver ivt_uncore_pci_driver = {
-	.name		= "ivt_uncore",
-	.id_table	= ivt_uncore_pci_ids,
+static struct pci_driver ivbep_uncore_pci_driver = {
+	.name		= "ivbep_uncore",
+	.id_table	= ivbep_uncore_pci_ids,
 };
 
-int ivt_uncore_pci_init(void)
+int ivbep_uncore_pci_init(void)
 {
 	int ret = snbep_pci2phy_map_init(0x0e1e);
 	if (ret)
 		return ret;
-	uncore_pci_uncores = ivt_pci_uncores;
-	uncore_pci_driver = &ivt_uncore_pci_driver;
+	uncore_pci_uncores = ivbep_pci_uncores;
+	uncore_pci_driver = &ivbep_uncore_pci_driver;
 	return 0;
 }
 /* end of IvyTown uncore support */
