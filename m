Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbaENRNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:13:32 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:40379 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaENRNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:13:25 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de, matthias.bgg@gmail.com,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        arnd@arndb.de, robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 2/6] dt-bindings: add mtk-timer bindings
Date: Wed, 14 May 2014 19:12:55 +0200
Message-Id: <1400087579-4250-3-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400087579-4250-1-git-send-email-matthias.bgg@gmail.com>
References: <1400087579-4250-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for the General Porpose Timer driver of
the Mediatek SoCs.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 .../devicetree/bindings/timer/mediatek,mtk-timer.txt   | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt

diff --git a/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
new file mode 100644
index 0000000..938adf6
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
@@ -0,0 +1,18 @@
+Mediatek MT6589, MT6577 and MT6572 Timers
+---------------------------------------
+
+Required properties:
+- compatible: Should be "mediatek,mtk6589-timer"
+- reg: Should contain location and length for timers register.
+- clocks: Clocks driving the timer hardware. This list shoud include two
+	clocks. The order is system clock and as second clock the RTC clock.
+
+Examples:
+
+	timer {
+		compatible = "mediatek,mtk6589-timer";
+		reg = <0x10008000 0x80>;
+		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&system_clk>, <&rtc_clk>;
+		clock-names = "system-clk", "rtc-clk";
+	};
-- 
1.8.1.2

