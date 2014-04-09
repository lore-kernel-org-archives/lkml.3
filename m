Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436AbaDITqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:46:11 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54957 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934416AbaDITqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:46:07 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de, matthias.bgg@gmail.com,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/4] dt-bindings: add mtk-timer bindings
Date: Wed,  9 Apr 2014 21:45:34 +0200
Message-Id: <1397072736-10793-3-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for the General Porpose Timer driver of
the Mediatek SoCs.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 .../bindings/timer/mediatek,mtk-timer.txt          |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt

diff --git a/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
new file mode 100644
index 0000000..db3c836
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
@@ -0,0 +1,19 @@
+Mediatek MT6598, MT6577 and MT6572 Timers
+---------------------------------------
+
+Required properties:
+- compatible: Should be "mediatek,mtk6589-timer"
+- reg: Should contain location and length for timers register.
+- clock-names : Must include the following entries:
+  "sysclk" (13 MHz system clock),
+  "rtcclk" (32 KHz RTC clock).
+
+Examples:
+
+	timer {
+		compatible = "mediatek,mtk6589-timer";
+		reg = <0x10008000 0x80>;
+		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&system_clk>, <&rtc-clk>;
+		clock-names = "sysclk", "rtcclk";
+	};
-- 
1.7.9.5

