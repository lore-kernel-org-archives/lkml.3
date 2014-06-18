Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068AbaFRFR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:17:27 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64922 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839AbaFRFRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:17:16 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: netdev@vger.kernel.org
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next v2 3/3] devicetree: add devicetree bindings for cc2520 driver
Date: Wed, 18 Jun 2014 10:46:05 +0530
Message-Id: <1403068565-32224-4-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403068565-32224-1-git-send-email-varkab@cdac.in>
References: <1403068565-32224-1-git-send-email-varkab@cdac.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devicetree bindings for cc2520 radio driver.

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 .../devicetree/bindings/net/ieee802154/cc2520.txt  |   26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ieee802154/cc2520.txt

diff --git a/Documentation/devicetree/bindings/net/ieee802154/cc2520.txt b/Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
new file mode 100644
index 0000000..f0a749d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
@@ -0,0 +1,26 @@
+CC2520 IEEE 802.15.4 Compatible Radio
+
+Required properties:
+	- compatible:		should be "ti,cc2520"
+	- spi-max-frequency:	maximal bus speed (8000000), should be set to 4000000 depends
+				sync or async operation mode
+	- reg:			the chipselect index
+	- mode:			SPI mode
+Example:
+
+	cc2520@0 {
+		compatible = "ti,cc2520";
+		reg = <0>;
+		spi-max-frequency = <4000000>;
+		mode = <1>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&cc2520_cape_pins>;	/*GPIO pin muxing details*/
+
+		fifo-gpio = <&gpio1 18 0>;
+		fifop-gpio = <&gpio1 19 0>;
+		sfd-gpio = <&gpio1 13 0>;
+		cca-gpio = <&gpio1 16 0>;
+		vreg-gpio = <&gpio0 31 0>;
+		reset-gpio = <&gpio1 12 0>;
+	};
-- 
1.7.9.5

