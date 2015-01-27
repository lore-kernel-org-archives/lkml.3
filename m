Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbbA0T5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:57:12 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35160 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbbA0Ty1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:54:27 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v3 07/10] ARM: dts: sunxi: Add usb3_vbus regulator to common regulators dtsi
Date: Wed, 28 Jan 2015 03:54:12 +0800
Message-Id: <1422388455-25923-8-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422388455-25923-1-git-send-email-wens@csie.org>
References: <1422388455-25923-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SoCs have a total of 4 possible USB controllers. One such example
is the A80, which has one USB3 dual role device and 3 EHCI/OHCI pairs.

Add a common VBUS regulator for the last host controller.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sunxi-common-regulators.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sunxi-common-regulators.dtsi b/arch/arm/boot/dts/sunxi-common-regulators.dtsi
index e02baa66b33c..97fe8d73c4f7 100644
--- a/arch/arm/boot/dts/sunxi-common-regulators.dtsi
+++ b/arch/arm/boot/dts/sunxi-common-regulators.dtsi
@@ -130,6 +130,16 @@
 		status = "disabled";
 	};
 
+	reg_usb3_vbus: usb3-vbus {
+		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		regulator-name = "usb3-vbus";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		enable-active-high;
+		status = "disabled";
+	};
+
 	reg_vcc3v0: vcc3v0 {
 		compatible = "regulator-fixed";
 		regulator-name = "vcc3v0";
-- 
2.1.4

