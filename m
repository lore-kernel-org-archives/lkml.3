Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbbASVvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:51:45 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:12333 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbASVvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:51:12 -0500
X-IronPort-AV: E=Sophos;i="5.09,429,1418112000"; 
   d="scan'208";a="54995836"
From: Ray Jui <rjui@broadcom.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Arend van Spriel <arend@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v7 1/3] i2c: iProc: define Broadcom iProc I2C binding
Date: Mon, 19 Jan 2015 13:51:48 -0800
Message-ID: <1421704310-26857-2-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421704310-26857-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1421704310-26857-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the I2C device tree binding for Broadcom iProc family of
SoCs

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 .../devicetree/bindings/i2c/brcm,iproc-i2c.txt     |   37 ++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/brcm,iproc-i2c.txt

diff --git a/Documentation/devicetree/bindings/i2c/brcm,iproc-i2c.txt b/Documentation/devicetree/bindings/i2c/brcm,iproc-i2c.txt
new file mode 100644
index 0000000..81f982c
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/brcm,iproc-i2c.txt
@@ -0,0 +1,37 @@
+Broadcom iProc I2C controller
+
+Required properties:
+
+- compatible:
+    Must be "brcm,iproc-i2c"
+
+- reg:
+    Define the base and range of the I/O address space that contain the iProc
+    I2C controller registers
+
+- interrupts:
+    Should contain the I2C interrupt
+
+- clock-frequency:
+    This is the I2C bus clock. Need to be either 100000 or 400000
+
+- #address-cells:
+    Always 1 (for I2C addresses)
+
+- #size-cells:
+    Always 0
+
+Example:
+	i2c0: i2c@18008000 {
+		compatible = "brcm,iproc-i2c";
+		reg = <0x18008000 0x100>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <GIC_SPI 85 IRQ_TYPE_NONE>;
+		clock-frequency = <100000>;
+
+		codec: wm8750@1a {
+			compatible = "wlf,wm8750";
+			reg = <0x1a>;
+		};
+	};
-- 
1.7.9.5

