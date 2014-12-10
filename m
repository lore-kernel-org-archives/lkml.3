Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaLJDz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:55:28 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:64900 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaLJDy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:54:58 -0500
X-IronPort-AV: E=Sophos;i="5.07,549,1413270000"; 
   d="scan'208";a="52847357"
From: Ray Jui <rjui@broadcom.com>
To: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v3 3/3] ARM: dts: add I2C device nodes for Broadcom Cygnus
Date: Tue, 9 Dec 2014 19:57:12 -0800
Message-ID: <1418183832-24793-4-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418183832-24793-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1418183832-24793-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C device nodes and its properties in bcm-cygnus.dtsi but keep
them disabled there. Individual I2C devices can be enabled in board
specific dts file when I2C slave devices are enabled in the future

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 arch/arm/boot/dts/bcm-cygnus.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
index 5126f9e..f7d6c1d 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -70,6 +70,26 @@
 		};
 	};
 
+	i2c0: i2c@18008000 {
+		compatible = "brcm,iproc-i2c";
+		reg = <0x18008000 0x100>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <GIC_SPI 85 IRQ_TYPE_NONE>;
+		clock-frequency = <100000>;
+		status = "disabled";
+	};
+
+	i2c1: i2c@1800b000 {
+		compatible = "brcm,iproc-i2c";
+		reg = <0x1800b000 0x100>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <GIC_SPI 86 IRQ_TYPE_NONE>;
+		clock-frequency = <100000>;
+		status = "disabled";
+	};
+
 	uart0: serial@18020000 {
 		compatible = "snps,dw-apb-uart";
 		reg = <0x18020000 0x100>;
-- 
1.7.9.5

