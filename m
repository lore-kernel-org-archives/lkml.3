Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbaLKDRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:17:05 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35264 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbaLKDRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:17:01 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org, broonie@kernel.org
Cc: linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Zhang Qing <zhangqing@rock-chips.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mfd: dt-bindings: add the description about dvs gpio for rk808
Date: Thu, 11 Dec 2014 11:16:41 +0800
Message-Id: <1418267802-13159-2-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418267802-13159-1-git-send-email-zyw@rock-chips.com>
References: <1418267802-13159-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the description about dvs1, dvs2, dvsok, and add the example.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v2:
- increase description about dvs pins

 Documentation/devicetree/bindings/mfd/rk808.txt | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
index 9e6e259..923cdca 100644
--- a/Documentation/devicetree/bindings/mfd/rk808.txt
+++ b/Documentation/devicetree/bindings/mfd/rk808.txt
@@ -24,6 +24,14 @@ Optional properties:
 - vcc10-supply: The input supply for LDO_REG6
 - vcc11-supply: The input supply for LDO_REG8
 - vcc12-supply: The input supply for SWITCH_REG2
+- dvs-gpios:  buck1/2 can be controlled by gpio dvs, this is GPIO specifiers
+  for 2 host gpio's used for dvs. The format of the gpio specifier depends in
+  the gpio controller. If DVS GPIOs aren't present, voltage changes will happen
+  without being very quickly with no slow ramp time.
+- dvsok-gpios: if we use dvs gpio to control buck1/2, this gpio will be pull
+  high, once RK808 completed the adjustment of voltage. If the DVSOK isn't
+  present, we'll just delay based on whatever is specified in the regulator
+  constraints.
 
 Regulators: All the regulators of RK808 to be instantiated shall be
 listed in a child node named 'regulators'. Each regulator is represented
@@ -55,7 +63,10 @@ Example:
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

