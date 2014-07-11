Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaGKOFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:05:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59447 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGKOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:18 -0400
X-AuditID: cbfee61b-f79f86d00000144c-1b-53bfef1c5bc2
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v4 12/21] DT: Add documentation for LED Class Flash Manger
Date: Fri, 11 Jul 2014 16:04:15 +0200
Message-id: <1405087464-13762-13-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jQV2Z9/uDDc51i1hsnLGe1eLozolM
	FvOPnGO16H+zkNXi3KuVjBa9V58zWpxtesNucXnXHDaLrW/WMVr0bNjKarH0+kUmiwnT17JY
	tO49wm6xe9dTVgc+jzXz1jB6XO7rZfLYOesuu8fK5V/YPDat6mTz2DP/B6tH35ZVjB6fN8kF
	cERx2aSk5mSWpRbp2yVwZTw8/oW94JB6xf9Pn1gbGI/KdTFyckgImEjs2PSHCcIWk7hwbz1b
	FyMXh5DAdEaJR4/fgyWEBNqZJF5MrQex2QQMJX6+eA0WFxEol+h5/wysgVngBZPE3Imz2EAS
	wgJ+Eof3d7GD2CwCqhJ/7l0Bs3kFPCV29V0BquEA2qYgMWeSDUiYEyh8sP8mG8QuD4mHa0+w
	T2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOHCfSe9gXNVgcYhRgINRiYf3xJp9
	wUKsiWXFlbmHGCU4mJVEeK++2R8sxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6Yklq
	dmpqQWoRTJaJg1OqgVE7YPbVmxwJRQ85Vwpo2qrsOPHEryx/+uGd4mcmqa9crfJjtnH/crW/
	sQrZd/ftanaWm9yx48Y2oeaPBtkbp0aGP7N9778zcILNRrbsKe1iQutYv9Ue8CyPFHu0OUCz
	6bBqvFffLY0Ptxisf/juC2k6sSRf/IXvnnNXGvVnnLDuY5rsYPZY1FaJpTgj0VCLuag4EQDC
	WwujWAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents LED Class Flash Manager
related bindings.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 .../bindings/leds/leds-flash-manager.txt           |  165 ++++++++++++++++++++
 1 file changed, 165 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-flash-manager.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-flash-manager.txt b/Documentation/devicetree/bindings/leds/leds-flash-manager.txt
new file mode 100644
index 0000000..c98ee2e
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-flash-manager.txt
@@ -0,0 +1,165 @@
+* LED Flash Manager
+
+Flash manager is a part of LED Flash Class. It maintains
+all the flash led devices which have their external strobe
+signals routed through multiplexing devices.
+The multiplexers are aggregated in the standalone 'flash_muxes'
+node as subnodes which are referenced by the flash led devices.
+
+
+flash_muxes node
+----------------
+
+muxN subnode
+------------
+
+There must be at least one muxN subnode, where N is the identifier
+of the node, present in the flash_muxes node. One muxN node
+represents one multiplexer.
+
+Required properties (mutually exclusive):
+- gpios		: specifies the gpio pins used to set the states
+		  of mux selectors, LSB first
+- mux-async	: phandle to the node of the multiplexing device
+
+
+
+flash led device node
+---------------------
+
+Following subnodes must be added to the LED Flash Class device
+tree node described in Documentation/devicetree/bindings/leds/common.txt.
+
+
+gate-software-strobe subnode
+----------------------------
+
+The node defines configuration of multiplexers that needs
+to be applied to route software strobe signal to the flash
+led device.
+
+Required properties:
+- mux		: phandle to the muxN node defined
+		  in the flash_muxes node
+- mux-line-id	: mux line identifier
+
+Optional subnodes:
+- gate-software-strobe : if there are many multiplexers to configure,
+			 they can be recursively nested.
+
+
+gate-external-strobeN subnode
+-----------------------------
+
+The node defines configuration of multiplexers that needs
+to be applied to route external strobe signal to the flash
+led device. A flash led device can have many external strobe
+signal sources.
+
+Required properties:
+- mux			: phandle to the muxN node defined
+			  in the flash_muxes node
+- mux-line-id		: mux line identifier
+Optional properties:
+- strobe-provider	: phandle to the device providing the
+			  strobe signal. It is expected only
+			  on the first level node. The referenced
+			  node is expected to have 'compatible'
+			  property, as providers are labelled
+			  with it in the LED subsystem
+
+Optional subnodes:
+- gate-external-strobeN	: if there are many multiplexers to configure,
+			  they can be recursively nested.
+
+
+Example:
+
+Following board configuration is assumed in this example:
+
+    ---------- ----------
+    | FLASH1 | | FLASH2 |
+    ---------- ----------
+           \(0)   /(1)
+          ----------
+          |  MUX1  |
+          ----------
+              |
+          ----------
+          |  MUX2  |
+          ----------
+           /(0)   \(1)
+      ----------  --------------------
+      |  MUX3  |  | SOC FLASHEN GPIO |
+      ----------  --------------------
+       /(0)   \(1)
+----------- -----------
+| SENSOR1 | | SENSOR2 |
+----------- -----------
+
+
+dummy_mux: led_mux {
+	compatible = "led-async-mux";
+};
+
+flash_muxes {
+	flash_mux1: mux1 {
+                gpios = <&gpj1 1 0>, <&gpj1 2 0>;
+	};
+
+	flash_mux2: mux2 {
+		mux-async = <&dummy_mux>;
+	};
+
+	flash_mux3: mux3 {
+                gpios = <&gpl1 1 0>, <&gpl1 2 0>;
+	};
+};
+
+max77693-flash {
+	compatible = "maxim,max77693-flash";
+
+	//other device specific properties here
+
+	gate-software-strobe {
+		mux = <&flash_mux1>;
+		mux-line-id = <0>;
+
+		gate-software-strobe {
+			mux = <&flash_mux2>;
+			mux-line-id = <1>;
+		};
+	};
+
+	gate-external-strobe1 {
+		strobe-provider = <&s5c73m3_spi>;
+		mux = <&flash_mux1>;
+		mux-line-id = <0>;
+
+		gate-external-strobe1 {
+			mux = <&flash_mux2>;
+			mux-line-id = <0>;
+
+			gate-external-strobe1 {
+				mux = <&flash_mux3>;
+				mux-line-id = <0>;
+			};
+		};
+	};
+
+	gate-external-strobe2 {
+		strobe-provider = <&s5k6a3>;
+		mux = <&flash_mux1>;
+		mux-line-id = <0>;
+
+		gate-external-strobe2 {
+			mux = <&flash_mux2>;
+			mux-line-id = <0>;
+
+			gate-external-strobe2 {
+				mux = <&flash_mux3>;
+				mux-line-id = <1>;
+			};
+		};
+	};
+};
-- 
1.7.9.5

