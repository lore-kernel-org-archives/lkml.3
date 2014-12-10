Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaLJACo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 19:02:44 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:54653 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaLJAC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 19:02:28 -0500
X-IronPort-AV: E=Sophos;i="5.07,548,1413270000"; 
   d="scan'208";a="52671769"
From: Ray Jui <rjui@broadcom.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH 4/4] ARM: dts: enable PCIe for Broadcom Cygnus
Date: Tue, 9 Dec 2014 16:04:31 -0800
Message-ID: <1418169871-19232-5-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418169871-19232-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1418169871-19232-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PCIe device nodes and its properties in bcm-cygnus.dtsi but keep it
disabled there. Only enable it in bcm958300k.dts because PCIe interfaces
are only populated on that board

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 arch/arm/boot/dts/bcm-cygnus.dtsi |   43 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/bcm958300k.dts  |    8 +++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
index 5126f9e..669bb3b 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -70,6 +70,49 @@
 		};
 	};
 
+	pcie0: pcie@18012000 {
+		compatible = "brcm,iproc-pcie";
+		reg = <0x18012000 0x1000>,
+			<0x18002000 0x1000>;
+		interrupts = <GIC_SPI 96 IRQ_TYPE_NONE>,
+			     <GIC_SPI 97 IRQ_TYPE_NONE>,
+			     <GIC_SPI 98 IRQ_TYPE_NONE>,
+			     <GIC_SPI 99 IRQ_TYPE_NONE>,
+			     <GIC_SPI 100 IRQ_TYPE_NONE>,
+			     <GIC_SPI 101 IRQ_TYPE_NONE>;
+		bus-range = <0x00 0xFF>;
+
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x81000000 0 0	  0x28000000 0 0x00010000
+			  0x82000000 0 0x20000000 0x20000000 0 0x04000000>;
+		phy-addr = <5>;
+		status = "disabled";
+	};
+
+	pcie1: pcie@18013000 {
+		compatible = "brcm,iproc-pcie";
+		reg = <0x18013000 0x1000>,
+			<0x18002000 0x1000>;
+
+		interrupts = <GIC_SPI 102 IRQ_TYPE_NONE>,
+			     <GIC_SPI 103 IRQ_TYPE_NONE>,
+			     <GIC_SPI 104 IRQ_TYPE_NONE>,
+			     <GIC_SPI 105 IRQ_TYPE_NONE>,
+			     <GIC_SPI 106 IRQ_TYPE_NONE>,
+			     <GIC_SPI 107 IRQ_TYPE_NONE>;
+		bus-range = <0x00 0xFF>;
+
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x81000000 0 0	  0x48000000 0 0x00010000
+			  0x82000000 0 0x40000000 0x40000000 0 0x04000000>;
+		phy-addr = <6>;
+		status = "disabled";
+	};
+
 	uart0: serial@18020000 {
 		compatible = "snps,dw-apb-uart";
 		reg = <0x18020000 0x100>;
diff --git a/arch/arm/boot/dts/bcm958300k.dts b/arch/arm/boot/dts/bcm958300k.dts
index f1bb36f..c9eb856 100644
--- a/arch/arm/boot/dts/bcm958300k.dts
+++ b/arch/arm/boot/dts/bcm958300k.dts
@@ -47,6 +47,14 @@
 		bootargs = "console=ttyS0,115200";
 	};
 
+	pcie0: pcie@18012000 {
+		status = "okay";
+	};
+
+	pcie1: pcie@18013000 {
+		status = "okay";
+	};
+
 	uart3: serial@18023000 {
 		status = "okay";
 	};
-- 
1.7.9.5

