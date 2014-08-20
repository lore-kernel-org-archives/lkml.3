Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaHTNoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:44:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36248 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaHTNov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:51 -0400
X-AuditID: cbfee61b-f79f86d00000144c-b7-53f4a651c5d2
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
Subject: [PATCH/RFC v5 05/10] DT: Add documentation for LED Class Flash Manger
Date: Wed, 20 Aug 2014 15:44:14 +0200
Message-id: <1408542259-415-6-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd3AZV+CDa495rXYOGM9q8XRnROZ
	LOYfOcdq0f9mIavFuVcrGS16rz5ntDjb9Ibd4vKuOWwWW9+sY7To2bCV1WLp9YtMFhOmr2Wx
	aN17hN1i966nrA58HmvmrWH0uNzXy+Sxc9Zddo+Vy7+weWxa1cnmsWf+D1aPvi2rGD0+b5IL
	4IjisklJzcksSy3St0vgyvj+t5OtYJ96xdGprxkbGPfLdTFyckgImEh8v9zLDmGLSVy4t56t
	i5GLQ0hgEaPEm/v3oJx2Jomv3d8YQarYBAwlfr54zQRiiwiUS/S8fwZWxCzwgkli7sRZQA4H
	h7CAn8S8g5wgNSwCqhLvV/5hBrF5Bdwknsz8C1YiIaAgMWeSDYjJKeAuseW9CkiFEFDF6Xez
	WSYw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERy2z6R3MK5qsDjEKMDBqMTDe2PR
	l2Ah1sSy4srcQ4wSHMxKIrztnUAh3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1Kz
	U1MLUotgskwcnFINjK3vEyfMX92yo2BH7YRFS/ZN1w75t073quSG1UlvypP0OF43bbytfmk/
	Y8Vhg8PPJ/9nDlJni0jVeV97UGr9iVwmB15z3j0LjB0El0++/IzTTpZNhCPbac4UniUWwrvb
	w0OTpKdf/9KbZFUivO7oK/GUVdJPplw9ODXCJ/j5g3bn0ykOdzNKriqxFGckGmoxFxUnAgA+
	5GeCVwIAAA==
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
 .../bindings/leds/leds-flash-manager.txt           |  163 ++++++++++++++++++++
 1 file changed, 163 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-flash-manager.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-flash-manager.txt b/Documentation/devicetree/bindings/leds/leds-flash-manager.txt
new file mode 100644
index 0000000..d36aca2
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-flash-manager.txt
@@ -0,0 +1,163 @@
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
+The node defines multiplexer settings that need to be applied if
+software strobe signal is to be routed to the flash led device.
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
+The node defines multiplexer settings that need to be applied if
+external strobe signal is to be routed to the flash led device.
+A flash led device can have many external strobe signal sources.
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

