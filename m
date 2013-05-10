Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3EJPsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:48:22 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2479 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab3EJPsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:48:20 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Christian Daudt" <csd@broadcom.com>
To: "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Rob Landley" <rob@landley.net>,
        "Russell King" <linux@arm.linux.org.uk>, "Chris Ball" <cjb@laptop.org>,
        "Stephen Warren" <swarren@nvidia.com>,
        "Olof Johansson" <olof@lixom.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Wei WANG" <wei_wang@realsil.com.cn>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        "Arnd Bergmann" <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org
cc: csd_b@daudt.org, "Christian Daudt" <csd@broadcom.com>
Subject: [PATCH V2 2/2] ARM: mmc: bcm281xx SDHCI driver (dt mods)
Date: Fri, 10 May 2013 08:48:03 -0700
Message-ID: <1368200883-15668-2-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368200883-15668-1-git-send-email-csd@broadcom.com>
References: <1368200883-15668-1-git-send-email-csd@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7D93CB352L814096903-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SDHCI driver for the Broadcom 281xx SoCs. Also
add bindings for it into bcm281xx dts files.

Changes from V1:
 - split original patch into 2, one for driver and this one for dt

Signed-off-by: Christian Daudt <csd@broadcom.com>

diff --git a/Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt b/Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt
new file mode 100644
index 0000000..ad1c4bd
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt
@@ -0,0 +1,16 @@
+Broadcom BCM281xx SDHCI driver
+
+This file documents differences between the core properties in mmc.txt
+and the properties in the bcm281xx driver.
+
+Required properties:
+- compatible : Should be "bcm,kona-sdhci"
+
+Example:
+
+sdio2: sdio@0x3f1a0000 {
+	compatible = "bcm,kona-sdhci";
+	reg = <0x3f1a0000 0x10000>;
+	interrupts = <0x0 74 0x4>;
+};
+
diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
index 248067c..9ae3404 100644
--- a/arch/arm/boot/dts/bcm11351-brt.dts
+++ b/arch/arm/boot/dts/bcm11351-brt.dts
@@ -27,4 +27,21 @@
 		status = "okay";
 	};
 
+	sdio0: sdio@0x3f180000 {
+		max-frequency = <48000000>;
+		status = "okay";
+	};
+
+	sdio1: sdio@0x3f190000 {
+		non-removable;
+		max-frequency = <48000000>;
+		status = "okay";
+	};
+
+	sdio3: sdio@0x3f1b0000 {
+		max-frequency = <48000000>;
+		status = "okay";
+	};
+
+
 };
diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index ad13588..6606b41 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -47,4 +47,33 @@
 		    cache-unified;
 		    cache-level = <2>;
 	};
+
+	sdio0: sdio@0x3f180000 {
+		compatible = "bcm,kona-sdhci";
+		reg = <0x3f180000 0x10000>;
+		interrupts = <0x0 77 0x4>;
+		status = "disabled";
+	};
+
+	sdio1: sdio@0x3f190000 {
+		compatible = "bcm,kona-sdhci";
+		reg = <0x3f190000 0x10000>;
+		interrupts = <0x0 76 0x4>;
+		status = "disabled";
+	};
+
+	sdio2: sdio@0x3f1a0000 {
+		compatible = "bcm,kona-sdhci";
+		reg = <0x3f1a0000 0x10000>;
+		interrupts = <0x0 74 0x4>;
+		status = "disabled";
+	};
+
+	sdio3: sdio@0x3f1b0000 {
+		compatible = "bcm,kona-sdhci";
+		reg = <0x3f1b0000 0x10000>;
+		interrupts = <0x0 73 0x4>;
+		status = "disabled";
+	};
+
 };
-- 
1.7.10.4


