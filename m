Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaDPEnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:43:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11357 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaDPEn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:43:28 -0400
X-AuditID: cbfee690-b7f266d00000287c-33-534e0a6fe8a5
From: Jingoo Han <jg1.han@samsung.com>
To: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
In-reply-to: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
Subject: [RFC PATCH 2/2] PCI: exynos: Add PCIe support for Samsung GH7 SoC
Date: Wed, 16 Apr 2014 13:43:26 +0900
Message-id: <000a01cf592e$67e592e0$37b0b8a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9ZLjB5lnZMYwshRiWF5lDNQlfulQAACcWA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t8zQ918Lr9gg75ZXBZ/Jx1jt1jSlGFx
	eeElVoveBVfZLN4fesZssenxNVaLy7vmsFmcnXeczeLA0nYWB06PNfPWMHr8/jWJ0WPBplKP
	zUvqPW7/e8zs0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBltl34zFzzzrujZfYGtgfG0Qxcj
	J4eEgInE1a6/rBC2mMSFe+vZuhi5OIQEljFKXLm7jxWmqO3GDWaIxHRGiXl956GqfjNK3J69
	kRGkik1ATeLLl8PsILaIQIjE77u3wYqYBf4wSuw8eY8ZJCEkYCvx/eIrJhCbU8BO4vvy5ywg
	trCAl8SW+xPZQGwWAVWJRTe6wOK8QPV/ml4yQtiCEj8m3wOLMwtoSazfeZwJwpaX2LzmLdB8
	DqBT1SUe/dWFuMFI4uP3jewQJSIS+168YwS5R0KglUPiytR5LBC7BCS+TT7EAtErK7HpADPE
	x5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKE
	xPiEHYz3DlgfYkwGWj+RWUo0OR+YIvJK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQkJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgVHExrr9adjy3zor2jd2FLzjaTANONYipP+CeblA1bxzggql
	MvlW7/quBQq840kWlvW9dnzKM7cVKaIHvBT275gnK+0Smrh4hW+AwLbjM7deKVQODvx2SHyW
	/7f567vkKn5levO9mb58gosN68LTjQXXhMNPiszlfjtfWGHBqn9cyT9/ONx3XKbEUpyRaKjF
	XFScCAAXDuLOBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jQd18Lr9gg2fzWCz+TjrGbrGkKcPi
	8sJLrBa9C66yWbw/9IzZYtPja6wWl3fNYbM4O+84m8WBpe0sDpwea+atYfT4/WsSo8eCTaUe
	m5fUe9z+95jZo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jFmtF36zVzwzLuiZ/cFtgbG0w5djJwcEgImEm03bjBD2GISF+6tZ+ti5OIQEpjOKDGv7zyU
	85tR4vbsjYwgVWwCahJfvhxmB7FFBEIkft+9DVbELPCHUWLnyXtgo4QEbCW+X3zFBGJzCthJ
	fF/+nAXEFhbwkthyfyIbiM0ioCqx6EYXWJwXqP5P00tGCFtQ4sfke2BxZgEtifU7jzNB2PIS
	m9e8BZrPAXSqusSjv7oQNxhJfPy+kR2iRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNo
	akFyQXFSeq6hXnFibnFpXrpecn7uJkZwAnkmtYNxZYPFIUYBDkYlHt4ZOb7BQqyJZcWVuYcY
	JTiYlUR4v3wBCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MLnllcQbGpuYGVkamVkYmZib
	kyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPj4a6E2QETY+yC1kxuMjjwdduxsEdTBOUL
	SvW3hSZPDk+6nab4JuqB3oV8gSsNYipOS/i++5i9jdwixPGjYnlc5wmmm2a/X85rN+V5KKet
	ddjg8VSx+GqXmT8zdBYbaxTMWBD9POPk7S2cX4ymZZ+U38O63jGQ/bBg/eXt245I8NRPZGbQ
	WtijxFKckWioxVxUnAgAhproI2QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samsung GH7 has four PCIe controllers which can be used as root
complex for PCIe interface.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pci/host/Kconfig      |    2 +-
 drivers/pci/host/pci-exynos.c |  135 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 126 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index a6f67ec..3be047c 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -11,7 +11,7 @@ config PCIE_DW
 
 config PCI_EXYNOS
 	bool "Samsung Exynos PCIe controller"
-	depends on SOC_EXYNOS5440
+	depends on SOC_EXYNOS5440 || ARCH_GH7
 	select PCIEPORTBUS
 	select PCIE_DW
 
diff --git a/drivers/pci/host/pci-exynos.c b/drivers/pci/host/pci-exynos.c
index 3de6bfb..6e845ca 100644
--- a/drivers/pci/host/pci-exynos.c
+++ b/drivers/pci/host/pci-exynos.c
@@ -57,6 +57,8 @@ struct exynos_pcie {
 #define PCIE_NONSTICKY_RESET		0x024
 #define PCIE_APP_INIT_RESET		0x028
 #define PCIE_APP_LTSSM_ENABLE		0x02c
+#define PCIE_SYS_AUX_PWR_DET		0x038
+#define PCIE_SYS_AUX_PWR_ENABLE		(0x1 << 0)
 #define PCIE_ELBI_RDLH_LINKUP		0x064
 #define PCIE_ELBI_LTSSM_ENABLE		0x1
 #define PCIE_ELBI_SLV_AWMISC		0x11c
@@ -72,6 +74,23 @@ struct exynos_pcie {
 #define PCIE_PHY_TRSVREG_RESET		0x020
 #define PCIE_PHY_TRSV_RESET		0x024
 
+/* PCIe PHY glue registers */
+#define PCIE_PHY_GLUE_REG0		0x000
+#define PCIE_PHY_GLUE_GLOBAL_RESET	(0x1 << 0)
+#define PCIE_PHY_GLUE_COMMON_RESET	(0x1 << 1)
+#define PCIE_PHY_GLUE_MAC_RESET		(0x1 << 11)
+#define PCIE_PHY_GLUE_REG2		0x008
+#define PCIE_PHY_GLUE_CLK100M_DS_MAX	(0x7 << 0)
+#define PCIE_PHY_GLUE_CLK100M_RFCLK	(0x1 << 3)
+#define PCIE_PHY_GLUE_CLK100M_ENABLE	(0x1 << 4)
+#define PCIE_PHY_GLUE_PLL_BUF_ENABLE	(0x1 << 8)
+#define PCIE_PHY_GLUE_PLL_DIV_ENABLE	(0x1 << 9)
+#define PCIE_PHY_GLUE_REFCLK_IN(x)	(((x) & 0xf) << 10)
+#define PCIE_PHY_GLUE_REG3		0x00c
+#define PCIE_PHY_GLUE_REF_RATE_100MHZ	(0x2 << 0)
+#define PCIE_PHY_GLUE_REG4		0x010
+#define PCIE_PHY_GLUE_MODE_PCIE		(0x0 << 0)
+
 /* PCIe PHY registers */
 #define PCIE_PHY_IMPEDANCE		0x004
 #define PCIE_PHY_PLL_DIV_0		0x008
@@ -164,11 +183,45 @@ static void exynos_pcie_sideband_dbi_r_mode(struct pcie_port *pp, bool on)
 	}
 }
 
+static void exynos_pcie_set_phy_mode(struct pcie_port *pp)
+{
+	u32 val;
+	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
+
+	if (!of_device_is_compatible(pp->dev->of_node, "samsung,gh7-pcie"))
+		return;
+
+	/* configure phy reference clock setting */
+	val = exynos_blk_readl(exynos_pcie, PCIE_PHY_GLUE_REG2);
+	val |= PCIE_PHY_GLUE_CLK100M_ENABLE | PCIE_PHY_GLUE_CLK100M_RFCLK |
+		PCIE_PHY_GLUE_CLK100M_DS_MAX;
+	exynos_blk_writel(exynos_pcie, val, PCIE_PHY_GLUE_REG2);
+
+	val = exynos_blk_readl(exynos_pcie, PCIE_PHY_GLUE_REG2);
+	val |= PCIE_PHY_GLUE_PLL_DIV_ENABLE | PCIE_PHY_GLUE_PLL_BUF_ENABLE;
+	exynos_blk_writel(exynos_pcie, val, PCIE_PHY_GLUE_REG2);
+
+	val = exynos_blk_readl(exynos_pcie, PCIE_PHY_GLUE_REG2);
+	val |= PCIE_PHY_GLUE_REFCLK_IN(6);
+	exynos_blk_writel(exynos_pcie, val, PCIE_PHY_GLUE_REG2);
+
+	/* set phy reference clock  */
+	exynos_blk_writel(exynos_pcie, PCIE_PHY_GLUE_REF_RATE_100MHZ,
+			  PCIE_PHY_GLUE_REG3);
+
+	/* set phy mode to pcie mode */
+	exynos_blk_writel(exynos_pcie, PCIE_PHY_GLUE_MODE_PCIE,
+			  PCIE_PHY_GLUE_REG4);
+}
+
 static void exynos_pcie_assert_core_reset(struct pcie_port *pp)
 {
 	u32 val;
 	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
 
+	if (of_device_is_compatible(pp->dev->of_node, "samsung,gh7-pcie"))
+		return;
+
 	val = exynos_elb_readl(exynos_pcie, PCIE_CORE_RESET);
 	val &= ~PCIE_CORE_RESET_ENABLE;
 	exynos_elb_writel(exynos_pcie, val, PCIE_CORE_RESET);
@@ -190,27 +243,48 @@ static void exynos_pcie_deassert_core_reset(struct pcie_port *pp)
 	exynos_elb_writel(exynos_pcie, 1, PCIE_NONSTICKY_RESET);
 	exynos_elb_writel(exynos_pcie, 1, PCIE_APP_INIT_RESET);
 	exynos_elb_writel(exynos_pcie, 0, PCIE_APP_INIT_RESET);
-	exynos_blk_writel(exynos_pcie, 1, PCIE_PHY_MAC_RESET);
+
+	if (of_device_is_compatible(pp->dev->of_node, "samsung,gh7-pcie")) {
+		val = exynos_blk_readl(exynos_pcie, PCIE_PHY_GLUE_REG0);
+		val |= PCIE_PHY_GLUE_MAC_RESET;
+		exynos_blk_writel(exynos_pcie, val, PCIE_PHY_GLUE_REG0);
+	} else {
+		exynos_blk_writel(exynos_pcie, 1, PCIE_PHY_MAC_RESET);
+	}
 }
 
 static void exynos_pcie_assert_phy_reset(struct pcie_port *pp)
 {
 	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
 
+	if (of_device_is_compatible(pp->dev->of_node, "samsung,gh7-pcie"))
+		return;
+
 	exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_MAC_RESET);
 	exynos_blk_writel(exynos_pcie, 1, PCIE_PHY_GLOBAL_RESET);
 }
 
 static void exynos_pcie_deassert_phy_reset(struct pcie_port *pp)
 {
+	u32 val;
 	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
 
-	exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_GLOBAL_RESET);
-	exynos_elb_writel(exynos_pcie, 1, PCIE_PWR_RESET);
-	exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_COMMON_RESET);
-	exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_CMN_REG);
-	exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_TRSVREG_RESET);
-	exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_TRSV_RESET);
+	if (of_device_is_compatible(pp->dev->of_node, "samsung,gh7-pcie")) {
+		val = exynos_blk_readl(exynos_pcie, PCIE_PHY_GLUE_REG0);
+		val |= PCIE_PHY_GLUE_GLOBAL_RESET;
+		exynos_blk_writel(exynos_pcie, val, PCIE_PHY_GLUE_REG0);
+		exynos_elb_writel(exynos_pcie, 1, PCIE_PWR_RESET);
+		val = exynos_blk_readl(exynos_pcie, PCIE_PHY_GLUE_REG0);
+		val |= PCIE_PHY_GLUE_COMMON_RESET;
+		exynos_blk_writel(exynos_pcie, val, PCIE_PHY_GLUE_REG0);
+	} else {
+		exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_GLOBAL_RESET);
+		exynos_elb_writel(exynos_pcie, 1, PCIE_PWR_RESET);
+		exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_COMMON_RESET);
+		exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_CMN_REG);
+		exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_TRSVREG_RESET);
+		exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_TRSV_RESET);
+	}
 }
 
 static void exynos_pcie_power_on_phy(struct pcie_port *pp)
@@ -269,6 +343,9 @@ static void exynos_pcie_init_phy(struct pcie_port *pp)
 {
 	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
 
+	if (of_device_is_compatible(pp->dev->of_node, "samsung,gh7-pcie"))
+		return;
+
 	/* DCC feedback control off */
 	exynos_phy_writel(exynos_pcie, 0x29, PCIE_PHY_DCC_FEEDBACK);
 
@@ -305,6 +382,26 @@ static void exynos_pcie_init_phy(struct pcie_port *pp)
 	exynos_phy_writel(exynos_pcie, 0xa0, PCIE_PHY_TRSV3_LVCC);
 }
 
+static void exynos_pcie_pulse_common_reset(struct pcie_port *pp)
+{
+	u32 val;
+	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
+
+	if (of_device_is_compatible(pp->dev->of_node, "samsung,gh7-pcie")) {
+		val = exynos_blk_readl(exynos_pcie, PCIE_PHY_GLUE_REG0);
+		val &= ~PCIE_PHY_GLUE_COMMON_RESET;
+		exynos_blk_writel(exynos_pcie, val, PCIE_PHY_GLUE_REG0);
+		udelay(500);
+		val = exynos_blk_readl(exynos_pcie, PCIE_PHY_GLUE_REG0);
+		val |= PCIE_PHY_GLUE_COMMON_RESET;
+		exynos_blk_writel(exynos_pcie, val, PCIE_PHY_GLUE_REG0);
+	} else {
+		exynos_blk_writel(exynos_pcie, 1, PCIE_PHY_COMMON_RESET);
+		udelay(500);
+		exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_COMMON_RESET);
+	}
+}
+
 static void exynos_pcie_assert_reset(struct pcie_port *pp)
 {
 	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
@@ -326,6 +423,9 @@ static int exynos_pcie_establish_link(struct pcie_port *pp)
 		return 0;
 	}
 
+	/* set phy mode */
+	exynos_pcie_set_phy_mode(pp);
+
 	/* assert reset signals */
 	exynos_pcie_assert_core_reset(pp);
 	exynos_pcie_assert_phy_reset(pp);
@@ -340,9 +440,7 @@ static int exynos_pcie_establish_link(struct pcie_port *pp)
 	exynos_pcie_init_phy(pp);
 
 	/* pulse for common reset */
-	exynos_blk_writel(exynos_pcie, 1, PCIE_PHY_COMMON_RESET);
-	udelay(500);
-	exynos_blk_writel(exynos_pcie, 0, PCIE_PHY_COMMON_RESET);
+	exynos_pcie_pulse_common_reset(pp);
 
 	/* de-assert core reset */
 	exynos_pcie_deassert_core_reset(pp);
@@ -357,6 +455,12 @@ static int exynos_pcie_establish_link(struct pcie_port *pp)
 	exynos_elb_writel(exynos_pcie, PCIE_ELBI_LTSSM_ENABLE,
 			  PCIE_APP_LTSSM_ENABLE);
 
+	if (of_device_is_compatible(pp->dev->of_node, "samsung,gh7-pcie")) {
+		/* supply auxiliary power */
+		exynos_elb_writel(exynos_pcie, PCIE_SYS_AUX_PWR_ENABLE,
+				  PCIE_SYS_AUX_PWR_DET);
+	}
+
 	/* check if the link is up or not */
 	while (!dw_pcie_link_up(pp)) {
 		mdelay(100);
@@ -564,6 +668,7 @@ static int __init exynos_pcie_probe(struct platform_device *pdev)
 	struct resource *elbi_base;
 	struct resource *phy_base;
 	struct resource *block_base;
+	 struct resource *dbi_base;
 	int ret;
 
 	exynos_pcie = devm_kzalloc(&pdev->dev, sizeof(*exynos_pcie),
@@ -619,6 +724,15 @@ static int __init exynos_pcie_probe(struct platform_device *pdev)
 		goto fail_bus_clk;
 	}
 
+	if (of_device_is_compatible(pdev->dev.of_node, "samsung,gh7-pcie")) {
+		dbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 3);
+		pp->dbi_base = devm_ioremap_resource(&pdev->dev, dbi_base);
+		if (IS_ERR(pp->dbi_base)) {
+			ret = PTR_ERR(pp->dbi_base);
+			goto fail_bus_clk;
+		}
+	}
+
 	ret = add_pcie_port(pp, pdev);
 	if (ret < 0)
 		goto fail_bus_clk;
@@ -645,6 +759,7 @@ static int __exit exynos_pcie_remove(struct platform_device *pdev)
 
 static const struct of_device_id exynos_pcie_of_match[] = {
 	{ .compatible = "samsung,exynos5440-pcie", },
+	{ .compatible = "samsung,gh7-pcie", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_pcie_of_match);
-- 
1.7.10.4


