Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaLHCg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 21:36:27 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:11463 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaLHCgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 21:36:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,536,1413270000"; 
   d="scan'208";a="52653935"
From: Ray Jui <rjui@broadcom.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>
CC: Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v2 4/5] ARM: dts: enable GPIO for Broadcom Cygnus
Date: Sun, 7 Dec 2014 18:38:35 -0800
Message-ID: <1418006316-324-5-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418006316-324-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1418006316-324-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables all 3 GPIO controllers including the ASIU GPIO, the
chipcommonG GPIO, and the ALWAYS-ON GPIO, for Broadcom Cygnus SoC

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 arch/arm/boot/dts/bcm-cygnus.dtsi |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
index 5126f9e..c7587c1 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -54,6 +54,36 @@
 
 	/include/ "bcm-cygnus-clock.dtsi"
 
+	gpio_ccm: gpio@1800a000 {
+		compatible = "brcm,cygnus-ccm-gpio";
+		reg = <0x1800a000 0x50>,
+			<0x0301d164 0x20>;
+		ngpios = <24>;
+		#gpio-cells = <2>;
+		gpio-controller;
+		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-controller;
+	};
+
+	gpio_asiu: gpio@180a5000 {
+		compatible = "brcm,cygnus-asiu-gpio";
+		reg = <0x180a5000 0x668>;
+		ngpios = <122>;
+		#gpio-cells = <2>;
+		gpio-controller;
+		interrupt-controller;
+		interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
+	gpio_crmu: gpio@03024800 {
+		compatible = "brcm,cygnus-crmu-gpio";
+		reg = <0x03024800 0x50>;
+		ngpios = <6>;
+		#gpio-cells = <2>;
+		gpio-controller;
+		no-interrupt;
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.9.5

