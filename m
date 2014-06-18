Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966618AbaFRMWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:22:11 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50663 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966548AbaFRMWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:22:07 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: netdev@vger.kernel.org
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next v3 3/3] devicetree: add device tree bindings for cc2520 driver
Date: Wed, 18 Jun 2014 17:50:32 +0530
Message-Id: <1403094032-6121-4-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403094032-6121-1-git-send-email-varkab@cdac.in>
References: <1403094032-6121-1-git-send-email-varkab@cdac.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT bindings for cc2520 radio driver

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 .../devicetree/bindings/net/ieee802154/cc2520.txt  |   29 ++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ieee802154/cc2520.txt

diff --git a/Documentation/devicetree/bindings/net/ieee802154/cc2520.txt b/Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
new file mode 100644
index 0000000..6b41f78
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
@@ -0,0 +1,29 @@
+*CC2520 IEEE 802.15.4 Compatible Radio*
+
+Required properties:
+	- compatible: 		should be "ti,cc2520"
+	- spi-max-frequency:	maximal bus speed (8000000), should be set to 4000000 depends
+			     	sync or async operation mode
+	- reg:			the chipselect index
+	- pinctrl-0: 		pin control group to be used for this controller.
+	- pinctrl-names: 	must contain a "default" entry.
+	- fifo-gpio:		GPIO spec for the FIFO pin
+	- fifop-gpio:		GPIO spec for the FIFOP pin
+	- sfd-gpio:		GPIO spec for the SFD pin
+	- cca-gpio:		GPIO spec for the CCA pin
+	- vreg-gpio:		GPIO spec for the VREG pin
+	- reset-gpio:		GPIO spec for the RESET pin
+Example:
+	cc2520@0 {
+		compatible = "ti,cc2520";
+		reg = <0>;
+		spi-max-frequency = <4000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&cc2520_cape_pins>;
+		fifo-gpio = <&gpio1 18 0>;
+		fifop-gpio = <&gpio1 19 0>;
+		sfd-gpio = <&gpio1 13 0>;
+		cca-gpio = <&gpio1 16 0>;
+		vreg-gpio = <&gpio0 31 0>;
+		reset-gpio = <&gpio1 12 0>;
+	};
-- 
1.7.9.5

