Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaAMLLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:11:50 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50396 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaAMLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:11:48 -0500
Message-ID: <52D3C9EF.1030901@koalo.de>
Date: Mon, 13 Jan 2014 12:11:43 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Subject: [PATCH 1/2] BCM2835: Add dmaengine driver to device tree
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the definitions for the BCM2835 dmaengine driver
to the device tree. The dma-channel-mask is currently
fixed. Later it should be set via the firmware.

Signed-off-by: Florian Meier <florian.meier@koalo.de>
---
 arch/arm/boot/dts/bcm2835.dtsi | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index b021c96..1da6b36 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -113,6 +113,27 @@
 			reg = <0x7e980000 0x10000>;
 			interrupts = <1 9>;
 		};
+
+		dma: dma@7e007000 {
+			compatible = "brcm,bcm2835-dma";
+			reg = <0x7e007000 0xf00>;
+			interrupts = <1 16>,
+				     <1 17>,
+				     <1 18>,
+				     <1 19>,
+				     <1 20>,
+				     <1 21>,
+				     <1 22>,
+				     <1 23>,
+				     <1 24>,
+				     <1 25>,
+				     <1 26>,
+				     <1 27>,
+				     <1 28>;
+
+			#dma-cells = <1>;
+			brcm,dma-channel-mask = <0x7f35>;
+		};
 	};
 
 	clocks {
-- 
1.8.3.2
