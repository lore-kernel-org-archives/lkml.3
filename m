Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3H0JUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:20:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10749 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3H0JUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:20:01 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-f5-521c6f3f0779
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: linus.walleij@linaro.org
Cc: t.figa@samsung.com, thomas.abraham@linaro.org, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH 1/4] pinctrl: Add s5pv210 support to pinctrl-exynos
Date: Tue, 27 Aug 2013 11:19:31 +0200
Message-id: <1377595171-31116-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t9jQV37fJkggzMnpCx6F1xls5jyZzmT
	xabH11gtLu+aw2Yx4/w+JovTa04xW6yf8ZrF4tiMJYwOHB53ru1h89i8pN7j4Ls9TB59W1Yx
	enzeJBfAGsVlk5Kak1mWWqRvl8CV0f1PpWCeZsWm4+ENjPuVuxg5OSQETCT23LvCDmGLSVy4
	t56ti5GLQ0hgOqPEkutnmCGcdiaJswdWsYBUsQmYS0x8tgnMFhGQkbg8+w9YN7PAC0aJxzO4
	QGxhAWeJQ7vmM4HYLAKqEm8n3AWr4RXwk1h5bQ4bxDYFiZ+XT7BNYORewMiwilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4VJ5J72Bc1WBxiFGAg1GJh/dBi3SQEGtiWXFl7iFGCQ5mJRFe
	rjtAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYz1+w48
	1OoPfB9WnXZSbmVux+aD1mXrYkRPzywxnreneeL907G1Xx22pjLuYzo1zWN+37PrfQzfMpfG
	vvrQztGo5Tyn6EzV9FjeJYfl/cuLG/9Etae926O56rbkq0R3o9CPfKf1Hgf8/Ol0bNVxEzOV
	/cca7PVnMzsviInk4JzBs2VNxZsXQVVKLMUZiYZazEXFiQBMUH4ZEQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements pinctrl for s5pv210 and adds required device tree bindings.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/pinctrl/Kconfig           |  2 +-
 drivers/pinctrl/pinctrl-exynos.c  | 58 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c |  3 +-
 drivers/pinctrl/pinctrl-samsung.h |  1 +
 4 files changed, 62 insertions(+), 2 deletions(-)

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
index a74b3cb..fc3e1d7 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -660,6 +660,64 @@ static void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)
 			exynos_pinctrl_resume_bank(drvdata, bank);
 }
 
+/* pin banks of s5pv210 pin-controller */
+static struct samsung_pin_bank s5pv210_pin_banks0[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
+	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0A0, "gpd0", 0x14),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpd1", 0x18),
+	EXYNOS_PIN_BANK_EINTG(5, 0x0E0, "gpe0", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x100, "gpe1", 0x20),
+	EXYNOS_PIN_BANK_EINTG(6, 0x120, "gpf0", 0x24),
+	EXYNOS_PIN_BANK_EINTG(8, 0x140, "gpf1", 0x28),
+	EXYNOS_PIN_BANK_EINTG(8, 0x160, "gpf2", 0x2c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x180, "gpf3", 0x30),
+	EXYNOS_PIN_BANK_EINTG(7, 0x1A0, "gpg0", 0x34),
+	EXYNOS_PIN_BANK_EINTG(7, 0x1C0, "gpg1", 0x38),
+	EXYNOS_PIN_BANK_EINTG(7, 0x1E0, "gpg2", 0x3c),
+	EXYNOS_PIN_BANK_EINTG(7, 0x200, "gpg3", 0x40),
+	EXYNOS_PIN_BANK_EINTN(7, 0x220, "gpgi"),
+	EXYNOS_PIN_BANK_EINTG(8, 0x240, "gpj0", 0x44),
+	EXYNOS_PIN_BANK_EINTG(6, 0x260, "gpj1", 0x48),
+	EXYNOS_PIN_BANK_EINTG(8, 0x280, "gpj2", 0x4c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x2A0, "gpj3", 0x50),
+	EXYNOS_PIN_BANK_EINTG(5, 0x2C0, "gpj4", 0x54),
+	EXYNOS_PIN_BANK_EINTN(8, 0x2E0, "mp01"),
+	EXYNOS_PIN_BANK_EINTN(4, 0x300, "mp02"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x320, "mp03"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x340, "mp04"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x360, "mp05"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x300, "mp06"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x320, "mp07"),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gph0", 0x00),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gph1", 0x04),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gph2", 0x08),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gph3", 0x0c),
+};
+
+struct samsung_pin_ctrl s5pv210_pin_ctrl[] = {
+	{
+		/* pin-controller instance 0 data */
+		.pin_banks	= s5pv210_pin_banks0,
+		.nr_banks	= ARRAY_SIZE(s5pv210_pin_banks0),
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
index 439f2ef..f14b379 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -878,7 +878,6 @@ static struct samsung_pin_ctrl *samsung_pinctrl_get_soc_data(
 	}
 	match = of_match_node(samsung_pinctrl_dt_match, node);
 	ctrl = (struct samsung_pin_ctrl *)match->data + id;
-
 	bank = ctrl->pin_banks;
 	for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
 		spin_lock_init(&bank->slock);
@@ -1113,6 +1112,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
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

