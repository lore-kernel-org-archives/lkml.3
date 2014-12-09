Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaLINwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:52:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62169 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbaLINwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:52:10 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org, broonie@kernel.org
Cc: linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Zhang Qing <zhangqing@rock-chips.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: dt-bindings: add the description about dvs gpio for rk808
Date: Tue,  9 Dec 2014 21:51:46 +0800
Message-Id: <1418133106-5634-3-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418133106-5634-1-git-send-email-zyw@rock-chips.com>
References: <1418133106-5634-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the description about dvs1, dvs2, dvsok, and add the example.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
---

 Documentation/devicetree/bindings/mfd/rk808.txt | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
index 9e6e259..d40131b 100644
--- a/Documentation/devicetree/bindings/mfd/rk808.txt
+++ b/Documentation/devicetree/bindings/mfd/rk808.txt
@@ -24,6 +24,11 @@ Optional properties:
 - vcc10-supply: The input supply for LDO_REG6
 - vcc11-supply: The input supply for LDO_REG8
 - vcc12-supply: The input supply for SWITCH_REG2
+- dvs-gpios:  buck1/2 can be controlled by gpio dvs, this is GPIO specifiers
+  for 2 host gpio's used for dvs. The format of the gpio specifier depends in
+  the gpio controller.
+- dvsok-gpios: if we use dvs gpio to control buck1/2, this gpio will be pull
+  high, once RK808 completed the adjustment of voltage.
 
 Regulators: All the regulators of RK808 to be instantiated shall be
 listed in a child node named 'regulators'. Each regulator is represented
@@ -55,7 +60,10 @@ Example:
 		interrupt-parent = <&gpio0>;
 		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
-		pinctrl-0 = <&pmic_int>;
+		pinctrl-0 = <&pmic_int &dvs_ok &dvs_1 &dvs_2>;
+		dvsok-gpios = <&gpio7 9 GPIO_ACTIVE_HIGH>;
+		dvs-gpios = <&gpio7 11 GPIO_ACTIVE_HIGH>,
+			    <&gpio7 15 GPIO_ACTIVE_HIGH>;
 		reg = <0x1b>;
 		rockchip,system-power-controller;
 		wakeup-source;
-- 
1.9.1

