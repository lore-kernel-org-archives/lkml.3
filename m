Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3KATsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:48:36 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:44502 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3KATqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:46:16 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v2 2/9] staging: dwc2: update DT binding to add generic clock/phy properties
Date: Fri,  1 Nov 2013 15:45:51 -0400
Message-Id: <1383335158-19730-3-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dwc2/s3c-hsotg require a single clock to be specified and optionally
a generic phy. On the s3c-hsotg driver old style USB phy support is
present as a fallback so the generic phy properties are optional.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 Documentation/devicetree/bindings/staging/dwc2.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt b/Documentation/devicetree/bindings/staging/dwc2.txt
index 1a1b7cf..f60477e 100644
--- a/Documentation/devicetree/bindings/staging/dwc2.txt
+++ b/Documentation/devicetree/bindings/staging/dwc2.txt
@@ -5,6 +5,14 @@ Required properties:
 - compatible : "snps,dwc2"
 - reg : Should contain 1 register range (address and length)
 - interrupts : Should contain 1 interrupt
+- clocks: clock provider specifier
+- clock-names: shall be "otg"
+Refer to clk/clock-bindings.txt for generic clock consumer properties
+
+Optional properties:
+- phys: phy provider specifier
+- phy-names: shall be "usb2-phy"
+Refer to phy/phy-bindings.txt for generic phy consumer properties
 
 Example:
 
@@ -12,4 +20,8 @@ Example:
                 compatible = "ralink,rt3050-usb, snps,dwc2";
                 reg = <0x101c0000 40000>;
                 interrupts = <18>;
+		clocks = <&usb_otg_ahb_clk>;
+		clock-names = "otg";
+		phys = <&usbphy>;
+		phy-names = "usb2-phy";
         };
-- 
1.8.4

