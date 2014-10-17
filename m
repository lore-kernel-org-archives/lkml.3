Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaJQUsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:48:10 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:52615 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaJQUsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:48:08 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <e19e403de8123ab7e7803a1905a6a2e4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: zyw@rock-chips.com
To: Heiko Stuebner <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, dianders@chromium.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Chris Zhong <zyw@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, Tony Xie <xxx@rock-chips.com>
Subject: [PATCH v2 4/4] ARM: dts: add RK3288 suspend support
Date: Fri, 17 Oct 2014 13:47:53 -0700
Message-Id: <1413578873-26293-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413578696-26125-1-git-send-email-zyw@rock-chips.com>
References: <1413578696-26125-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Zhong <zyw@rock-chips.com>

add pmu_intmem node for suspend, add global_pwroff pinctrl.
The pmu_intmem is used to store the resume code.
global_pwroff is held low level at work, it would be pull to high
when entering suspend. PMICs can get this singal, then shut down
some power rails. So please reference the global_pwroff pinctrl
as part of the PMIC config.

Signed-off-by: Tony Xie <xxx@rock-chips.com>
Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v2:
- put "rockchip,rk3288-pmu-sram" to first

 arch/arm/boot/dts/rk3288.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 5950b0a..fcbe929 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -241,6 +241,11 @@
 		status = "disabled";
 	};
 
+	pmu_intmem@ff720000 {
+		compatible = "rockchip,rk3288-pmu-sram", "mmio-sram";
+		reg = <0xff720000 0x4000>;
+	};
+
 	pmu: power-management@ff730000 {
 		compatible = "rockchip,rk3288-pmu", "syscon";
 		reg = <0xff730000 0x100>;
@@ -421,6 +426,12 @@
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
1.7.9.5

