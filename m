Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab3KNVDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:03:02 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1373 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab3KNVCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:02:48 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Wolfram Sang" <wsa@the-dreams.de>,
        "Grant Likely" <grant.likely@linaro.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux Doc List" <linux-doc@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux I2C List" <linux-i2c@vger.kernel.org>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH v2 1/5] Documentation: dt: Add i2c-bcm-kona binding
Date: Thu, 14 Nov 2013 13:02:12 -0800
Message-ID: <1384462936-7906-2-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1384462936-7906-1-git-send-email-tim.kryger@linaro.org>
References: <1384462936-7906-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E9BE5B41SC8127047-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the binding description for the i2c-bcm-kona block found on
Broadcom's mobile SoCs.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 .../devicetree/bindings/i2c/i2c-bcm-kona.txt       | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-bcm-kona.txt

diff --git a/Documentation/devicetree/bindings/i2c/i2c-bcm-kona.txt b/Documentation/devicetree/bindings/i2c/i2c-bcm-kona.txt
new file mode 100644
index 0000000..1b87b74
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-bcm-kona.txt
@@ -0,0 +1,35 @@
+Broadcom Kona Family I2C
+=========================
+
+This I2C controller is used in the following Broadcom SoCs:
+
+  BCM11130
+  BCM11140
+  BCM11351
+  BCM28145
+  BCM28155
+
+Required Properties
+-------------------
+- compatible: "brcm,bcm11351-i2c", "brcm,kona-i2c"
+- reg: Physical base address and length of controller registers
+- interrupts: The interrupt number used by the controller
+- clocks: clock specifier for the kona i2c external clock
+- clock-frequency: The I2C bus frequency in Hz
+- #address-cells: Should be <1>
+- #size-cells: Should be <0>
+
+Refer to clocks/clock-bindings.txt for generic clock consumer
+properties.
+
+Example:
+
+i2c@3e016000 {
+	compatible = "brcm,bcm11351-i2c","brcm,kona-i2c";
+	reg = <0x3e016000 0x80>;
+	interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&bsc1_clk>;
+	clock-frequency = <400000>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+};
-- 
1.8.0.1


