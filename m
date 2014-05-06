Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbaEFIdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:33:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20376 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934253AbaEFIdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:33:16 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-6d-53689e4ac56a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH v2 1/6] i2c: s3c2410: Moving I2C interrupt re-configuration
 code into i2c driver
Date: Tue, 06 May 2014 17:51:17 +0900
Message-id: <1399366282-4191-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zA12veRnBBns/y1r8nXSM3WL+kXOs
	Fr0LrrJZbHp8jdViYdsSFouOv18YLS7vmsNmMeP8PiaL25d5LRZt/cJu8fbOdBaL1r1H2C3W
	z3jNYrHyxCxmBz6PluYeNo/fvyYxemxeoeWxaVUnm8fmJfUefVtWMXqcPPWExePzJrkAjigu
	m5TUnMyy1CJ9uwSujN3Hf7IWnLSo2DDtOXMD40ndLkZODgkBE4k739ewQ9hiEhfurWfrYuTi
	EBJYxiix4fYrVpii02dfMUIkpjNKfGw4A+W0MUm8XnSUBaSKTUBX4sn7ucwgtohAtsSVxvvM
	IEXMAheYJDo3L2IDSQgLJElc+3odyObgYBFQlfh/qRYkzCvgDjR0GjNIWEJAQWLOJBuQMKeA
	h8Sba2/BjhACKtlx/zbYdRICL9klfrU/B0uwCAhIfJt8iAWiV1Zi0wFmiKMlJQ6uuMEygVF4
	ASPDKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQKOrbwXjzgPUhxmSgcROZpUST84FRmFcS
	b2hsZmRhamJqbGRuaUaasJI476KHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGJfM0Hy8
	/qKM8sOm92+XhG2aa8tVNTv209eD93IkPjXI1/yfwhVeKOGr8m/N3Z9SBjnfmu9+0vt1Yh07
	g8CNYN6PCdzHVgaWXvOt/tnNIrM5uXG9q9T0wtcPotunWK2cnvXU1mZbR/XEdefcCnd88b/H
	YBL9fGPbj4v7WpWnvmqOvG+pU/X150YlluKMREMt5qLiRADeHiWVuAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoK7XvIxgg55/4hZ/Jx1jt5h/5Byr
	Re+Cq2wWmx5fY7VY2LaExaLj7xdGi8u75rBZzDi/j8ni9mVei0Vbv7BbvL0zncWide8Rdov1
	M16zWKw8MYvZgc+jpbmHzeP3r0mMHptXaHlsWtXJ5rF5Sb1H35ZVjB4nTz1h8fi8SS6AI6qB
	0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GwlhbLE
	nFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bu4z9ZC05aVGyY9py5gfGkbhcj
	J4eEgInE6bOvGCFsMYkL99azdTFycQgJTGeU+NhwhhHCaWOSeL3oKAtIFZuArsST93OZQWwR
	gWyJK433mUGKmAUuMEl0bl7EBpIQFkiSuPb1OpDNwcEioCrx/1ItSJhXwB1o6DRmkLCEgILE
	nEk2IGFOAQ+JN9fesoLYQkAlO+7fZpvAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnCMPpPawbiyweIQowAHoxIP74mV6cFCrIllxZW5hxglOJiVRHjr8zOChXhTEiurUovy44tK
	c1KLDzEmA900kVlKNDkfmD7ySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBa
	BLOFiYNTqoFRsSlEoTeI9dGJnNsm3mbTbq96zfZKVZ5xXu9b76AStgX7Ewv3nM9peH2r3/X9
	TZaDB9dz2DuolX53Cni2Rpt3B9e/dwEnV5558OYN7/w/oudDjnbbPGsMfLHQ2jzy4mET1yLn
	BV9nHl9udDlbQdHWN4SD98L/qe52h/lLm1Z279y0eEqTwwQxJZbijERDLeai4kQADyfZTxUD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's move I2C interrupt re-configuration code from machine
file exynos.c to I2C driver. Since only Exynos5250, and
Exynos5420 need to do this, added syscon based phandle to
i2c device nodes of respective SoC DT files.

CC: Rob Herring <robh+dt@kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>
CC: Wolfram Sang <wsa@the-dreams.de>
CC: Russell King <linux@arm.linux.org.uk>
CC: devicetree@vger.kernel.org
CC: linux-doc@vger.kernel.org
CC: linux-i2c@vger.kernel.org
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 .../devicetree/bindings/arm/samsung/sysreg.txt     |    1 +
 arch/arm/boot/dts/exynos5.dtsi                     |    5 ++++
 arch/arm/boot/dts/exynos5250.dtsi                  |    4 +++
 arch/arm/boot/dts/exynos5420.dtsi                  |    4 +++
 arch/arm/mach-exynos/exynos.c                      |   26 -------------------
 drivers/i2c/busses/i2c-s3c2410.c                   |   27 ++++++++++++++++++++
 6 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/sysreg.txt b/Documentation/devicetree/bindings/arm/samsung/sysreg.txt
index 0ab3251..fd71581 100644
--- a/Documentation/devicetree/bindings/arm/samsung/sysreg.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/sysreg.txt
@@ -3,6 +3,7 @@ SAMSUNG S5P/Exynos SoC series System Registers (SYSREG)
 Properties:
  - compatible : should contain "samsung,<chip name>-sysreg", "syscon";
    For Exynos4 SoC series it should be "samsung,exynos4-sysreg", "syscon";
+   For Exynos5 SoC series it should be "samsung,exynos5-sysreg", "syscon";
  - reg : offset and length of the register set.
 
 Example:
diff --git a/arch/arm/boot/dts/exynos5.dtsi b/arch/arm/boot/dts/exynos5.dtsi
index 79d0608..3027e37 100644
--- a/arch/arm/boot/dts/exynos5.dtsi
+++ b/arch/arm/boot/dts/exynos5.dtsi
@@ -99,4 +99,9 @@
 		#size-cells = <0>;
 		status = "disabled";
 	};
+
+	sys_reg: syscon@10050000 {
+		compatible = "samsung,exynos5-sysreg", "syscon";
+		reg = <0x10050000 0x400>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 8d724d5..46f0233 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -285,6 +285,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c0_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -298,6 +299,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c1_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -311,6 +313,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c2_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -324,6 +327,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c3_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index ff496ad..762128c 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -517,6 +517,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c0_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -530,6 +531,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c1_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -543,6 +545,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c2_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -556,6 +559,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c3_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 59eb1f1..54ae2e1 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -293,32 +293,6 @@ void __init exynos_map_pmu(void)
 
 static void __init exynos_dt_machine_init(void)
 {
-	struct device_node *i2c_np;
-	const char *i2c_compat = "samsung,s3c2440-i2c";
-	unsigned int tmp;
-	int id;
-
-	/*
-	 * Exynos5's legacy i2c controller and new high speed i2c
-	 * controller have muxed interrupt sources. By default the
-	 * interrupts for 4-channel HS-I2C controller are enabled.
-	 * If node for first four channels of legacy i2c controller
-	 * are available then re-configure the interrupts via the
-	 * system register.
-	 */
-	if (soc_is_exynos5()) {
-		for_each_compatible_node(i2c_np, NULL, i2c_compat) {
-			if (of_device_is_available(i2c_np)) {
-				id = of_alias_get_id(i2c_np, "i2c");
-				if (id < 4) {
-					tmp = readl(EXYNOS5_SYS_I2C_CFG);
-					writel(tmp & ~(0x1 << id),
-							EXYNOS5_SYS_I2C_CFG);
-				}
-			}
-		}
-	}
-
 	exynos_map_pmu();
 
 	if (!soc_is_exynos5440())
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index ae44910..0420150 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -39,6 +39,8 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 
 #include <asm/irq.h>
 
@@ -91,6 +93,9 @@
 /* Max time to wait for bus to become idle after a xfer (in us) */
 #define S3C2410_IDLE_TIMEOUT	5000
 
+/* Exynos5 Sysreg offset */
+#define EXYNOS5_SYS_I2C_CFG	0x0234
+
 /* i2c controller state */
 enum s3c24xx_i2c_state {
 	STATE_IDLE,
@@ -127,6 +132,7 @@ struct s3c24xx_i2c {
 #if defined(CONFIG_ARM_S3C24XX_CPUFREQ)
 	struct notifier_block	freq_transition;
 #endif
+	struct regmap		*sysreg;
 };
 
 static struct platform_device_id s3c24xx_driver_ids[] = {
@@ -1075,6 +1081,8 @@ static void
 s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
 {
 	struct s3c2410_platform_i2c *pdata = i2c->pdata;
+	unsigned int tmp;
+	int id;
 
 	if (!np)
 		return;
@@ -1084,6 +1092,25 @@ s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
 	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata->slave_addr);
 	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
 				(u32 *)&pdata->frequency);
+	/*
+	 * Exynos5's legacy i2c controller and new high speed i2c
+	 * controller have muxed interrupt sources. By default the
+	 * interrupts for 4-channel HS-I2C controller are enabled.
+	 * If node for first four channels of legacy i2c controller
+	 * are available then re-configure the interrupts via the
+	 * system register.
+	 */
+	id = of_alias_get_id(np, "i2c");
+	i2c->sysreg = syscon_regmap_lookup_by_phandle(np,
+			"samsung,syscon-phandle");
+	if (IS_ERR(i2c->sysreg)) {
+		i2c->sysreg = NULL;
+		/* As this is not compulsary do not return error */
+		pr_info("i2c-%d skipping re-configuration of interrutps\n", id);
+		return;
+	}
+	regmap_read(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, &tmp);
+	regmap_write(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, tmp & ~(0x1 << id));
 }
 #else
 static void
-- 
1.7.10.4

