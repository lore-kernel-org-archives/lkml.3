Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3H0NIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:08:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17385 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3H0NI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:08:26 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-e3-521ca4c8cfdb
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: linus.walleij@linaro.org
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        t.figa@samsung.com, thomas.abraham@linaro.org, kgene.kim@samsung.com,
        l.krishna@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [Patch v2] pinctrl: Add s5pv210 support to pinctrl-exynos
Date: Tue, 27 Aug 2013 15:08:10 +0200
Message-id: <1377608890-8528-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t9jQd0TS2SCDN5NlbWYf+Qcq8Wb3g4W
	i94FV9ksdm65wWYx5c9yJotNj6+xWixsW8JicXnXHDaLGef3MVmcXnOK2WLp9YtMFhOmr2Wx
	OLziAJPFupfTWSxeHWxjsVg/4zWLxbEZSxgdBD3WzFvD6LHg8xV2j9eTJzB6vFo9k9XjzrU9
	bB6bl9R7HHy3h8mjb8sqRo/Pm+Q8Ns4NDeCK4rJJSc3JLEst0rdL4Mo4/e0Qa8F/o4qbmyay
	NTCu1+5i5OSQEDCRaLhwhhXCFpO4cG89WxcjF4eQwHRGiUPT3jNCOO1MEj+uvWEEqWITMJeY
	+GwTC4gtIiAjcXn2H3aQImaBA8wSnce+gBUJCzhJfFm/gA3EZhFQlVh65gNYA6+Ar8TdhQfZ
	IdYpSPy8fIJtAiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBoftMegfjqgaLQ4wC
	HIxKPLwPWqSDhFgTy4orcw8xSnAwK4nwTm2WCRLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DV
	OlBIID2xJDU7NbUgtQgmy8TBKdXAaNEm9L5q/kOnIyvvmYirPZm77Nya/OUsWklMOdZ9Oj+m
	5BW8qX6s17rhyjK3eUpmDM5Xvb/IH00vOfisu3LWosbEs5H2andXaOUUZK2MaNzrHjT5i93P
	H6q8QsrlPPMVWP3/GAU6ROX9XtlwSkgrVEZgv0BFWaLnwc3FO1c+40rNEjOVvdShxFKckWio
	xVxUnAgAcToLxFkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements pinctrl support and adds device tree bindings
for s5pv210.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 .../bindings/pinctrl/samsung-pinctrl.txt           |  3 +-
 drivers/pinctrl/Kconfig                            |  2 +-
 drivers/pinctrl/pinctrl-exynos.c                   | 58 ++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c                  |  2 +
 drivers/pinctrl/pinctrl-samsung.h                  |  1 +
 5 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
index 36281e7..257677d 100644
--- a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
@@ -12,6 +12,7 @@ Required Properties:
   - "samsung,s3c2440-pinctrl": for S3C2440-compatible pin-controller,
   - "samsung,s3c2450-pinctrl": for S3C2450-compatible pin-controller,
   - "samsung,s3c64xx-pinctrl": for S3C64xx-compatible pin-controller,
+  - "samsung,s5pv210-pinctrl": for S5PV210-compatible pin-controller,
   - "samsung,exynos4210-pinctrl": for Exynos4210 compatible pin-controller.
   - "samsung,exynos4x12-pinctrl": for Exynos4x12 compatible pin-controller.
   - "samsung,exynos5250-pinctrl": for Exynos5250 compatible pin-controller.
@@ -128,7 +129,7 @@ B. External Wakeup Interrupts: For supporting external wakeup interrupts, a
      - samsung,s3c64xx-wakeup-eint: represents wakeup interrupt controller
        found on Samsung S3C64xx SoCs,
      - samsung,exynos4210-wakeup-eint: represents wakeup interrupt controller
-       found on Samsung Exynos4210 SoC.
+       found on Samsung Exynos4210 and S5PC110/S5PV210 SoCs.
    - interrupt-parent: phandle of the interrupt parent to which the external
      wakeup interrupts are forwarded to.
    - interrupts: interrupt used by multiplexed wakeup interrupts.
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index bdb1a87..ffe4b49 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -252,7 +252,7 @@ config PINCTRL_SAMSUNG
 
 config PINCTRL_EXYNOS
 	bool "Pinctrl driver data for Samsung EXYNOS SoCs other than 5440"
-	depends on OF && GPIOLIB && ARCH_EXYNOS
+	depends on OF && GPIOLIB && (ARCH_EXYNOS || ARCH_S5PV210)
 	select PINCTRL_SAMSUNG
 
 config PINCTRL_EXYNOS5440
diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index a74b3cb..2689f8d 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -660,6 +660,64 @@ static void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)
 			exynos_pinctrl_resume_bank(drvdata, bank);
 }
 
+/* pin banks of s5pv210 pin-controller */
+static struct samsung_pin_bank s5pv210_pin_bank[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
+	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0a0, "gpd0", 0x14),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0c0, "gpd1", 0x18),
+	EXYNOS_PIN_BANK_EINTG(5, 0x0e0, "gpe0", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x100, "gpe1", 0x20),
+	EXYNOS_PIN_BANK_EINTG(6, 0x120, "gpf0", 0x24),
+	EXYNOS_PIN_BANK_EINTG(8, 0x140, "gpf1", 0x28),
+	EXYNOS_PIN_BANK_EINTG(8, 0x160, "gpf2", 0x2c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x180, "gpf3", 0x30),
+	EXYNOS_PIN_BANK_EINTG(7, 0x1a0, "gpg0", 0x34),
+	EXYNOS_PIN_BANK_EINTG(7, 0x1c0, "gpg1", 0x38),
+	EXYNOS_PIN_BANK_EINTG(7, 0x1e0, "gpg2", 0x3c),
+	EXYNOS_PIN_BANK_EINTG(7, 0x200, "gpg3", 0x40),
+	EXYNOS_PIN_BANK_EINTN(7, 0x220, "gpi"),
+	EXYNOS_PIN_BANK_EINTG(8, 0x240, "gpj0", 0x44),
+	EXYNOS_PIN_BANK_EINTG(6, 0x260, "gpj1", 0x48),
+	EXYNOS_PIN_BANK_EINTG(8, 0x280, "gpj2", 0x4c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x2a0, "gpj3", 0x50),
+	EXYNOS_PIN_BANK_EINTG(5, 0x2c0, "gpj4", 0x54),
+	EXYNOS_PIN_BANK_EINTN(8, 0x2e0, "mp01"),
+	EXYNOS_PIN_BANK_EINTN(4, 0x300, "mp02"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x320, "mp03"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x340, "mp04"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x360, "mp05"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x380, "mp06"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x3a0, "mp07"),
+	EXYNOS_PIN_BANK_EINTW(8, 0xc00, "gph0", 0x00),
+	EXYNOS_PIN_BANK_EINTW(8, 0xc20, "gph1", 0x04),
+	EXYNOS_PIN_BANK_EINTW(8, 0xc40, "gph2", 0x08),
+	EXYNOS_PIN_BANK_EINTW(8, 0xc60, "gph3", 0x0c),
+};
+
+struct samsung_pin_ctrl s5pv210_pin_ctrl[] = {
+	{
+		/* pin-controller instance 0 data */
+		.pin_banks	= s5pv210_pin_bank,
+		.nr_banks	= ARRAY_SIZE(s5pv210_pin_bank),
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
+		.label		= "s5pv210-gpio-ctrl0",
+	},
+};
+
 /* pin banks of exynos4210 pin-controller 0 */
 static struct samsung_pin_bank exynos4210_pin_banks0[] = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 439f2ef..65551a8 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -1113,6 +1113,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
 		.data = (void *)exynos5250_pin_ctrl },
 	{ .compatible = "samsung,exynos5420-pinctrl",
 		.data = (void *)exynos5420_pin_ctrl },
+	{ .compatible = "samsung,s5pv210-pinctrl",
+		.data = (void *)s5pv210_pin_ctrl },
 #endif
 #ifdef CONFIG_PINCTRL_S3C64XX
 	{ .compatible = "samsung,s3c64xx-pinctrl",
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
index 11bb75b..30622d9 100644
--- a/drivers/pinctrl/pinctrl-samsung.h
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -260,5 +260,6 @@ extern struct samsung_pin_ctrl s3c2412_pin_ctrl[];
 extern struct samsung_pin_ctrl s3c2416_pin_ctrl[];
 extern struct samsung_pin_ctrl s3c2440_pin_ctrl[];
 extern struct samsung_pin_ctrl s3c2450_pin_ctrl[];
+extern struct samsung_pin_ctrl s5pv210_pin_ctrl[];
 
 #endif /* __PINCTRL_SAMSUNG_H */
-- 
1.8.1.2

