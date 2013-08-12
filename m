Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3HLI4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:56:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35063 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3HLI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:56:50 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-e2-5208a35093c8
From: Jingoo Han <jg1.han@samsung.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] PCI: exynos: add support for MSI
Date: Mon, 12 Aug 2013 17:56:47 +0900
Message-id: <000401ce9739$e0a65410$a1f2fc30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6XOUAvrHphvPBDSeiiuJMAE5xuJg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+ZoW7AYo4gg70NEhZ/Jx1jt1jSlGHx
	8pCmxfwj51gtLi+8xGrRu+Aqm8WFpz1sFpd3zWGzODvvOJvFjPP7mCw2Tv3FaNF+SdliRdNW
	Roufu+axWDx90MRk0Xj0AatF65MHjA6CHr9/TWL0eLLpIqPHzll32T0WbCr1+L5wPrtH35ZV
	jB5Pf+xl9jh+YzuTx+dNcgGcUVw2Kak5mWWpRfp2CVwZ3w69Yiy4EFYx5aRsA+NH1y5GTg4J
	AROJD3Ofs0DYYhIX7q1n62Lk4hASWMYocWziGVaYon+vZjBCJBYxSuxvb2OCcH4xSnxcPBus
	ik1ATeLLl8PsILaIgLrEwqPvwYqYBS6wSBy6NxVoBweHsIChRPN3RpAaFgFVicu7toDZvAKW
	ErNuPGCBsAUlfky+B2YzC2hJrN95nAnClpfYvOYtM8RFChI7zr5mhNilJ7F62hpWiBoRiX0v
	3oFdKiGwhUPi1P8/bBDLBCS+TT4EdoOEgKzEpgNQcyQlDq64wTKBUWwWktWzkKyehWT1LCQr
	FjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQISQkTdjDeO2B9iDEZaP1EZinR5HxgSskr
	iTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OS77OE
	j525c38vi8Nt7+Vx76QubzsU4DSjJjHoYEzb2z/uJ1LddQq6anMWLXxTNmPyd9YX3esC7nNp
	3ReN2PhfNXxmZsdPztYY2avW8cpn+rQ8RBI2vQkrVf4h9tHqoseMifmMpSlR26tX5556eLX5
	s7FCvqG8Pfs6hdJfH7qEFn37E9ZSUKjEUpyRaKjFXFScCADicwsdHwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jAd2AxRxBBi1NAhZ/Jx1jt1jSlGHx
	8pCmxfwj51gtLi+8xGrRu+Aqm8WFpz1sFpd3zWGzODvvOJvFjPP7mCw2Tv3FaNF+SdliRdNW
	Roufu+axWDx90MRk0Xj0AatF65MHjA6CHr9/TWL0eLLpIqPHzll32T0WbCr1+L5wPrtH35ZV
	jB5Pf+xl9jh+YzuTx+dNcgGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlAnygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesY
	M74desVYcCGsYspJ2QbGj65djJwcEgImEv9ezWCEsMUkLtxbz9bFyMUhJLCIUWJ/exsThPOL
	UeLj4tmsIFVsAmoSX74cZgexRQTUJRYefQ9WxCxwgUXi0L2pLF2MHBzCAoYSzd/BprIIqEpc
	3rUFzOYVsJSYdeMBC4QtKPFj8j0wm1lAS2L9zuNMELa8xOY1b5khLlKQ2HH2NSPELj2J1dPW
	sELUiEjse/GOcQKjwCwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/d
	xAhOOM+kdzCuarA4xCjAwajEw+vxhT1IiDWxrLgy9xCjBAezkgiv2jyOICHelMTKqtSi/Pii
	0pzU4kOMyUCfTmSWEk3OBybDvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphak
	FsFsYeLglGpgVHnw/PlUzZq0COd3s8/tWiAV7Pfozzpre//VIY8Sv0dM4Xw7qfJBhvZN2ZOq
	S7YxK3Fc8NAXXihu90wyPYGF7ckWm0CmxSrlrUxeUq5zfius1qqpPrb4pGCe1p5HD25Zr8sW
	XxK41OvDQaVHKnt71/ppMMdO73zZYna/NG5OUSZnWEii84t1SizFGYmGWsxFxYkAtRuUlnwD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Message Signaled Interrupt in the
Exynops PCIe diver using Synopsys designware PCIe core IP.

Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
Signed-off-by: Srikanth T Shivanand <ts.srikanth@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Pratyush Anand <pratyush.anand@st.com>
Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
---
 arch/arm/boot/dts/exynos5440.dtsi  |    2 +
 arch/arm/mach-exynos/Kconfig       |    1 +
 drivers/pci/host/pci-exynos.c      |   60 ++++++++++
 drivers/pci/host/pcie-designware.c |  213 ++++++++++++++++++++++++++++++++++++
 drivers/pci/host/pcie-designware.h |    8 ++
 5 files changed, 284 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 586134e..3746835 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -249,6 +249,7 @@
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0x0 0 &gic 53>;
 		num-lanes = <4>;
+		msi-base = <200>;
 	};
 
 	pcie@2a0000 {
@@ -269,5 +270,6 @@
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0x0 0 &gic 56>;
 		num-lanes = <4>;
+		msi-base = <232>;
 	};
 };
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 855d4a7..9ef1c95 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -93,6 +93,7 @@ config SOC_EXYNOS5440
 	default y
 	depends on ARCH_EXYNOS5
 	select ARCH_HAS_OPP
+	select ARCH_SUPPORTS_MSI
 	select HAVE_ARM_ARCH_TIMER
 	select AUTO_ZRELADDR
 	select MIGHT_HAVE_PCI
diff --git a/drivers/pci/host/pci-exynos.c b/drivers/pci/host/pci-exynos.c
index 012ca8a..d0477d0 100644
--- a/drivers/pci/host/pci-exynos.c
+++ b/drivers/pci/host/pci-exynos.c
@@ -48,6 +48,7 @@ struct exynos_pcie {
 #define PCIE_IRQ_SPECIAL		0x008
 #define PCIE_IRQ_EN_PULSE		0x00c
 #define PCIE_IRQ_EN_LEVEL		0x010
+#define IRQ_MSI_ENABLE			(0x1 << 2)
 #define PCIE_IRQ_EN_SPECIAL		0x014
 #define PCIE_PWR_RESET			0x018
 #define PCIE_CORE_RESET			0x01c
@@ -320,9 +321,51 @@ static irqreturn_t exynos_pcie_irq_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_PCI_MSI
+static void exynos_pcie_clear_irq_level(struct pcie_port *pp)
+{
+	u32 val;
+	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
+	void __iomem *elbi_base = exynos_pcie->elbi_base;
+
+	val = readl(elbi_base + PCIE_IRQ_LEVEL);
+	writel(val, elbi_base + PCIE_IRQ_LEVEL);
+	return;
+}
+
+static irqreturn_t exynos_pcie_msi_irq_handler(int irq, void *arg)
+{
+	struct pcie_port *pp = arg;
+
+	/* handle msi irq */
+	dw_handle_msi_irq(pp);
+	exynos_pcie_clear_irq_level(pp);
+
+	return IRQ_HANDLED;
+}
+
+static void exynos_pcie_msi_init(struct pcie_port *pp)
+{
+	u32 val;
+	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
+	void __iomem *elbi_base = exynos_pcie->elbi_base;
+
+	dw_pcie_msi_init(pp);
+
+	/* enable MSI interrupt */
+	val = readl(elbi_base + PCIE_IRQ_EN_LEVEL);
+	val |= IRQ_MSI_ENABLE;
+	writel(val, elbi_base + PCIE_IRQ_EN_LEVEL);
+	return;
+}
+#endif
+
 static void exynos_pcie_enable_interrupts(struct pcie_port *pp)
 {
 	exynos_pcie_enable_irq_pulse(pp);
+#ifdef CONFIG_PCI_MSI
+	exynos_pcie_msi_init(pp);
+#endif
 	return;
 }
 
@@ -408,6 +451,23 @@ static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
 		return ret;
 	}
 
+#ifdef CONFIG_PCI_MSI
+	pp->msi_irq = platform_get_irq(pdev, 0);
+
+	if (!pp->msi_irq) {
+		dev_err(&pdev->dev, "failed to get msi irq\n");
+		return -ENODEV;
+	}
+
+	ret = devm_request_irq(&pdev->dev, pp->msi_irq,
+				exynos_pcie_msi_irq_handler,
+				IRQF_SHARED, "exynos-pcie", pp);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request msi irq\n");
+		return ret;
+	}
+#endif
+
 	pp->root_bus_nr = -1;
 	pp->ops = &exynos_pcie_host_ops;
 
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 77b0c25..5a47f11 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -11,8 +11,10 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/msi.h>
 #include <linux/of_address.h>
 #include <linux/pci.h>
 #include <linux/pci_regs.h>
@@ -62,6 +64,14 @@
 #define PCIE_ATU_FUNC(x)		(((x) & 0x7) << 16)
 #define PCIE_ATU_UPPER_TARGET		0x91C
 
+#ifdef CONFIG_PCI_MSI
+#define MAX_MSI_IRQS			32
+#define MAX_MSI_CTRLS			8
+
+static unsigned int msi_data;
+static DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
+#endif
+
 static struct hw_pci dw_pci;
 
 unsigned long global_io_offset;
@@ -144,6 +154,202 @@ int dw_pcie_wr_own_conf(struct pcie_port *pp, int where, int size,
 	return ret;
 }
 
+#ifdef CONFIG_PCI_MSI
+static struct irq_chip dw_msi_chip = {
+	.name = "PCI-MSI",
+	.irq_enable = unmask_msi_irq,
+	.irq_disable = mask_msi_irq,
+	.irq_mask = mask_msi_irq,
+	.irq_unmask = unmask_msi_irq,
+};
+
+/* MSI int handler */
+void dw_handle_msi_irq(struct pcie_port *pp)
+{
+	unsigned long val;
+	int i, pos;
+
+	for (i = 0; i < MAX_MSI_CTRLS; i++) {
+		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4,
+				(u32 *)&val);
+		if (val) {
+			pos = 0;
+			while ((pos = find_next_bit(&val, 32, pos)) != 32) {
+				generic_handle_irq(pp->msi_irq_start
+					+ (i * 32) + pos);
+				pos++;
+			}
+		}
+		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4, val);
+	}
+}
+
+void dw_pcie_msi_init(struct pcie_port *pp)
+{
+	/* program the msi_data */
+	dw_pcie_wr_own_conf(pp, PCIE_MSI_ADDR_LO, 4,
+			__virt_to_phys((u32)(&msi_data)));
+	dw_pcie_wr_own_conf(pp, PCIE_MSI_ADDR_HI, 4, 0);
+}
+
+static int find_valid_pos0(int msgvec, int pos, int *pos0)
+{
+	int flag = 1;
+
+	do {
+		pos = find_next_zero_bit(msi_irq_in_use,
+				MAX_MSI_IRQS, pos);
+		/*if you have reached to the end then get out from here.*/
+		if (pos == MAX_MSI_IRQS)
+			return -ENOSPC;
+		/*
+		 * Check if this position is at correct offset.nvec is always a
+		 * power of two. pos0 must be nvec bit alligned.
+		 */
+		if (pos % msgvec)
+			pos += msgvec - (pos % msgvec);
+		else
+			flag = 0;
+	} while (flag);
+
+	*pos0 = pos;
+	return 0;
+}
+
+/* Dynamic irq allocate and deallocation */
+static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
+{
+	int res, bit, irq, pos0, pos1, i;
+	u32 val;
+	struct pcie_port *pp = sys_to_pcie(desc->dev->bus->sysdata);
+
+	if (!pp) {
+		BUG();
+		return -EINVAL;
+	}
+
+	pos0 = find_first_zero_bit(msi_irq_in_use,
+			MAX_MSI_IRQS);
+	if (pos0 % no_irqs) {
+		if (find_valid_pos0(no_irqs, pos0, &pos0))
+			goto no_valid_irq;
+	}
+	if (no_irqs > 1) {
+		pos1 = find_next_bit(msi_irq_in_use,
+				MAX_MSI_IRQS, pos0);
+		/* there must be nvec number of consecutive free bits */
+		while ((pos1 - pos0) < no_irqs) {
+			if (find_valid_pos0(no_irqs, pos1, &pos0))
+				goto no_valid_irq;
+			pos1 = find_next_bit(msi_irq_in_use,
+					MAX_MSI_IRQS, pos0);
+		}
+	}
+
+	irq = (pp->msi_irq_start + pos0);
+
+	if ((irq + no_irqs) > (pp->msi_irq_start + MAX_MSI_IRQS-1))
+		goto no_valid_irq;
+
+	i = 0;
+	while (i < no_irqs) {
+		set_bit(pos0 + i, msi_irq_in_use);
+		irq_alloc_descs((irq + i), (irq + i), 1, 0);
+		irq_set_msi_desc(irq + i, desc);
+		irq_set_chip_and_handler(irq + i, &dw_msi_chip,
+					handle_simple_irq);
+		set_irq_flags(irq + i, IRQF_VALID);
+		/*Enable corresponding interrupt in MSI interrupt controller */
+		res = ((pos0 + i) / 32) * 12;
+		bit = (pos0 + i) % 32;
+		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
+		val |= 1 << bit;
+		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
+		i++;
+	}
+
+	*pos = pos0;
+	return irq;
+
+no_valid_irq:
+	*pos = pos0;
+	return -ENOSPC;
+}
+
+static void clear_irq(unsigned int irq)
+{
+	int res, bit, val, pos;
+	struct irq_desc *desc;
+	struct msi_desc *msi;
+	struct pcie_port *pp;
+
+	/* get the port structure */
+	desc = irq_to_desc(irq);
+	msi = irq_desc_get_msi_desc(desc);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	if (!pp) {
+		BUG();
+		return;
+	}
+
+	pos = irq - pp->msi_irq_start;
+
+	irq_free_desc(irq);
+
+	clear_bit(pos, msi_irq_in_use);
+
+	/* Disable corresponding interrupt on MSI interrupt controller */
+	res = (pos / 32) * 12;
+	bit = pos % 32;
+	dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
+	val &= ~(1 << bit);
+	dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
+}
+
+int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
+{
+	int irq, pos, msgvec;
+	u16 msg_ctr;
+	struct msi_msg msg;
+	struct pcie_port *pp = sys_to_pcie(pdev->bus->sysdata);
+
+	if (!pp) {
+		BUG();
+		return -EINVAL;
+	}
+
+	pci_read_config_word(pdev, desc->msi_attrib.pos+PCI_MSI_FLAGS,
+				&msg_ctr);
+	msgvec = (msg_ctr&PCI_MSI_FLAGS_QSIZE) >> 4;
+	if (msgvec == 0)
+		msgvec = (msg_ctr & PCI_MSI_FLAGS_QMASK) >> 1;
+	if (msgvec > 5)
+		msgvec = 0;
+
+	irq = assign_irq((1 << msgvec), desc, &pos);
+	if (irq < 0)
+		return irq;
+
+	msg_ctr &= ~PCI_MSI_FLAGS_QSIZE;
+	msg_ctr |= msgvec << 4;
+	pci_write_config_word(pdev, desc->msi_attrib.pos + PCI_MSI_FLAGS,
+				msg_ctr);
+	desc->msi_attrib.multiple = msgvec;
+
+	msg.address_hi = 0x0;
+	msg.address_lo = __virt_to_phys((u32)(&msi_data));
+	msg.data = pos;
+	write_msi_msg(irq, &msg);
+
+	return 0;
+}
+
+void arch_teardown_msi_irq(unsigned int irq)
+{
+	clear_irq(irq);
+}
+#endif
+
 int dw_pcie_link_up(struct pcie_port *pp)
 {
 	if (pp->ops->link_up)
@@ -225,6 +431,13 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		return -EINVAL;
 	}
 
+#ifdef CONFIG_PCI_MSI
+	if (of_property_read_u32(np, "msi-base", &pp->msi_irq_start)) {
+		dev_err(pp->dev, "Failed to parse the number of lanes\n");
+		return -EINVAL;
+	}
+#endif
+
 	if (pp->ops->host_init)
 		pp->ops->host_init(pp);
 
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index 133820f..fcff10e 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -38,6 +38,10 @@ struct pcie_port {
 	int			irq;
 	u32			lanes;
 	struct pcie_host_ops	*ops;
+#ifdef CONFIG_PCI_MSI
+	int			msi_irq;
+	int			msi_irq_start;
+#endif
 };
 
 struct pcie_host_ops {
@@ -57,6 +61,10 @@ int cfg_read(void __iomem *addr, int where, int size, u32 *val);
 int cfg_write(void __iomem *addr, int where, int size, u32 val);
 int dw_pcie_wr_own_conf(struct pcie_port *pp, int where, int size, u32 val);
 int dw_pcie_rd_own_conf(struct pcie_port *pp, int where, int size, u32 *val);
+#ifdef CONFIG_PCI_MSI
+void dw_handle_msi_irq(struct pcie_port *pp);
+void dw_pcie_msi_init(struct pcie_port *pp);
+#endif
 int dw_pcie_link_up(struct pcie_port *pp);
 void dw_pcie_setup_rc(struct pcie_port *pp);
 int dw_pcie_host_init(struct pcie_port *pp);
-- 
1.7.10.4


