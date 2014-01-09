Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaAIQtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:49:36 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:39334 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaAIQtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:49:12 -0500
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
To: <anton@enomsg.org>, <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Cc: <mk7.kang@samsung.com>
Subject: [PATCH 2/3] dt: Document ModelGauge gauge bindings
Date: Thu,  9 Jan 2014 20:49:04 +0400
Message-Id: <1389286145-15375-3-git-send-email-vladimir.barinov@cogentembedded.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
References: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These bindings can be used to register Maxim ModelGauge ICs fuel gauge
(MAX17040/41/43/44/48/49/58/59)

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

---
 Documentation/devicetree/bindings/power_supply/modelgauge_battery.txt |   82 ++++++++++
 1 file changed, 82 insertions(+)

Index: battery-2.6/Documentation/devicetree/bindings/power_supply/modelgauge_battery.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ battery-2.6/Documentation/devicetree/bindings/power_supply/modelgauge_battery.txt	2014-01-09 15:09:38.035138887 +0400
@@ -0,0 +1,82 @@
+modelgauge_battery
+~~~~~~~~~~~~~~~~~~
+
+Required properties:
+ - compatible		: should contain one of the following:
+			  - "maxim,max17040" for MAX17040
+			  - "maxim,max17041" for MAX17041
+			  - "maxim,max17043" for MAX17043
+			  - "maxim,max17044" for MAX17044
+			  - "maxim,max17048" for MAX17048
+			  - "maxim,max17049" for MAX17049
+			  - "maxim,max17058" for MAX17058
+			  - "maxim,max17059" for MAX17059
+
+Optional properties:
+ - maxim,empty_alert_threshold	: Capacity threshold where an interrupt is
+				  generated on the ALRT pin;
+
+ - soc_change_alert		: /* alert for 1% soc change */
+ - hibernate_threshold		: Hibernate threshold (crate), where IC
+				  enters hibernate mode
+ - active_threshold		: Active threshold (mV), where IC exits
+				  hibernate mode
+ - undervoltage			: Voltage (mV), when IC alerts while battery
+				  voltage less then undervoltage
+ - overvoltage			: Voltage (mV), when IC alerts while battery
+				  voltage greater then overvoltage
+ - maxim,resetvoltage		: Voltage threshold (mV) below which the IC
+				  resets itself. Used to detect battery removal
+				  and reinsertion;
+ - maxim,empty_adjustment	: Capacity charge empty design value;
+ - maxim,full_adjustment	: Capacity charge full design value;
+ - maxim,rcomp0			: ModelGauge RCOMP parameter, used for
+				  temperature compensation;
+ - maxim,temp_co_up		: ModelGauge TempCoUp parameter, used for
+				  temperature compensation;
+ - maxim,temp_co_down		: ModelGauge TempCoDown parameter, used for
+				  temperature compensation;
+ - maxim,ocvtest		: ModelGauge OCVTest parameter, used for
+				  verification of Custom Model calibration data
+				  loaded into IC RAM;
+ - maxim,soc_check_a		: ModelGauge SOCCheckA parameter, used for
+				  verification of Custom Model calibration data
+				  loaded into IC RAM;
+ - maxim,soc_check_b		: ModelGauge SOCCheckB parameter, used for
+				  verification of Custom Model calibration data
+				  loaded into IC RAM;
+ - maxim,bits			: ModelGauge Bits parameter, used as
+				  scaling parameter in Custom Model algorithm;
+ - maxim,model_data		: ModelGauge ModelData data,
+				  Custom Model calibration data.
+
+Example:
+
+modelgauge@36 {
+	compatible = "maxim,max17058";
+	reg = <0x36>;
+	interrupt-parent = <&msmgpio>;
+	interrupts = <107 0x2>;
+
+	maxim,empty_alert_threshold = /bits/ 8 <15>;
+	maxim,resetvoltage = /bits/ 16 <0>;
+	maxim,empty_adjustment = /bits/ 8 <0>;
+	maxim,full_adjustment = /bits/ 8 <100>;
+	maxim,rcomp0 = /bits/ 8 <175>;
+	maxim,temp_co_up = <(-1100)>;
+	maxim,temp_co_down = <(-4000)>;
+	maxim,ocvtest = /bits/ 16 <56144>;
+	maxim,soc_check_a = /bits/ 8 <241>;
+	maxim,soc_check_b = /bits/ 8 <243>;
+	maxim,bits = /bits/ 8 <19>;
+
+	maxim,model_data = /bits/ 8 <
+		0x9B 0x70 0xAB 0x30 0xB5 0xA0 0xB9 0xD0
+		0xBB 0xA0 0xBC 0x00 0xBC 0xB0 0xBD 0x00
+		0xBD 0x60 0xBE 0x40 0xBF 0x40 0xC1 0xF0
+		0xC5 0x60 0xC8 0xA0 0xCD 0x00 0xD1 0x50
+		0x00 0xE0 0x01 0x80 0x18 0x60 0x1C 0x20
+		0x54 0x00 0x6A 0xC0 0x79 0x20 0x65 0xC0
+		0x0B 0xE0 0x2A 0xC0 0x1D 0x00 0x17 0xE0
+		0x15 0xE0 0x11 0xE0 0x11 0x00 0x11 0x00>;
+};
