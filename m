Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaG2P4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:56:11 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59534 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaG2P4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:56:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: ARM: SoC fixes for 3.16-rc
Date: Tue, 29 Jul 2014 17:55:41 +0200
Message-ID: <2925915.GaRAOayjC8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JmOseg0FB8Y/k1IxV0vwGudtlTKTG2K34ddkMqCFAO4
 rLAPwgx1jtjs5C/be4+HXVtTT2F89HqrNDbWTAB5HceM1ut4hQ
 LQMW+TKK1wGWvSJIHUHXmTlJZAYHa6BiQ6X3sxykI7P3CeFbXr
 z0kYnM76pSitN66h0/zSLk7bcweUjTIHN6sq6psyHneEaA2zqZ
 HRivk8JyFApUiDju7HkkLiM+X3L6wBWkG7A0QjSC4tevGF+6U7
 osKWvbiiPbUi3S7vpQZvMi22/0pcUH8FTvTJvjWGcmsNw/XIpg
 uyXi4JpQR0G6NcHp+iuWMBqS+JkpIreivWmP+mju8rmpVu5+JA
 FHbZa0aWTpdjLLtqm2wc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to a1ae5b128365f36a3fa2143cfa9de14fc71c51d8:

  Merge tag 'omap-for-v3.16/n900-regression' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2014-07-29 13:04:27 +0200)

----------------------------------------------------------------

ARM: SoC fixes for 3.16-rc

A nice small set of bug fixes for arm-soc:

- two incorrect register addresses in DT files on shmobile and hisilicon
- one revert for a regression on omap
- one bug fix for a newly introduced pin controller binding
- one regression fix for the memory controller on omap
- one patch to avoid a harmless WARN_ON

----------------------------------------------------------------
Arnd Bergmann (3):
      Merge tag 'renesas-fixes2-for-v3.16' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'omap-for-v3.16/fixes-rc6' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'omap-for-v3.16/n900-regression' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Christoph Fritz (1):
      ARM: OMAP2+: gpmc: fix gpmc_hwecc_bch_capable()

Haojian Zhuang (1):
      ARM: dts: fix L2 address in Hi3620

Nishanth Menon (1):
      pinctrl: dra: dt-bindings: Fix pull enable/disable

Sekhar Nori (1):
      ARM: OMAP2+: l2c: squelch warning dump on power control setting

Shinobu Uehara (1):
      ARM: shmobile: r8a7791: Fix SD2CKCR register address

Tony Lindgren (1):
      ARM: dts: Revert enabling of twl configuration for n900

 arch/arm/boot/dts/hi3620.dtsi      |  2 +-
 arch/arm/boot/dts/omap3-n900.dts   |  2 +-
 arch/arm/boot/dts/r8a7791.dtsi     |  4 ++--
 arch/arm/mach-omap2/gpmc-nand.c    | 18 ++++++++++--------
 arch/arm/mach-omap2/omap4-common.c |  4 ++++
 include/dt-bindings/pinctrl/dra.h  |  7 ++++---
 6 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/hi3620.dtsi b/arch/arm/boot/dts/hi3620.dtsi
index ab1116d086be..83a5b8685bd9 100644
--- a/arch/arm/boot/dts/hi3620.dtsi
+++ b/arch/arm/boot/dts/hi3620.dtsi
@@ -73,7 +73,7 @@
 
 		L2: l2-cache {
 			compatible = "arm,pl310-cache";
-			reg = <0xfc10000 0x100000>;
+			reg = <0x100000 0x100000>;
 			interrupts = <0 15 4>;
 			cache-unified;
 			cache-level = <2>;
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 1fe45d1f75ec..b15f1a77d684 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -353,7 +353,7 @@
 	};
 
 	twl_power: power {
-		compatible = "ti,twl4030-power-n900", "ti,twl4030-power-idle-osc-off";
+		compatible = "ti,twl4030-power-n900";
 		ti,use_poweroff;
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index 8d7ffaeff6e0..79f68acfd5d4 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -540,9 +540,9 @@
 			#clock-cells = <0>;
 			clock-output-names = "sd1";
 		};
-		sd2_clk: sd3_clk@e615007c {
+		sd2_clk: sd3_clk@e615026c {
 			compatible = "renesas,r8a7791-div6-clock", "renesas,cpg-div6-clock";
-			reg = <0 0xe615007c 0 4>;
+			reg = <0 0xe615026c 0 4>;
 			clocks = <&pll1_div2_clk>;
 			#clock-cells = <0>;
 			clock-output-names = "sd2";
diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 17cd39360afe..93914d220069 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -50,6 +50,16 @@ static bool gpmc_hwecc_bch_capable(enum omap_ecc ecc_opt)
 		 soc_is_omap54xx() || soc_is_dra7xx())
 		return 1;
 
+	if (ecc_opt == OMAP_ECC_BCH4_CODE_HW_DETECTION_SW ||
+		 ecc_opt == OMAP_ECC_BCH8_CODE_HW_DETECTION_SW) {
+		if (cpu_is_omap24xx())
+			return 0;
+		else if (cpu_is_omap3630() && (GET_OMAP_REVISION() == 0))
+			return 0;
+		else
+			return 1;
+	}
+
 	/* OMAP3xxx do not have ELM engine, so cannot support ECC schemes
 	 * which require H/W based ECC error detection */
 	if ((cpu_is_omap34xx() || cpu_is_omap3630()) &&
@@ -57,14 +67,6 @@ static bool gpmc_hwecc_bch_capable(enum omap_ecc ecc_opt)
 		 (ecc_opt == OMAP_ECC_BCH8_CODE_HW)))
 		return 0;
 
-	/*
-	 * For now, assume 4-bit mode is only supported on OMAP3630 ES1.x, x>=1
-	 * and AM33xx derivates. Other chips may be added if confirmed to work.
-	 */
-	if ((ecc_opt == OMAP_ECC_BCH4_CODE_HW_DETECTION_SW) &&
-	    (!cpu_is_omap3630() || (GET_OMAP_REVISION() == 0)))
-		return 0;
-
 	/* legacy platforms support only HAM1 (1-bit Hamming) ECC scheme */
 	if (ecc_opt == OMAP_ECC_HAM1_CODE_HW)
 		return 1;
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 539e8106eb96..a0fe747634c1 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -168,6 +168,10 @@ static void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
 		smc_op = OMAP4_MON_L2X0_PREFETCH_INDEX;
 		break;
 
+	case L310_POWER_CTRL:
+		pr_info_once("OMAP L2C310: ROM does not support power control setting\n");
+		return;
+
 	default:
 		WARN_ONCE(1, "OMAP L2C310: ignoring write to reg 0x%x\n", reg);
 		return;
diff --git a/include/dt-bindings/pinctrl/dra.h b/include/dt-bindings/pinctrl/dra.h
index 002a2855c046..3d33794e4f3e 100644
--- a/include/dt-bindings/pinctrl/dra.h
+++ b/include/dt-bindings/pinctrl/dra.h
@@ -30,7 +30,8 @@
 #define MUX_MODE14	0xe
 #define MUX_MODE15	0xf
 
-#define PULL_ENA		(1 << 16)
+#define PULL_ENA		(0 << 16)
+#define PULL_DIS		(1 << 16)
 #define PULL_UP			(1 << 17)
 #define INPUT_EN		(1 << 18)
 #define SLEWCONTROL		(1 << 19)
@@ -38,10 +39,10 @@
 #define WAKEUP_EVENT		(1 << 25)
 
 /* Active pin states */
-#define PIN_OUTPUT		0
+#define PIN_OUTPUT		(0 | PULL_DIS)
 #define PIN_OUTPUT_PULLUP	(PIN_OUTPUT | PULL_ENA | PULL_UP)
 #define PIN_OUTPUT_PULLDOWN	(PIN_OUTPUT | PULL_ENA)
-#define PIN_INPUT		INPUT_EN
+#define PIN_INPUT		(INPUT_EN | PULL_DIS)
 #define PIN_INPUT_SLEW		(INPUT_EN | SLEWCONTROL)
 #define PIN_INPUT_PULLUP	(PULL_ENA | INPUT_EN | PULL_UP)
 #define PIN_INPUT_PULLDOWN	(PULL_ENA | INPUT_EN)

