Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaHLHV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:21:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:38111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaHLHV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:21:56 -0400
Date: Tue, 12 Aug 2014 09:21:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86/uncore: export basic memory events for IVT IMC
 PMU
Message-ID: <20140812072144.GL3588@twins.programming.kicks-ass.net>
References: <20140812060031.GA25239@quad>
 <20140812070915.GM9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1RkCiX/UEfbG28Bk"
Content-Disposition: inline
In-Reply-To: <20140812070915.GM9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1RkCiX/UEfbG28Bk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2014 at 09:09:15AM +0200, Peter Zijlstra wrote:

> Also, I'm very tempted to do a s/ivt/ivbep/ on that whole thing. We
> really should not mix all these stupid names.

---
Subject: perf/x86/uncore: Rename IvyTown to IvyBridge-EP
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Tue Aug 12 09:15:25 CEST 2014

Keeping track of all the various CPU names is hard enough; adding extra
silly names for no reason is just not helping. If we know the base arch
name (IvyBridge) then we can do the client/server parts with the well
known {,EP,EX} postfixes, no need to remember endless amounts of
unrelated and pointless names for this.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c       |    8=20
 arch/x86/kernel/cpu/perf_event_intel_uncore.h       |    4=20
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c |  336 ++++++++++-----=
-----
 3 files changed, 174 insertions(+), 174 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -880,8 +880,8 @@ static int __init uncore_pci_init(void)
 	case 45: /* Sandy Bridge-EP */
 		ret =3D snbep_uncore_pci_init();
 		break;
-	case 62: /* IvyTown */
-		ret =3D ivt_uncore_pci_init();
+	case 62: /* Ivy Bridge-EP */
+		ret =3D ivbep_uncore_pci_init();
 		break;
 	case 42: /* Sandy Bridge */
 		ret =3D snb_uncore_pci_init();
@@ -1187,8 +1187,8 @@ static int __init uncore_cpu_init(void)
 	case 47: /* Westmere-EX aka. Xeon E7 */
 		nhmex_uncore_cpu_init();
 		break;
-	case 62: /* IvyTown */
-		ivt_uncore_cpu_init();
+	case 62: /* Ivy Bridge-EP */
+		ivbep_uncore_cpu_init();
 		break;
=20
 	default:
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
=20
 /* perf_event_intel_uncore_nhmex.c */
 void nhmex_uncore_cpu_init(void);
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -111,43 +111,43 @@
 #define SNBEP_PCU_MSR_CORE_C3_CTR		0x3fc
 #define SNBEP_PCU_MSR_CORE_C6_CTR		0x3fd
=20
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
=20
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
=20
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
=20
 #define __BITS_VALUE(x, i, n)  ((typeof(x))(((x) >> ((i) * (n))) & \
@@ -1088,34 +1088,34 @@ int snbep_uncore_pci_init(void)
 /* end of Sandy Bridge-EP uncore support */
=20
 /* IvyTown uncore support */
-static void ivt_uncore_msr_init_box(struct intel_uncore_box *box)
+static void ivbep_uncore_msr_init_box(struct intel_uncore_box *box)
 {
 	unsigned msr =3D uncore_msr_box_ctl(box);
 	if (msr)
-		wrmsrl(msr, IVT_PMON_BOX_CTL_INT);
+		wrmsrl(msr, IVBEP_PMON_BOX_CTL_INT);
 }
=20
-static void ivt_uncore_pci_init_box(struct intel_uncore_box *box)
+static void ivbep_uncore_pci_init_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev =3D box->pci_dev;
=20
-	pci_write_config_dword(pdev, SNBEP_PCI_PMON_BOX_CTL, IVT_PMON_BOX_CTL_INT=
);
+	pci_write_config_dword(pdev, SNBEP_PCI_PMON_BOX_CTL, IVBEP_PMON_BOX_CTL_I=
NT);
 }
=20
-#define IVT_UNCORE_MSR_OPS_COMMON_INIT()			\
-	.init_box	=3D ivt_uncore_msr_init_box,		\
+#define IVBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
+	.init_box	=3D ivbep_uncore_msr_init_box,		\
 	.disable_box	=3D snbep_uncore_msr_disable_box,		\
 	.enable_box	=3D snbep_uncore_msr_enable_box,		\
 	.disable_event	=3D snbep_uncore_msr_disable_event,	\
 	.enable_event	=3D snbep_uncore_msr_enable_event,	\
 	.read_counter	=3D uncore_msr_read_counter
=20
-static struct intel_uncore_ops ivt_uncore_msr_ops =3D {
-	IVT_UNCORE_MSR_OPS_COMMON_INIT(),
+static struct intel_uncore_ops ivbep_uncore_msr_ops =3D {
+	IVBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 };
=20
-static struct intel_uncore_ops ivt_uncore_pci_ops =3D {
-	.init_box	=3D ivt_uncore_pci_init_box,
+static struct intel_uncore_ops ivbep_uncore_pci_ops =3D {
+	.init_box	=3D ivbep_uncore_pci_init_box,
 	.disable_box	=3D snbep_uncore_pci_disable_box,
 	.enable_box	=3D snbep_uncore_pci_enable_box,
 	.disable_event	=3D snbep_uncore_pci_disable_event,
@@ -1123,15 +1123,15 @@ static struct intel_uncore_ops ivt_uncor
 	.read_counter	=3D snbep_uncore_pci_read_counter,
 };
=20
-#define IVT_UNCORE_PCI_COMMON_INIT()				\
+#define IVBEP_UNCORE_PCI_COMMON_INIT()				\
 	.perf_ctr	=3D SNBEP_PCI_PMON_CTR0,			\
 	.event_ctl	=3D SNBEP_PCI_PMON_CTL0,			\
-	.event_mask	=3D IVT_PMON_RAW_EVENT_MASK,		\
+	.event_mask	=3D IVBEP_PMON_RAW_EVENT_MASK,		\
 	.box_ctl	=3D SNBEP_PCI_PMON_BOX_CTL,		\
-	.ops		=3D &ivt_uncore_pci_ops,			\
-	.format_group	=3D &ivt_uncore_format_group
+	.ops		=3D &ivbep_uncore_pci_ops,			\
+	.format_group	=3D &ivbep_uncore_format_group
=20
-static struct attribute *ivt_uncore_formats_attr[] =3D {
+static struct attribute *ivbep_uncore_formats_attr[] =3D {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
@@ -1140,7 +1140,7 @@ static struct attribute *ivt_uncore_form
 	NULL,
 };
=20
-static struct attribute *ivt_uncore_ubox_formats_attr[] =3D {
+static struct attribute *ivbep_uncore_ubox_formats_attr[] =3D {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
@@ -1149,7 +1149,7 @@ static struct attribute *ivt_uncore_ubox
 	NULL,
 };
=20
-static struct attribute *ivt_uncore_cbox_formats_attr[] =3D {
+static struct attribute *ivbep_uncore_cbox_formats_attr[] =3D {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
@@ -1163,7 +1163,7 @@ static struct attribute *ivt_uncore_cbox
 	NULL,
 };
=20
-static struct attribute *ivt_uncore_pcu_formats_attr[] =3D {
+static struct attribute *ivbep_uncore_pcu_formats_attr[] =3D {
 	&format_attr_event_ext.attr,
 	&format_attr_occ_sel.attr,
 	&format_attr_edge.attr,
@@ -1177,7 +1177,7 @@ static struct attribute *ivt_uncore_pcu_
 	NULL,
 };
=20
-static struct attribute *ivt_uncore_qpi_formats_attr[] =3D {
+static struct attribute *ivbep_uncore_qpi_formats_attr[] =3D {
 	&format_attr_event_ext.attr,
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
@@ -1203,32 +1203,32 @@ static struct attribute *ivt_uncore_qpi_
 	NULL,
 };
=20
-static struct attribute_group ivt_uncore_format_group =3D {
+static struct attribute_group ivbep_uncore_format_group =3D {
 	.name =3D "format",
-	.attrs =3D ivt_uncore_formats_attr,
+	.attrs =3D ivbep_uncore_formats_attr,
 };
=20
-static struct attribute_group ivt_uncore_ubox_format_group =3D {
+static struct attribute_group ivbep_uncore_ubox_format_group =3D {
 	.name =3D "format",
-	.attrs =3D ivt_uncore_ubox_formats_attr,
+	.attrs =3D ivbep_uncore_ubox_formats_attr,
 };
=20
-static struct attribute_group ivt_uncore_cbox_format_group =3D {
+static struct attribute_group ivbep_uncore_cbox_format_group =3D {
 	.name =3D "format",
-	.attrs =3D ivt_uncore_cbox_formats_attr,
+	.attrs =3D ivbep_uncore_cbox_formats_attr,
 };
=20
-static struct attribute_group ivt_uncore_pcu_format_group =3D {
+static struct attribute_group ivbep_uncore_pcu_format_group =3D {
 	.name =3D "format",
-	.attrs =3D ivt_uncore_pcu_formats_attr,
+	.attrs =3D ivbep_uncore_pcu_formats_attr,
 };
=20
-static struct attribute_group ivt_uncore_qpi_format_group =3D {
+static struct attribute_group ivbep_uncore_qpi_format_group =3D {
 	.name =3D "format",
-	.attrs =3D ivt_uncore_qpi_formats_attr,
+	.attrs =3D ivbep_uncore_qpi_formats_attr,
 };
=20
-static struct intel_uncore_type ivt_uncore_ubox =3D {
+static struct intel_uncore_type ivbep_uncore_ubox =3D {
 	.name		=3D "ubox",
 	.num_counters   =3D 2,
 	.num_boxes	=3D 1,
@@ -1236,14 +1236,14 @@ static struct intel_uncore_type ivt_unco
 	.fixed_ctr_bits	=3D 48,
 	.perf_ctr	=3D SNBEP_U_MSR_PMON_CTR0,
 	.event_ctl	=3D SNBEP_U_MSR_PMON_CTL0,
-	.event_mask	=3D IVT_U_MSR_PMON_RAW_EVENT_MASK,
+	.event_mask	=3D IVBEP_U_MSR_PMON_RAW_EVENT_MASK,
 	.fixed_ctr	=3D SNBEP_U_MSR_PMON_UCLK_FIXED_CTR,
 	.fixed_ctl	=3D SNBEP_U_MSR_PMON_UCLK_FIXED_CTL,
-	.ops		=3D &ivt_uncore_msr_ops,
-	.format_group	=3D &ivt_uncore_ubox_format_group,
+	.ops		=3D &ivbep_uncore_msr_ops,
+	.format_group	=3D &ivbep_uncore_ubox_format_group,
 };
=20
-static struct extra_reg ivt_uncore_cbox_extra_regs[] =3D {
+static struct extra_reg ivbep_uncore_cbox_extra_regs[] =3D {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
@@ -1284,37 +1284,37 @@ static struct extra_reg ivt_uncore_cbox_
 	EVENT_EXTRA_END
 };
=20
-static u64 ivt_cbox_filter_mask(int fields)
+static u64 ivbep_cbox_filter_mask(int fields)
 {
 	u64 mask =3D 0;
=20
 	if (fields & 0x1)
-		mask |=3D IVT_CB0_MSR_PMON_BOX_FILTER_TID;
+		mask |=3D IVBEP_CB0_MSR_PMON_BOX_FILTER_TID;
 	if (fields & 0x2)
-		mask |=3D IVT_CB0_MSR_PMON_BOX_FILTER_LINK;
+		mask |=3D IVBEP_CB0_MSR_PMON_BOX_FILTER_LINK;
 	if (fields & 0x4)
-		mask |=3D IVT_CB0_MSR_PMON_BOX_FILTER_STATE;
+		mask |=3D IVBEP_CB0_MSR_PMON_BOX_FILTER_STATE;
 	if (fields & 0x8)
-		mask |=3D IVT_CB0_MSR_PMON_BOX_FILTER_NID;
+		mask |=3D IVBEP_CB0_MSR_PMON_BOX_FILTER_NID;
 	if (fields & 0x10)
-		mask |=3D IVT_CB0_MSR_PMON_BOX_FILTER_OPC;
+		mask |=3D IVBEP_CB0_MSR_PMON_BOX_FILTER_OPC;
=20
 	return mask;
 }
=20
 static struct event_constraint *
-ivt_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *e=
vent)
+ivbep_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event =
*event)
 {
-	return __snbep_cbox_get_constraint(box, event, ivt_cbox_filter_mask);
+	return __snbep_cbox_get_constraint(box, event, ivbep_cbox_filter_mask);
 }
=20
-static int ivt_cbox_hw_config(struct intel_uncore_box *box, struct perf_ev=
ent *event)
+static int ivbep_cbox_hw_config(struct intel_uncore_box *box, struct perf_=
event *event)
 {
 	struct hw_perf_event_extra *reg1 =3D &event->hw.extra_reg;
 	struct extra_reg *er;
 	int idx =3D 0;
=20
-	for (er =3D ivt_uncore_cbox_extra_regs; er->msr; er++) {
+	for (er =3D ivbep_uncore_cbox_extra_regs; er->msr; er++) {
 		if (er->event !=3D (event->hw.config & er->config_mask))
 			continue;
 		idx |=3D er->idx;
@@ -1323,13 +1323,13 @@ static int ivt_cbox_hw_config(struct int
 	if (idx) {
 		reg1->reg =3D SNBEP_C0_MSR_PMON_BOX_FILTER +
 			SNBEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
-		reg1->config =3D event->attr.config1 & ivt_cbox_filter_mask(idx);
+		reg1->config =3D event->attr.config1 & ivbep_cbox_filter_mask(idx);
 		reg1->idx =3D idx;
 	}
 	return 0;
 }
=20
-static void ivt_cbox_enable_event(struct intel_uncore_box *box, struct per=
f_event *event)
+static void ivbep_cbox_enable_event(struct intel_uncore_box *box, struct p=
erf_event *event)
 {
 	struct hw_perf_event *hwc =3D &event->hw;
 	struct hw_perf_event_extra *reg1 =3D &hwc->extra_reg;
@@ -1343,78 +1343,78 @@ static void ivt_cbox_enable_event(struct
 	wrmsrl(hwc->config_base, hwc->config | SNBEP_PMON_CTL_EN);
 }
=20
-static struct intel_uncore_ops ivt_uncore_cbox_ops =3D {
-	.init_box		=3D ivt_uncore_msr_init_box,
+static struct intel_uncore_ops ivbep_uncore_cbox_ops =3D {
+	.init_box		=3D ivbep_uncore_msr_init_box,
 	.disable_box		=3D snbep_uncore_msr_disable_box,
 	.enable_box		=3D snbep_uncore_msr_enable_box,
 	.disable_event		=3D snbep_uncore_msr_disable_event,
-	.enable_event		=3D ivt_cbox_enable_event,
+	.enable_event		=3D ivbep_cbox_enable_event,
 	.read_counter		=3D uncore_msr_read_counter,
-	.hw_config		=3D ivt_cbox_hw_config,
-	.get_constraint		=3D ivt_cbox_get_constraint,
+	.hw_config		=3D ivbep_cbox_hw_config,
+	.get_constraint		=3D ivbep_cbox_get_constraint,
 	.put_constraint		=3D snbep_cbox_put_constraint,
 };
=20
-static struct intel_uncore_type ivt_uncore_cbox =3D {
+static struct intel_uncore_type ivbep_uncore_cbox =3D {
 	.name			=3D "cbox",
 	.num_counters		=3D 4,
 	.num_boxes		=3D 15,
 	.perf_ctr_bits		=3D 44,
 	.event_ctl		=3D SNBEP_C0_MSR_PMON_CTL0,
 	.perf_ctr		=3D SNBEP_C0_MSR_PMON_CTR0,
-	.event_mask		=3D IVT_CBO_MSR_PMON_RAW_EVENT_MASK,
+	.event_mask		=3D IVBEP_CBO_MSR_PMON_RAW_EVENT_MASK,
 	.box_ctl		=3D SNBEP_C0_MSR_PMON_BOX_CTL,
 	.msr_offset		=3D SNBEP_CBO_MSR_OFFSET,
 	.num_shared_regs	=3D 1,
 	.constraints		=3D snbep_uncore_cbox_constraints,
-	.ops			=3D &ivt_uncore_cbox_ops,
-	.format_group		=3D &ivt_uncore_cbox_format_group,
+	.ops			=3D &ivbep_uncore_cbox_ops,
+	.format_group		=3D &ivbep_uncore_cbox_format_group,
 };
=20
-static struct intel_uncore_ops ivt_uncore_pcu_ops =3D {
-	IVT_UNCORE_MSR_OPS_COMMON_INIT(),
+static struct intel_uncore_ops ivbep_uncore_pcu_ops =3D {
+	IVBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 	.hw_config		=3D snbep_pcu_hw_config,
 	.get_constraint		=3D snbep_pcu_get_constraint,
 	.put_constraint		=3D snbep_pcu_put_constraint,
 };
=20
-static struct intel_uncore_type ivt_uncore_pcu =3D {
+static struct intel_uncore_type ivbep_uncore_pcu =3D {
 	.name			=3D "pcu",
 	.num_counters		=3D 4,
 	.num_boxes		=3D 1,
 	.perf_ctr_bits		=3D 48,
 	.perf_ctr		=3D SNBEP_PCU_MSR_PMON_CTR0,
 	.event_ctl		=3D SNBEP_PCU_MSR_PMON_CTL0,
-	.event_mask		=3D IVT_PCU_MSR_PMON_RAW_EVENT_MASK,
+	.event_mask		=3D IVBEP_PCU_MSR_PMON_RAW_EVENT_MASK,
 	.box_ctl		=3D SNBEP_PCU_MSR_PMON_BOX_CTL,
 	.num_shared_regs	=3D 1,
-	.ops			=3D &ivt_uncore_pcu_ops,
-	.format_group		=3D &ivt_uncore_pcu_format_group,
+	.ops			=3D &ivbep_uncore_pcu_ops,
+	.format_group		=3D &ivbep_uncore_pcu_format_group,
 };
=20
-static struct intel_uncore_type *ivt_msr_uncores[] =3D {
-	&ivt_uncore_ubox,
-	&ivt_uncore_cbox,
-	&ivt_uncore_pcu,
+static struct intel_uncore_type *ivbep_msr_uncores[] =3D {
+	&ivbep_uncore_ubox,
+	&ivbep_uncore_cbox,
+	&ivbep_uncore_pcu,
 	NULL,
 };
=20
-void ivt_uncore_cpu_init(void)
+void ivbep_uncore_cpu_init(void)
 {
-	if (ivt_uncore_cbox.num_boxes > boot_cpu_data.x86_max_cores)
-		ivt_uncore_cbox.num_boxes =3D boot_cpu_data.x86_max_cores;
-	uncore_msr_uncores =3D ivt_msr_uncores;
+	if (ivbep_uncore_cbox.num_boxes > boot_cpu_data.x86_max_cores)
+		ivbep_uncore_cbox.num_boxes =3D boot_cpu_data.x86_max_cores;
+	uncore_msr_uncores =3D ivbep_msr_uncores;
 }
=20
-static struct intel_uncore_type ivt_uncore_ha =3D {
+static struct intel_uncore_type ivbep_uncore_ha =3D {
 	.name		=3D "ha",
 	.num_counters   =3D 4,
 	.num_boxes	=3D 2,
 	.perf_ctr_bits	=3D 48,
-	IVT_UNCORE_PCI_COMMON_INIT(),
+	IVBEP_UNCORE_PCI_COMMON_INIT(),
 };
=20
-static struct intel_uncore_type ivt_uncore_imc =3D {
+static struct intel_uncore_type ivbep_uncore_imc =3D {
 	.name		=3D "imc",
 	.num_counters   =3D 4,
 	.num_boxes	=3D 8,
@@ -1423,64 +1423,64 @@ static struct intel_uncore_type ivt_unco
 	.fixed_ctr	=3D SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
 	.fixed_ctl	=3D SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
 	.event_descs	=3D snbep_uncore_imc_events,
-	IVT_UNCORE_PCI_COMMON_INIT(),
+	IVBEP_UNCORE_PCI_COMMON_INIT(),
 };
=20
 /* registers in IRP boxes are not properly aligned */
-static unsigned ivt_uncore_irp_ctls[] =3D {0xd8, 0xdc, 0xe0, 0xe4};
-static unsigned ivt_uncore_irp_ctrs[] =3D {0xa0, 0xb0, 0xb8, 0xc0};
+static unsigned ivbep_uncore_irp_ctls[] =3D {0xd8, 0xdc, 0xe0, 0xe4};
+static unsigned ivbep_uncore_irp_ctrs[] =3D {0xa0, 0xb0, 0xb8, 0xc0};
=20
-static void ivt_uncore_irp_enable_event(struct intel_uncore_box *box, stru=
ct perf_event *event)
+static void ivbep_uncore_irp_enable_event(struct intel_uncore_box *box, st=
ruct perf_event *event)
 {
 	struct pci_dev *pdev =3D box->pci_dev;
 	struct hw_perf_event *hwc =3D &event->hw;
=20
-	pci_write_config_dword(pdev, ivt_uncore_irp_ctls[hwc->idx],
+	pci_write_config_dword(pdev, ivbep_uncore_irp_ctls[hwc->idx],
 			       hwc->config | SNBEP_PMON_CTL_EN);
 }
=20
-static void ivt_uncore_irp_disable_event(struct intel_uncore_box *box, str=
uct perf_event *event)
+static void ivbep_uncore_irp_disable_event(struct intel_uncore_box *box, s=
truct perf_event *event)
 {
 	struct pci_dev *pdev =3D box->pci_dev;
 	struct hw_perf_event *hwc =3D &event->hw;
=20
-	pci_write_config_dword(pdev, ivt_uncore_irp_ctls[hwc->idx], hwc->config);
+	pci_write_config_dword(pdev, ivbep_uncore_irp_ctls[hwc->idx], hwc->config=
);
 }
=20
-static u64 ivt_uncore_irp_read_counter(struct intel_uncore_box *box, struc=
t perf_event *event)
+static u64 ivbep_uncore_irp_read_counter(struct intel_uncore_box *box, str=
uct perf_event *event)
 {
 	struct pci_dev *pdev =3D box->pci_dev;
 	struct hw_perf_event *hwc =3D &event->hw;
 	u64 count =3D 0;
=20
-	pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx], (u32 *)&count);
-	pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx] + 4, (u32 *)&co=
unt + 1);
+	pci_read_config_dword(pdev, ivbep_uncore_irp_ctrs[hwc->idx], (u32 *)&coun=
t);
+	pci_read_config_dword(pdev, ivbep_uncore_irp_ctrs[hwc->idx] + 4, (u32 *)&=
count + 1);
=20
 	return count;
 }
=20
-static struct intel_uncore_ops ivt_uncore_irp_ops =3D {
-	.init_box	=3D ivt_uncore_pci_init_box,
+static struct intel_uncore_ops ivbep_uncore_irp_ops =3D {
+	.init_box	=3D ivbep_uncore_pci_init_box,
 	.disable_box	=3D snbep_uncore_pci_disable_box,
 	.enable_box	=3D snbep_uncore_pci_enable_box,
-	.disable_event	=3D ivt_uncore_irp_disable_event,
-	.enable_event	=3D ivt_uncore_irp_enable_event,
-	.read_counter	=3D ivt_uncore_irp_read_counter,
+	.disable_event	=3D ivbep_uncore_irp_disable_event,
+	.enable_event	=3D ivbep_uncore_irp_enable_event,
+	.read_counter	=3D ivbep_uncore_irp_read_counter,
 };
=20
-static struct intel_uncore_type ivt_uncore_irp =3D {
+static struct intel_uncore_type ivbep_uncore_irp =3D {
 	.name			=3D "irp",
 	.num_counters		=3D 4,
 	.num_boxes		=3D 1,
 	.perf_ctr_bits		=3D 48,
-	.event_mask		=3D IVT_PMON_RAW_EVENT_MASK,
+	.event_mask		=3D IVBEP_PMON_RAW_EVENT_MASK,
 	.box_ctl		=3D SNBEP_PCI_PMON_BOX_CTL,
-	.ops			=3D &ivt_uncore_irp_ops,
-	.format_group		=3D &ivt_uncore_format_group,
+	.ops			=3D &ivbep_uncore_irp_ops,
+	.format_group		=3D &ivbep_uncore_format_group,
 };
=20
-static struct intel_uncore_ops ivt_uncore_qpi_ops =3D {
-	.init_box	=3D ivt_uncore_pci_init_box,
+static struct intel_uncore_ops ivbep_uncore_qpi_ops =3D {
+	.init_box	=3D ivbep_uncore_pci_init_box,
 	.disable_box	=3D snbep_uncore_pci_disable_box,
 	.enable_box	=3D snbep_uncore_pci_enable_box,
 	.disable_event	=3D snbep_uncore_pci_disable_event,
@@ -1491,129 +1491,129 @@ static struct intel_uncore_ops ivt_uncor
 	.put_constraint	=3D uncore_put_constraint,
 };
=20
-static struct intel_uncore_type ivt_uncore_qpi =3D {
+static struct intel_uncore_type ivbep_uncore_qpi =3D {
 	.name			=3D "qpi",
 	.num_counters		=3D 4,
 	.num_boxes		=3D 3,
 	.perf_ctr_bits		=3D 48,
 	.perf_ctr		=3D SNBEP_PCI_PMON_CTR0,
 	.event_ctl		=3D SNBEP_PCI_PMON_CTL0,
-	.event_mask		=3D IVT_QPI_PCI_PMON_RAW_EVENT_MASK,
+	.event_mask		=3D IVBEP_QPI_PCI_PMON_RAW_EVENT_MASK,
 	.box_ctl		=3D SNBEP_PCI_PMON_BOX_CTL,
 	.num_shared_regs	=3D 1,
-	.ops			=3D &ivt_uncore_qpi_ops,
-	.format_group		=3D &ivt_uncore_qpi_format_group,
+	.ops			=3D &ivbep_uncore_qpi_ops,
+	.format_group		=3D &ivbep_uncore_qpi_format_group,
 };
=20
-static struct intel_uncore_type ivt_uncore_r2pcie =3D {
+static struct intel_uncore_type ivbep_uncore_r2pcie =3D {
 	.name		=3D "r2pcie",
 	.num_counters   =3D 4,
 	.num_boxes	=3D 1,
 	.perf_ctr_bits	=3D 44,
 	.constraints	=3D snbep_uncore_r2pcie_constraints,
-	IVT_UNCORE_PCI_COMMON_INIT(),
+	IVBEP_UNCORE_PCI_COMMON_INIT(),
 };
=20
-static struct intel_uncore_type ivt_uncore_r3qpi =3D {
+static struct intel_uncore_type ivbep_uncore_r3qpi =3D {
 	.name		=3D "r3qpi",
 	.num_counters   =3D 3,
 	.num_boxes	=3D 2,
 	.perf_ctr_bits	=3D 44,
 	.constraints	=3D snbep_uncore_r3qpi_constraints,
-	IVT_UNCORE_PCI_COMMON_INIT(),
+	IVBEP_UNCORE_PCI_COMMON_INIT(),
 };
=20
 enum {
-	IVT_PCI_UNCORE_HA,
-	IVT_PCI_UNCORE_IMC,
-	IVT_PCI_UNCORE_IRP,
-	IVT_PCI_UNCORE_QPI,
-	IVT_PCI_UNCORE_R2PCIE,
-	IVT_PCI_UNCORE_R3QPI,
+	IVBEP_PCI_UNCORE_HA,
+	IVBEP_PCI_UNCORE_IMC,
+	IVBEP_PCI_UNCORE_IRP,
+	IVBEP_PCI_UNCORE_QPI,
+	IVBEP_PCI_UNCORE_R2PCIE,
+	IVBEP_PCI_UNCORE_R3QPI,
 };
=20
-static struct intel_uncore_type *ivt_pci_uncores[] =3D {
-	[IVT_PCI_UNCORE_HA]	=3D &ivt_uncore_ha,
-	[IVT_PCI_UNCORE_IMC]	=3D &ivt_uncore_imc,
-	[IVT_PCI_UNCORE_IRP]	=3D &ivt_uncore_irp,
-	[IVT_PCI_UNCORE_QPI]	=3D &ivt_uncore_qpi,
-	[IVT_PCI_UNCORE_R2PCIE]	=3D &ivt_uncore_r2pcie,
-	[IVT_PCI_UNCORE_R3QPI]	=3D &ivt_uncore_r3qpi,
+static struct intel_uncore_type *ivbep_pci_uncores[] =3D {
+	[IVBEP_PCI_UNCORE_HA]	=3D &ivbep_uncore_ha,
+	[IVBEP_PCI_UNCORE_IMC]	=3D &ivbep_uncore_imc,
+	[IVBEP_PCI_UNCORE_IRP]	=3D &ivbep_uncore_irp,
+	[IVBEP_PCI_UNCORE_QPI]	=3D &ivbep_uncore_qpi,
+	[IVBEP_PCI_UNCORE_R2PCIE]	=3D &ivbep_uncore_r2pcie,
+	[IVBEP_PCI_UNCORE_R3QPI]	=3D &ivbep_uncore_r3qpi,
 	NULL,
 };
=20
-static DEFINE_PCI_DEVICE_TABLE(ivt_uncore_pci_ids) =3D {
+static DEFINE_PCI_DEVICE_TABLE(ivbep_uncore_pci_ids) =3D {
 	{ /* Home Agent 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe30),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_HA, 0),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_HA, 0),
 	},
 	{ /* Home Agent 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe38),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_HA, 1),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_HA, 1),
 	},
 	{ /* MC0 Channel 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb4),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 0),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 0),
 	},
 	{ /* MC0 Channel 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb5),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 1),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 1),
 	},
 	{ /* MC0 Channel 3 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb0),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 2),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 2),
 	},
 	{ /* MC0 Channel 4 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb1),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 3),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 3),
 	},
 	{ /* MC1 Channel 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef4),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 4),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 4),
 	},
 	{ /* MC1 Channel 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef5),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 5),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 5),
 	},
 	{ /* MC1 Channel 3 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef0),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 6),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 6),
 	},
 	{ /* MC1 Channel 4 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef1),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 7),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IMC, 7),
 	},
 	{ /* IRP */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe39),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IRP, 0),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_IRP, 0),
 	},
 	{ /* QPI0 Port 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe32),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 0),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_QPI, 0),
 	},
 	{ /* QPI0 Port 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe33),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 1),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_QPI, 1),
 	},
 	{ /* QPI1 Port 2 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3a),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 2),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_QPI, 2),
 	},
 	{ /* R2PCIe */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe34),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R2PCIE, 0),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_R2PCIE, 0),
 	},
 	{ /* R3QPI0 Link 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe36),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 0),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_R3QPI, 0),
 	},
 	{ /* R3QPI0 Link 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe37),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 1),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_R3QPI, 1),
 	},
 	{ /* R3QPI1 Link 2 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3e),
-		.driver_data =3D UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 2),
+		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_R3QPI, 2),
 	},
 	{ /* QPI Port 0 filter  */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe86),
@@ -1628,18 +1628,18 @@ static DEFINE_PCI_DEVICE_TABLE(ivt_uncor
 	{ /* end: all zeroes */ }
 };
=20
-static struct pci_driver ivt_uncore_pci_driver =3D {
-	.name		=3D "ivt_uncore",
-	.id_table	=3D ivt_uncore_pci_ids,
+static struct pci_driver ivbep_uncore_pci_driver =3D {
+	.name		=3D "ivbep_uncore",
+	.id_table	=3D ivbep_uncore_pci_ids,
 };
=20
-int ivt_uncore_pci_init(void)
+int ivbep_uncore_pci_init(void)
 {
 	int ret =3D snbep_pci2phy_map_init(0x0e1e);
 	if (ret)
 		return ret;
-	uncore_pci_uncores =3D ivt_pci_uncores;
-	uncore_pci_driver =3D &ivt_uncore_pci_driver;
+	uncore_pci_uncores =3D ivbep_pci_uncores;
+	uncore_pci_driver =3D &ivbep_uncore_pci_driver;
 	return 0;
 }
 /* end of IvyTown uncore support */

--1RkCiX/UEfbG28Bk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6cCIAAoJEHZH4aRLwOS6x6wP/Ax3MMq9xOOM0rD9YS0vJP6S
2cGPEkZiQlMg+6MAxbwOQnnUljvRpw87CgtZhOpoc35lr3GyN+zVgSAYCkSLg45K
DOlqVN72XjdCv2xAcgKdzPIPj3FRHmVnmaitD70CpG7Px/7SMYzBMhunuJUcOhMM
0UgWqUjNbU/vlHN1U69tJVBCRClVfENwkYINT8QYOHnaaO1lJ4mmXeB4g44xgrHf
rMC8bjWCknicsXdrUrruaOhFZK51L1pLm0K31+ayQo/tNAvC+uabYDsIpGW6QKD0
9LHtObgQQHUdCxyeLJD4CzKz67I7jnlkv8UncndZEQCQoIT9GrSF25N4APivwoxB
SxVgWq0TS11uKneNmkLUyW3tQu2v1pvKNuOm6+h4YuXNrcTvnJlNyjeZ4vQ+TXkY
Md5FvcPBVXGA4RFUZKZoiCUslOog7jvB20TYALxJyITHvwtacAm4n8KRuZxikcZ5
N40ji+KWemtlq7ZxHjg4JJsmR83x5QlHB9BD5LfQMoL9XOM4L7XtDeh37MAheNLt
VzqXYESCCJ17ElvbzhsSe7w0LLL34IBGEGH095gYQ1uokvllKkRGiFA3plgIo2GV
fNZomyxTSUcBcVoPSDX6fz5uBAV1ayjrfs5bNfML625MCZvO2muDbbI05J/BoM3V
s80NHjxlITGXrzZjQZk/
=kHnk
-----END PGP SIGNATURE-----

--1RkCiX/UEfbG28Bk--
