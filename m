Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbaCULoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:44:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55810 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760135AbaCULnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:43:55 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/5] ARM: berlin/dt: add cpupll and syspll support to BG2Q
Date: Fri, 21 Mar 2014 12:43:38 +0100
Message-Id: <1395402220-23503-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 07452a7483fa..19d2c82b0664 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -59,10 +59,26 @@
 		clock-frequency = <100000000>;
 	};
 
+	syspll: syspll {
+		compatible = "marvell,berlin2q-pll";
+		clocks = <&smclk>;
+		#clock-cells = <0>;
+		reg = <0xf7ea0030 8>;
+	};
+
+	cpupll: cpupll {
+		compatible = "marvell,berlin2q-pll";
+		clocks = <&smclk>;
+		#clock-cells = <0>;
+		reg = <0xf7dd0170 8>;
+	};
+
 	cpuclk: cpu-clock {
-		compatible = "fixed-clock";
+		compatible = "fixed-factor-clock";
+		clocks = <&cpupll>;
 		#clock-cells = <0>;
-		clock-frequency = <1200000000>;
+		clock-div = <1>;
+		clock-mult = <1>;
 	};
 
 	twdclk: twdclk {
-- 
1.8.3.2

