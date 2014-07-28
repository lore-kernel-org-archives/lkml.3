Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaG1MTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:19:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaG1MS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:18:27 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org, Hakjoo Kim <ruppi.kim@hardkernel.com>
Cc: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [RFC 3/5] pinctrl: exynos: add exynos5410 SoC specific data
Date: Mon, 28 Jul 2014 14:18:10 +0200
Message-Id: <1406549892-5558-4-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406549892-5558-1-git-send-email-afaerber@suse.de>
References: <1406549892-5558-1-git-send-email-afaerber@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakjoo Kim <ruppi.kim@hardkernel.com>

Add Samsung EXYNOS5410 SoC specific data to enable pinctrl
support for all platforms based on EXYNOS5410.

Cc: Hakjoo Kim <ruppi.kim@hardkernel.com>
[AF: Rebased onto Exynos5260]
---
 .../bindings/pinctrl/samsung-pinctrl.txt           |   1 +
 drivers/pinctrl/pinctrl-exynos.c                   | 126 +++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c                  |   2 +
 drivers/pinctrl/pinctrl-samsung.h                  |   1 +
 4 files changed, 130 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
index 2b32783ba821..1b2ec5a1f1a8 100644
--- a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
@@ -17,6 +17,7 @@ Required Properties:
   - "samsung,exynos4x12-pinctrl": for Exynos4x12 compatible pin-controller.
   - "samsung,exynos5250-pinctrl": for Exynos5250 compatible pin-controller.
   - "samsung,exynos5260-pinctrl": for Exynos5260 compatible pin-controller.
+  - "samsung,exynos5410-pinctrl": for Exynos5410 compatible pin-controller.
   - "samsung,exynos5420-pinctrl": for Exynos5420 compatible pin-controller.
 
 - reg: Base address of the pin controller hardware module and length of
diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index 9609c23834ce..1ea15d98cea2 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -1191,6 +1191,132 @@ struct samsung_pin_ctrl exynos5260_pin_ctrl[] = {
 	},
 };
 
+/* pin banks of exynos5410 pin-controller 0 */
+static struct samsung_pin_bank exynos5410_pin_banks0[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpa2", 0x08),
+	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpb0", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpb1", 0x10),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0A0, "gpb2", 0x14),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpb3", 0x18),
+	EXYNOS_PIN_BANK_EINTG(7, 0x0E0, "gpc0", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(4, 0x100, "gpc3", 0x20),
+	EXYNOS_PIN_BANK_EINTG(7, 0x120, "gpc1", 0x24),
+	EXYNOS_PIN_BANK_EINTG(7, 0x140, "gpc2", 0x28),
+	EXYNOS_PIN_BANK_EINTN(2, 0x160, "gpm5"),
+	EXYNOS_PIN_BANK_EINTG(8, 0x180, "gpd1", 0x2c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x1A0, "gpe0", 0x30),
+	EXYNOS_PIN_BANK_EINTG(2, 0x1C0, "gpe1", 0x34),
+	EXYNOS_PIN_BANK_EINTG(6, 0x1E0, "gpf0", 0x38),
+	EXYNOS_PIN_BANK_EINTG(8, 0x200, "gpf1", 0x3c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x220, "gpg0", 0x40),
+	EXYNOS_PIN_BANK_EINTG(8, 0x240, "gpg1", 0x44),
+	EXYNOS_PIN_BANK_EINTG(2, 0x260, "gpg2", 0x48),
+	EXYNOS_PIN_BANK_EINTG(4, 0x280, "gph0", 0x4c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x2A0, "gph1", 0x50),
+	EXYNOS_PIN_BANK_EINTN(8, 0x2C0, "gpm7"),
+	EXYNOS_PIN_BANK_EINTN(6, 0x2E0, "gpy0"),
+	EXYNOS_PIN_BANK_EINTN(4, 0x300, "gpy1"),
+	EXYNOS_PIN_BANK_EINTN(6, 0x320, "gpy2"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x340, "gpy3"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x360, "gpy4"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x380, "gpy5"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x3A0, "gpy6"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x3C0, "gpy7"),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c),
+};
+
+/* pin banks of exynos5410 pin-controller 1 */
+static struct samsung_pin_bank exynos5410_pin_banks1[] = {
+	EXYNOS_PIN_BANK_EINTG(5, 0x000, "gpj0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpj1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpj2", 0x08),
+	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpj3", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(2, 0x080, "gpj4", 0x10),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0A0, "gpk0", 0x14),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0C0, "gpk1", 0x18),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0E0, "gpk2", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(7, 0x100, "gpk3", 0x20),
+};
+
+/* pin banks of exynos5410 pin-controller 2 */
+static struct samsung_pin_bank exynos5410_pin_banks2[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpv0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpv1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpv2", 0x08),
+	EXYNOS_PIN_BANK_EINTG(8, 0x080, "gpv3", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(2, 0x0C0, "gpv4", 0x10),
+};
+
+/* pin banks of exynos5410 pin-controller 3 */
+static struct samsung_pin_bank exynos5410_pin_banks3[] = {
+	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz", 0x00),
+};
+
+/*
+ * Samsung pinctrl driver data for Exynos5410 SoC. Exynos5410 SoC includes
+ * four gpio/pin-mux/pinconfig controllers.
+ */
+struct samsung_pin_ctrl exynos5410_pin_ctrl[] = {
+	{
+		/* pin-controller instance 0 data */
+		.pin_banks	= exynos5410_pin_banks0,
+		.nr_banks	= ARRAY_SIZE(exynos5410_pin_banks0),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.weint_con	= EXYNOS_WKUP_ECON_OFFSET,
+		.weint_mask	= EXYNOS_WKUP_EMASK_OFFSET,
+		.weint_pend	= EXYNOS_WKUP_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.eint_wkup_init = exynos_eint_wkup_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5410-gpio-ctrl0",
+	}, {
+		/* pin-controller instance 1 data */
+		.pin_banks	= exynos5410_pin_banks1,
+		.nr_banks	= ARRAY_SIZE(exynos5410_pin_banks1),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5410-gpio-ctrl1",
+	}, {
+		/* pin-controller instance 2 data */
+		.pin_banks	= exynos5410_pin_banks2,
+		.nr_banks	= ARRAY_SIZE(exynos5410_pin_banks2),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5410-gpio-ctrl2",
+	}, {
+		/* pin-controller instance 3 data */
+		.pin_banks	= exynos5410_pin_banks3,
+		.nr_banks	= ARRAY_SIZE(exynos5410_pin_banks3),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5410-gpio-ctrl3",
+	},
+};
+
 /* pin banks of exynos5420 pin-controller 0 */
 static struct samsung_pin_bank exynos5420_pin_banks0[] = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpy7", 0x00),
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 3e61d0f8f146..b4beabc19813 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -1124,6 +1124,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
 		.data = (void *)exynos5250_pin_ctrl },
 	{ .compatible = "samsung,exynos5260-pinctrl",
 		.data = (void *)exynos5260_pin_ctrl },
+	{ .compatible = "samsung,exynos5410-pinctrl",
+		.data = (void *)exynos5410_pin_ctrl },
 	{ .compatible = "samsung,exynos5420-pinctrl",
 		.data = (void *)exynos5420_pin_ctrl },
 	{ .compatible = "samsung,s5pv210-pinctrl",
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
index b3e41fa5798b..1eb9a2d5e558 100644
--- a/drivers/pinctrl/pinctrl-samsung.h
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -256,6 +256,7 @@ extern struct samsung_pin_ctrl exynos4210_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5260_pin_ctrl[];
+extern struct samsung_pin_ctrl exynos5410_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5420_pin_ctrl[];
 extern struct samsung_pin_ctrl s3c64xx_pin_ctrl[];
 extern struct samsung_pin_ctrl s3c2412_pin_ctrl[];
-- 
1.9.3

