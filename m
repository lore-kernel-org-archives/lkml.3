Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaIAMyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:54:15 -0400
Received: from exprod7og128.obsmtp.com ([64.18.2.121]:50480 "EHLO
	exprod7og128.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaIAMyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:54:10 -0400
From: Anders Berg <anders.berg@avagotech.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anders Berg <anders.berg@avagotech.com>
Subject: [PATCH 2/2] Documentation: DT bindings for AXM55xx SSP CS
Date: Mon,  1 Sep 2014 14:53:41 +0200
Message-Id: <1409576021-24828-3-git-send-email-anders.berg@avagotech.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
References: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bindings and documentation for AXM55xx SSP chip select controller.

Signed-off-by: Anders Berg <anders.berg@avagotech.com>
---
 .../devicetree/bindings/gpio/gpio-axxia-sspcs.txt  | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-axxia-sspcs.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-axxia-sspcs.txt b/Documentation/devicetree/bindings/gpio/gpio-axxia-sspcs.txt
new file mode 100644
index 0000000..a64c695
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-axxia-sspcs.txt
@@ -0,0 +1,36 @@
+* Axxia SSP GPIO chip-select driver
+
+The Axxia device has a ARM PL022 Prime Cell SSP controller with an extension of
+five chip select signals that may be controlled by software. This driver
+exports them as GPIOs.
+
+Required properties:
+
+  * compatible: should be "lsi,ssp-gpio"
+  * reg: address of the chip select control register.
+  * gpio-controller: mark the device as gpio controller
+  * #gpio-cells: should be 1 and this field specifies the chip select number
+
+Example:
+-------
+
+	spics: sspgpio@2010088030 {
+		compatible = "lsi,ssp-gpio";
+		#gpio-cells = <1>;
+		reg = <0x20 0x10088030 0x00 0x4>;
+		gpio-controller;
+	};
+
+	spi0: ssp@2010088000 {
+		compatible = "arm,pl022", "arm,primecell";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x20 0x10088000 0x00 0x1000>;
+		num-cs = <5>;
+		cs-gpios = <&spics 0>,
+			   <&spics 1>,
+			   <&spics 2>,
+			   <&spics 3>,
+			   <&spics 4>;
+		...
+      };
-- 
1.9.1

