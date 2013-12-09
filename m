Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643Ab3LIVUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:20:41 -0500
Received: from gloria.sntech.de ([95.129.55.99]:46887 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab3LIVUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:20:39 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH v4 1/2] dt-bindings: add hym8563 binding
Date: Mon, 9 Dec 2013 22:20:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Mark Brown <broonie@kernel.org>
References: <201312092219.11342.heiko@sntech.de>
In-Reply-To: <201312092219.11342.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312092220.30894.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for the hym8563 rtc chip.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../devicetree/bindings/rtc/haoyu,hym8563.txt      |   27 ++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 2 files changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt

diff --git a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
new file mode 100644
index 0000000..31406fd
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
@@ -0,0 +1,27 @@
+Haoyu Microelectronics HYM8563 Real Time Clock
+
+The HYM8563 provides basic rtc and alarm functionality
+as well as a clock output of up to 32kHz.
+
+Required properties:
+- compatible: should be: "haoyu,hym8563"
+- reg: i2c address
+- interrupts: rtc alarm/event interrupt
+- #clock-cells: the value should be 0
+
+Example:
+
+hym8563: hym8563@51 {
+	compatible = "haoyu,hym8563";
+	reg = <0x51>;
+
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
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index edbb8d8..bb86195 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -33,6 +33,7 @@ fsl	Freescale Semiconductor
 GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
 gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
 gmt	Global Mixed-mode Technology, Inc.
+haoyu	Haoyu Microelectronic Co. Ltd.
 hisilicon	Hisilicon Limited.
 hp	Hewlett Packard
 ibm	International Business Machines (IBM)
-- 
1.7.10.4

