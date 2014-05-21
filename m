Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaEUTfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:35:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41748 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752963AbaEUTfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:35:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Nicolas Pitre <nico@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/2] ARM: sunxi: Add clocks node to the CPU nodes
Date: Wed, 21 May 2014 21:33:16 +0200
Message-Id: <1400700796-5763-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400700796-5763-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1400700796-5763-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the clock will make the topology code work, and will remove the
following error at boot

[    0.097194] /cpus/cpu@0 missing clock-frequency property
[    0.103657] /cpus/cpu@1 missing clock-frequency property
[    0.110698] /cpus/cpu@2 missing clock-frequency property
[    0.117132] /cpus/cpu@3 missing clock-frequency property

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 4 ++++
 arch/arm/boot/dts/sun7i-a20.dtsi | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 4155fc43ecff..6814a1c4759b 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -34,24 +34,28 @@
 		cpu@0 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
+			clocks = <&cpu>;
 			reg = <0>;
 		};
 
 		cpu@1 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
+			clocks = <&cpu>;
 			reg = <1>;
 		};
 
 		cpu@2 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
+			clocks = <&cpu>;
 			reg = <2>;
 		};
 
 		cpu@3 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
+			clocks = <&cpu>;
 			reg = <3>;
 		};
 	};
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 385933bac114..8402f33158bf 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -35,12 +35,14 @@
 		cpu@0 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
+			clocks = <&cpu>;
 			reg = <0>;
 		};
 
 		cpu@1 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
+			clocks = <&cpu>;
 			reg = <1>;
 		};
 	};
-- 
1.9.3

