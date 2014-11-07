Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaKGNuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:50:17 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45775 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaKGNuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:50:14 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: mturquette@linaro.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Tony Xie <xxx@rock-chips.com>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 4/5] ARM: dts: add RK3288 suspend support
Date: Fri,  7 Nov 2014 21:49:36 +0800
Message-Id: <1415368177-6637-5-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415368177-6637-1-git-send-email-zyw@rock-chips.com>
References: <1415368177-6637-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add pmu sram node for suspend, add global_pwroff pinctrl.
The pmu sram is used to store the resume code.
global_pwroff is held low level at work, it would be pull to high
when entering suspend. reference this in the board DTS file since
some boards need it.

Signed-off-by: Tony Xie <xxx@rock-chips.com>
Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>

---

Changes in v7: None
Changes in v6:
- change pmu_intmem@ff720000 to sram@ff720000

Changes in v5:
- change size to 4k

Changes in v4: None
Changes in v3: None
Changes in v2:
- put "rockchip,rk3288-pmu-sram" to first

 arch/arm/boot/dts/rk3288.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index cfc4378..0747c30 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -462,6 +462,11 @@
 		status = "disabled";
 	};
 
+	sram@ff720000 {
+		compatible = "rockchip,rk3288-pmu-sram", "mmio-sram";
+		reg = <0xff720000 0x1000>;
+	};
+
 	pmu: power-management@ff730000 {
 		compatible = "rockchip,rk3288-pmu", "syscon";
 		reg = <0xff730000 0x100>;
@@ -667,6 +672,12 @@
 			bias-disable;
 		};
 
+		sleep {
+			global_pwroff: global-pwroff {
+				rockchip,pins = <0 0 RK_FUNC_1 &pcfg_pull_none>;
+			};
+		};
+
 		i2c0 {
 			i2c0_xfer: i2c0-xfer {
 				rockchip,pins = <0 15 RK_FUNC_1 &pcfg_pull_none>,
-- 
1.9.1

