Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3KOOVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:21:08 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:64158 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3KOOUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:20:37 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: kirkwood: provide pinctrl default to sdio nodes
Date: Fri, 15 Nov 2013 15:20:24 +0100
Message-Id: <1384525225-591-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDIO controllers found on Marvell Kirkwood 6281/6282 SoCs require
pins to be muxed by pinctrl. As there is only one sane pinctrl
setting for this, provide default pinctrl properties to the controller
nodes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
I am not sending this two patches to each DT maintainer, as it is a
Kirkwood only thing, added the dt list for completeness.

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/kirkwood-6281.dtsi |    2 ++
 arch/arm/boot/dts/kirkwood-6282.dtsi |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-6281.dtsi b/arch/arm/boot/dts/kirkwood-6281.dtsi
index 650ef30..e4e1968 100644
--- a/arch/arm/boot/dts/kirkwood-6281.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6281.dtsi
@@ -97,6 +97,8 @@
 			reg = <0x90000 0x200>;
 			interrupts = <28>;
 			clocks = <&gate_clk 4>;
+			pinctrl-0 = <&pmx_sdio>;
+			pinctrl-names = "default";
 			bus-width = <4>;
 			cap-sdio-irq;
 			cap-sd-highspeed;
diff --git a/arch/arm/boot/dts/kirkwood-6282.dtsi b/arch/arm/boot/dts/kirkwood-6282.dtsi
index 3933a33..f010c21 100644
--- a/arch/arm/boot/dts/kirkwood-6282.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6282.dtsi
@@ -125,6 +125,8 @@
 			reg = <0x90000 0x200>;
 			interrupts = <28>;
 			clocks = <&gate_clk 4>;
+			pinctrl-0 = <&pmx_sdio>;
+			pinctrl-names = "default";
 			bus-width = <4>;
 			cap-sdio-irq;
 			cap-sd-highspeed;
-- 
1.7.2.5

