Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3KVVz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:55:26 -0500
Received: from gloria.sntech.de ([95.129.55.99]:56485 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab3KVVzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:55:24 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 1/2] dt-bindings: add hym8563 binding
Date: Fri, 22 Nov 2013 22:55:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>
References: <201311222254.07730.heiko@sntech.de>
In-Reply-To: <201311222254.07730.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311222255.03642.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for the hym8563 rtc chip.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../devicetree/bindings/rtc/haoyu,hym8563.txt      |   29 ++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt

diff --git a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
new file mode 100644
index 0000000..2743416
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
@@ -0,0 +1,29 @@
+Haoyu Microelectronics HYM8563 Real Time Clock
+
+The HYM8563 provides basic rtc and alarm functionality
+as well as a clock output of up to 32kHz.
+
+Required properties:
+- compatible: should be: "haoyu,hym8563"
+- reg: i2c address
+- gpios: interrupt gpio
+- interrupts: rtc alarm/event interrupt
+- #clock-cells: the value should be 0
+
+Example:
+
+hym8563: hym8563@51 {
+	compatible = "haoyu,hym8563";
+	reg = <0x51>;
+
+	gpios = <&gpio0 13 0>;
+	interrupts = <13 IRQ_TYPE_EDGE_FALLING>;
+
+	#clock-cells = <0>;
+};
+
+device {
+...
+	clocks = <&hym8563>;
+...
+};
-- 
1.7.10.4

