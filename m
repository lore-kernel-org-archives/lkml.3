Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaK0Hk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:40:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41760 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaK0HfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:24 -0500
X-AuditID: cbfee691-f79b86d000004a5a-f0-5476d4366259
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/19] pinctrl: exynos: Add support for Exynos5433
Date: Thu, 27 Nov 2014 16:34:58 +0900
Message-id: <1417073716-22997-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkUNfsSlmIwYqfuhaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbeY8mc5k8Wm
	x9dYLS7vmsNmMeP8PiaLpdcvMlmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6MpydnsRVsd6m49N+mgXGtVRcjJ4eEgInEltfrWCFsMYkL99azgdhCAksZJS688oap+XNw
	L1ANF1B8OqPE1ycPGSGcJiaJWysfsINUsQloSex/cQOsW0TAWaJhaiMTSBGzwEdmiYZpF8FW
	CAs4Saw8swCsiEVAVeLOzvNMIDavgKvElwPf2SDWKUgsWz4TrJ5TwE1i/9eDrBAnuUos+nYF
	bKiEwFwOifXT/jJBDBKQ+Db5EEsXIwdQQlZi0wFmiDmSEgdX3GCZwCi8gJFhFaNoakFyQXFS
	epGpXnFibnFpXrpecn7uJkZgXJ7+92ziDsb7B6wPMQpwMCrx8FocKAsRYk0sK67MPcRoCrRh
	IrOUaHI+MPrzSuINjc2MLExNTI2NzC3NlMR5daR/BgsJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgjPz/6sfHn/4fNOa/0t+9tUv6OPOaQ/8sYq7923817Z5WDHf0hIoDJ260rDpWarj7ohv7
	5UkX43IffnR9bVz657fdmQX5T36/sJS36MiYcd6aIcTArMRM3mDN5bNZ20tadskXCS8Jaz13
	4aFygZIpNzuPdArX/wBftqsz7XNMU5KOv867bhX5QomlOCPRUIu5qDgRAPzfbdXGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t9jQV2zK2UhBr1zlSwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w24x5c9yJotN
	j6+xWlzeNYfNYsb5fUwWS69fZLI4df0zm8XhN+2sFjMmv2SzODZjCaPFql1/GC1efjzB4iDm
	sWbeGkaP378mMXrsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx+dNcgEcUQ2MNhmpiSmpRQqp
	ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA/ykplCXmlAKFAhKLi5X0
	7TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM56enMVWsN2l4tJ/mwbGtVZdjJwcEgImEn8O7mWF
	sMUkLtxbz9bFyMUhJDCdUeLrk4eMEE4Tk8StlQ/YQarYBLQk9r+4wQZiiwg4SzRMbWQCKWIW
	+Mgs0TDtItgoYQEniZVnFoAVsQioStzZeZ4JxOYVcJX4cuA7G8Q6BYlly2eC1XMKuEns/3oQ
	zBYCqln07QrTBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4/6Z9A7GVQ0WhxgF
	OBiVeHgtDpSFCLEmlhVX5h5ilOBgVhLhlVoEFOJNSaysSi3Kjy8qzUktPsRoCnTVRGYp0eR8
	YErKK4k3NDYxM7I0Mje0MDI2VxLnvXEzN0RIID2xJDU7NbUgtQimj4mDU6qBcbF/vtKOvqWp
	Wx4oL/zruUHyr7VKpcaCtrvacz823H/94n4YyymzvGhG431botiueM4LOhb4dsEjgd/z9/Fw
	sO9Krbc/tdDEcXaW0QPuWIMpff9PntdOe6SRe9bq7Nnyt0U259+fWv103+nroae+n/z5Pil7
	R03oe+7rVfkBRq/jv3NZis56GKfEUpyRaKjFXFScCAAPTA+lEQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds driver data for Exynos5433 SoC. Exynos5433 includes 228 multi-
functional input/output port pins and 135 memory port pins. There are 41 general
port groups and 2 memory port groups.

Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c  | 163 ++++++++++++++++++++++++++++++
 drivers/pinctrl/samsung/pinctrl-samsung.c |   2 +
 drivers/pinctrl/samsung/pinctrl-samsung.h |   1 +
 3 files changed, 166 insertions(+)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index 8e3e0c0..bd4c4ec 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -1268,6 +1268,169 @@ struct samsung_pin_ctrl exynos5420_pin_ctrl[] = {
 	},
 };
 
+/* pin banks of exynos5433 pin-controller - ALIVE */
+static struct samsung_pin_bank exynos5433_pin_banks0[] = {
+	EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
+	EXYNOS_PIN_BANK_EINTW(8, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTW(8, 0x040, "gpa2", 0x08),
+	EXYNOS_PIN_BANK_EINTW(8, 0x060, "gpa3", 0x0c),
+};
+
+/* pin banks of exynos5433 pin-controller - AUD */
+static struct samsung_pin_bank exynos5433_pin_banks1[] = {
+	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpz1", 0x04),
+};
+
+/* pin banks of exynos5433 pin-controller - CPIF */
+static struct samsung_pin_bank exynos5433_pin_banks2[] = {
+	EXYNOS_PIN_BANK_EINTG(2, 0x000, "gpv6", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - eSE */
+static struct samsung_pin_bank exynos5433_pin_banks3[] = {
+	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj2", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - FINGER */
+static struct samsung_pin_bank exynos5433_pin_banks4[] = {
+	EXYNOS_PIN_BANK_EINTG(4, 0x000, "gpd5", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - FSYS */
+static struct samsung_pin_bank exynos5433_pin_banks5[] = {
+	EXYNOS_PIN_BANK_EINTG(6, 0x000, "gph1", 0x00),
+	EXYNOS_PIN_BANK_EINTG(7, 0x020, "gpr4", 0x04),
+	EXYNOS_PIN_BANK_EINTG(5, 0x040, "gpr0", 0x08),
+	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr1", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(2, 0x080, "gpr2", 0x10),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpr3", 0x14),
+};
+
+/* pin banks of exynos5433 pin-controller - IMEM */
+static struct samsung_pin_bank exynos5433_pin_banks6[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpf0", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - NFC */
+static struct samsung_pin_bank exynos5433_pin_banks7[] = {
+	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj0", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - PERIC */
+static struct samsung_pin_bank exynos5433_pin_banks8[] = {
+	EXYNOS_PIN_BANK_EINTG(6, 0x000, "gpv7", 0x00),
+	EXYNOS_PIN_BANK_EINTG(5, 0x020, "gpb0", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpc0", 0x08),
+	EXYNOS_PIN_BANK_EINTG(2, 0x060, "gpc1", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(6, 0x080, "gpc2", 0x10),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpc3", 0x14),
+	EXYNOS_PIN_BANK_EINTG(2, 0x0c0, "gpg0", 0x18),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0e0, "gpd0", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(6, 0x100, "gpd1", 0x20),
+	EXYNOS_PIN_BANK_EINTG(8, 0x120, "gpd2", 0x24),
+	EXYNOS_PIN_BANK_EINTG(5, 0x140, "gpd4", 0x28),
+	EXYNOS_PIN_BANK_EINTG(2, 0x160, "gpd8", 0x2c),
+	EXYNOS_PIN_BANK_EINTG(7, 0x180, "gpd6", 0x30),
+	EXYNOS_PIN_BANK_EINTG(3, 0x1a0, "gpd7", 0x34),
+	EXYNOS_PIN_BANK_EINTG(5, 0x1c0, "gpg1", 0x38),
+	EXYNOS_PIN_BANK_EINTG(2, 0x1e0, "gpg2", 0x3c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x200, "gpg3", 0x40),
+};
+
+/* pin banks of exynos5433 pin-controller - TOUCH */
+static struct samsung_pin_bank exynos5433_pin_banks9[] = {
+	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj1", 0x00),
+};
+
+/*
+ * Samsung pinctrl driver data for Exynos5433 SoC. Exynos5433 SoC includes
+ * four gpio/pin-mux/pinconfig controllers.
+ */
+struct samsung_pin_ctrl exynos5433_pin_ctrl[] = {
+	{
+		/* pin-controller instance 0 data */
+		.pin_banks	= exynos5433_pin_banks0,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks0),
+		.eint_wkup_init = exynos_eint_wkup_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl0",
+	}, {
+		/* pin-controller instance 1 data */
+		.pin_banks	= exynos5433_pin_banks1,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks1),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl1",
+	}, {
+		/* pin-controller instance 2 data */
+		.pin_banks	= exynos5433_pin_banks2,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks2),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl2",
+	}, {
+		/* pin-controller instance 3 data */
+		.pin_banks	= exynos5433_pin_banks3,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks3),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl3",
+	}, {
+		/* pin-controller instance 4 data */
+		.pin_banks	= exynos5433_pin_banks4,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks4),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl4",
+	}, {
+		/* pin-controller instance 5 data */
+		.pin_banks	= exynos5433_pin_banks5,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks5),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl5",
+	}, {
+		/* pin-controller instance 6 data */
+		.pin_banks	= exynos5433_pin_banks6,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks6),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl6",
+	}, {
+		/* pin-controller instance 7 data */
+		.pin_banks	= exynos5433_pin_banks7,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks7),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl7",
+	}, {
+		/* pin-controller instance 8 data */
+		.pin_banks	= exynos5433_pin_banks8,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks8),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl8",
+	}, {
+		/* pin-controller instance 9 data */
+		.pin_banks	= exynos5433_pin_banks9,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks9),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl9",
+	},
+};
+
 /* pin banks of exynos7 pin-controller - ALIVE */
 static struct samsung_pin_bank exynos7_pin_banks0[] = {
 	EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index e0ba851..4eb61ea 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -1226,6 +1226,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
 		.data = (void *)exynos5260_pin_ctrl },
 	{ .compatible = "samsung,exynos5420-pinctrl",
 		.data = (void *)exynos5420_pin_ctrl },
+	{ .compatible = "samsung,exynos5433-pinctrl",
+		.data = (void *)exynos5433_pin_ctrl },
 	{ .compatible = "samsung,s5pv210-pinctrl",
 		.data = (void *)s5pv210_pin_ctrl },
 	{ .compatible = "samsung,exynos7-pinctrl",
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index e737d1f..d260356 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -245,6 +245,7 @@ extern struct samsung_pin_ctrl exynos4415_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5260_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5420_pin_ctrl[];
+extern struct samsung_pin_ctrl exynos5433_pin_ctrl[];
 extern const struct samsung_pin_ctrl exynos7_pin_ctrl[];
 extern struct samsung_pin_ctrl s3c64xx_pin_ctrl[];
 extern struct samsung_pin_ctrl s3c2412_pin_ctrl[];
-- 
1.8.5.5

