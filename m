Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaJQPTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:19:53 -0400
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:48524 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbaJQPTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:19:51 -0400
X-Greylist: delayed 2319 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2014 11:19:51 EDT
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] ARM: dts: rockchip: use internal pull-up resistors on I2C busses
Date: Fri, 17 Oct 2014 16:40:30 +0200
Message-Id: <1413556830-27854-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 1.9.1
X-Ovh-Tracer-Id: 3057944148409647329
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-01-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the I2C bus specification, it is required to use pull-up resistors
on the clock and data lines. Probing the I2C busses with i2cdetect results in
bad results when no devices are connected and no external resistors are used.

This patch configures the I2C busses to use the internal pull-up resistors
on the RK3066, RK3188 and RK3288 Rockchip processors. It should also be noted
that these default pull settings match the original configuration on these SoCs.

Below is the results of using i2cdetect on a I2C bus with no devices connected
before (1) and after (2) applying this patch.

(1) root@localhost:~# i2cdetect 3

WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-3.
I will probe address range 0x03-0x77.
Continue? [Y/n]
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
10: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f
20: 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
30: -- -- -- -- -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x81, state: 2
-- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 2
-- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 2
-- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
-- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
-- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
-- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
...

(2) root@localhost:~# i2cdetect 3

WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-3.
I will probe address range 0x03-0x77.
Continue? [Y/n]
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 arch/arm/boot/dts/rk3066a.dtsi | 20 ++++++++++----------
 arch/arm/boot/dts/rk3188.dtsi  | 20 ++++++++++----------
 arch/arm/boot/dts/rk3288.dtsi  | 24 ++++++++++++------------
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
index ad9c2db..c5cdf55 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -202,36 +202,36 @@
 
 		i2c0 {
 			i2c0_xfer: i2c0-xfer {
-				rockchip,pins = <RK_GPIO2 28 RK_FUNC_1 &pcfg_pull_none>,
-						<RK_GPIO2 29 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO2 28 RK_FUNC_1 &pcfg_pull_up>,
+						<RK_GPIO2 29 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c1 {
 			i2c1_xfer: i2c1-xfer {
-				rockchip,pins = <RK_GPIO2 30 RK_FUNC_1 &pcfg_pull_none>,
-						<RK_GPIO2 31 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO2 30 RK_FUNC_1 &pcfg_pull_up>,
+						<RK_GPIO2 31 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c2 {
 			i2c2_xfer: i2c2-xfer {
-				rockchip,pins = <RK_GPIO3 0 RK_FUNC_1 &pcfg_pull_none>,
-						<RK_GPIO3 1 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO3 0 RK_FUNC_1 &pcfg_pull_up>,
+						<RK_GPIO3 1 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c3 {
 			i2c3_xfer: i2c3-xfer {
-				rockchip,pins = <RK_GPIO3 2 RK_FUNC_2 &pcfg_pull_none>,
-						<RK_GPIO3 3 RK_FUNC_2 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO3 2 RK_FUNC_2 &pcfg_pull_up>,
+						<RK_GPIO3 3 RK_FUNC_2 &pcfg_pull_up>;
 			};
 		};
 
 		i2c4 {
 			i2c4_xfer: i2c4-xfer {
-				rockchip,pins = <RK_GPIO3 4 RK_FUNC_1 &pcfg_pull_none>,
-						<RK_GPIO3 5 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO3 4 RK_FUNC_1 &pcfg_pull_up>,
+						<RK_GPIO3 5 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index ddaada7..ee2865f 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -188,36 +188,36 @@
 
 		i2c0 {
 			i2c0_xfer: i2c0-xfer {
-				rockchip,pins = <RK_GPIO1 24 RK_FUNC_1 &pcfg_pull_none>,
-						<RK_GPIO1 25 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO1 24 RK_FUNC_1 &pcfg_pull_up>,
+						<RK_GPIO1 25 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c1 {
 			i2c1_xfer: i2c1-xfer {
-				rockchip,pins = <RK_GPIO1 26 RK_FUNC_1 &pcfg_pull_none>,
-						<RK_GPIO1 27 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO1 26 RK_FUNC_1 &pcfg_pull_up>,
+						<RK_GPIO1 27 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c2 {
 			i2c2_xfer: i2c2-xfer {
-				rockchip,pins = <RK_GPIO1 28 RK_FUNC_1 &pcfg_pull_none>,
-						<RK_GPIO1 29 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO1 28 RK_FUNC_1 &pcfg_pull_up>,
+						<RK_GPIO1 29 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c3 {
 			i2c3_xfer: i2c3-xfer {
-				rockchip,pins = <RK_GPIO3 14 RK_FUNC_2 &pcfg_pull_none>,
-						<RK_GPIO3 15 RK_FUNC_2 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO3 14 RK_FUNC_2 &pcfg_pull_up>,
+						<RK_GPIO3 15 RK_FUNC_2 &pcfg_pull_up>;
 			};
 		};
 
 		i2c4 {
 			i2c4_xfer: i2c4-xfer {
-				rockchip,pins = <RK_GPIO1 30 RK_FUNC_1 &pcfg_pull_none>,
-						<RK_GPIO1 31 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <RK_GPIO1 30 RK_FUNC_1 &pcfg_pull_up>,
+						<RK_GPIO1 31 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 874e66d..9a4b1f7 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -636,43 +636,43 @@
 
 		i2c0 {
 			i2c0_xfer: i2c0-xfer {
-				rockchip,pins = <0 15 RK_FUNC_1 &pcfg_pull_none>,
-						<0 16 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <0 15 RK_FUNC_1 &pcfg_pull_up>,
+						<0 16 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c1 {
 			i2c1_xfer: i2c1-xfer {
-				rockchip,pins = <8 4 RK_FUNC_1 &pcfg_pull_none>,
-						<8 5 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <8 4 RK_FUNC_1 &pcfg_pull_up>,
+						<8 5 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c2 {
 			i2c2_xfer: i2c2-xfer {
-				rockchip,pins = <6 9 RK_FUNC_1 &pcfg_pull_none>,
-						<6 10 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <6 9 RK_FUNC_1 &pcfg_pull_up>,
+						<6 10 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c3 {
 			i2c3_xfer: i2c3-xfer {
-				rockchip,pins = <2 16 RK_FUNC_1 &pcfg_pull_none>,
-						<2 17 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <2 16 RK_FUNC_1 &pcfg_pull_up>,
+						<2 17 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c4 {
 			i2c4_xfer: i2c4-xfer {
-				rockchip,pins = <7 17 RK_FUNC_1 &pcfg_pull_none>,
-						<7 18 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <7 17 RK_FUNC_1 &pcfg_pull_up>,
+						<7 18 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
 		i2c5 {
 			i2c5_xfer: i2c5-xfer {
-				rockchip,pins = <7 19 RK_FUNC_1 &pcfg_pull_none>,
-						<7 20 RK_FUNC_1 &pcfg_pull_none>;
+				rockchip,pins = <7 19 RK_FUNC_1 &pcfg_pull_up>,
+						<7 20 RK_FUNC_1 &pcfg_pull_up>;
 			};
 		};
 
-- 
1.9.1

