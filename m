Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab3CFK51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:57:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27519 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab3CFK4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:56:45 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-dd-513720ec915e
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, t.figa@samsung.com,
        patches@linaro.org
Subject: [PATCH v2 1/3] pinctrl: exynos: add exynos5250 SoC specific data
Date: Wed, 06 Mar 2013 16:48:30 +0530
Message-id: <1362568712-13586-2-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
References: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoO4bBfNAg4bbSha9C66yWUz5s5zJ
	YtPja6wWl3fNYbOYcX4fk8WUw19YLNbPeM3iwO5x59oeNo/NS+o9+rasYvT4vEkugCWKyyYl
	NSezLLVI3y6BK2Paui6mgqcGFftPPGdqYPyk2cXIySEhYCJxqeExM4QtJnHh3nq2LkYuDiGB
	6YwSh05tZYZw2pgkDu95AVbFJmAg8WjhO3YQW0RAQWJz7zNWkCJmgRWMEie6voIlhAU8Jaa9
	bAVrYBFQlZi/uIcRxOYFiu9f/JURYp2SxIbeo0xdjBwcnAJeEh+vG4GEhYBKHs5/yjiBkXcB
	I8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBQeia9g3FVg8UhRgEORiUe3gkqZoFCrIll
	xZW5hxglOJiVRHi3SpsHCvGmJFZWpRblxxeV5qQWH2KU5mBREudlPPUkQEggPbEkNTs1tSC1
	CCbLxMEp1cDIX377hkiU8osvSgvbX90xDbWt3qV56xLDLj1xVffkkjZp+7+eGxeeNC7b7cy8
	2kRK5IrIgRudh/TVLP1W20vVasSoZW3L5RaOdPeOfyHEmBrlUbGtQOxb5Ky4D02xFR+sKvzy
	Fp1a8P/dvlJPtl1K1veq/4mYV13ZuX35zUt+2eIP5Ta08iixFGckGmoxFxUnAgDWBFHcIQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Samsung Exynos5250 SoC specific data to enable pinctrl support for
all platforms based on Exynos5250.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-exynos.c  |  108 +++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c |    2 +
 drivers/pinctrl/pinctrl-samsung.h |    1 +
 3 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index 538b9dd..8738933 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -677,3 +677,111 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 		.label		= "exynos4x12-gpio-ctrl3",
 	},
 };
+
+/* pin banks of exynos5250 pin-controller 0 */
+static struct samsung_pin_bank exynos5250_pin_banks0[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpa2", 0x08),
+	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpb0", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpb1", 0x10),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0A0, "gpb2", 0x14),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpb3", 0x18),
+	EXYNOS_PIN_BANK_EINTG(7, 0x0E0, "gpc0", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(4, 0x100, "gpc1", 0x20),
+	EXYNOS_PIN_BANK_EINTG(7, 0x120, "gpc2", 0x24),
+	EXYNOS_PIN_BANK_EINTG(7, 0x140, "gpc3", 0x28),
+	EXYNOS_PIN_BANK_EINTG(4, 0x160, "gpd0", 0x2c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x180, "gpd1", 0x30),
+	EXYNOS_PIN_BANK_EINTG(7, 0x2E0, "gpc4", 0x34),
+	EXYNOS_PIN_BANK_EINTN(6, 0x1A0, "gpy0"),
+	EXYNOS_PIN_BANK_EINTN(4, 0x1C0, "gpy1"),
+	EXYNOS_PIN_BANK_EINTN(6, 0x1E0, "gpy2"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x200, "gpy3"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x220, "gpy4"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x240, "gpy5"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x260, "gpy6"),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c),
+};
+
+/* pin banks of exynos5250 pin-controller 1 */
+static struct samsung_pin_bank exynos5250_pin_banks1[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpe0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(2, 0x020, "gpe1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(4, 0x040, "gpf0", 0x08),
+	EXYNOS_PIN_BANK_EINTG(4, 0x060, "gpf1", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x080, "gpg0", 0x10),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0A0, "gpg1", 0x14),
+	EXYNOS_PIN_BANK_EINTG(2, 0x0C0, "gpg2", 0x18),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0E0, "gph0", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x100, "gph1", 0x20),
+};
+
+/* pin banks of exynos5250 pin-controller 2 */
+static struct samsung_pin_bank exynos5250_pin_banks2[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpv0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpv1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpv2", 0x08),
+	EXYNOS_PIN_BANK_EINTG(8, 0x080, "gpv3", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(2, 0x0C0, "gpv4", 0x10),
+};
+
+/* pin banks of exynos5250 pin-controller 3 */
+static struct samsung_pin_bank exynos5250_pin_banks3[] = {
+	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz", 0x00),
+};
+
+/*
+ * Samsung pinctrl driver data for Exynos5250 SoC. Exynos5250 SoC includes
+ * four gpio/pin-mux/pinconfig controllers.
+ */
+struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
+	{
+		/* pin-controller instance 0 data */
+		.pin_banks	= exynos5250_pin_banks0,
+		.nr_banks	= ARRAY_SIZE(exynos5250_pin_banks0),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.weint_con	= EXYNOS_WKUP_ECON_OFFSET,
+		.weint_mask	= EXYNOS_WKUP_EMASK_OFFSET,
+		.weint_pend	= EXYNOS_WKUP_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.eint_wkup_init = exynos_eint_wkup_init,
+		.label		= "exynos5250-gpio-ctrl0",
+	}, {
+		/* pin-controller instance 1 data */
+		.pin_banks	= exynos5250_pin_banks1,
+		.nr_banks	= ARRAY_SIZE(exynos5250_pin_banks1),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.label		= "exynos5250-gpio-ctrl1",
+	}, {
+		/* pin-controller instance 2 data */
+		.pin_banks	= exynos5250_pin_banks2,
+		.nr_banks	= ARRAY_SIZE(exynos5250_pin_banks2),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.label		= "exynos5250-gpio-ctrl2",
+	}, {
+		/* pin-controller instance 3 data */
+		.pin_banks	= exynos5250_pin_banks3,
+		.nr_banks	= ARRAY_SIZE(exynos5250_pin_banks3),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.label		= "exynos5250-gpio-ctrl3",
+	},
+};
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index f206df1..3d5cf63 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -948,6 +948,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
 		.data = (void *)exynos4210_pin_ctrl },
 	{ .compatible = "samsung,exynos4x12-pinctrl",
 		.data = (void *)exynos4x12_pin_ctrl },
+	{ .compatible = "samsung,exynos5250-pinctrl",
+		.data = (void *)exynos5250_pin_ctrl },
 	{},
 };
 MODULE_DEVICE_TABLE(of, samsung_pinctrl_dt_match);
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
index e2d4e67..ee964aa 100644
--- a/drivers/pinctrl/pinctrl-samsung.h
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -237,5 +237,6 @@ struct samsung_pmx_func {
 /* list of all exported SoC specific data */
 extern struct samsung_pin_ctrl exynos4210_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
+extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
 
 #endif /* __PINCTRL_SAMSUNG_H */
-- 
1.6.6.rc2

