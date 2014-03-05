Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbaCEAKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:10:38 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60667 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbaCEAKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:10:35 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: dove: drop pinctrl PMU reg property
Date: Wed,  5 Mar 2014 01:03:08 +0100
Message-Id: <1393977790-29110-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marvell Dove's pinctrl does require some PMU regs for muxing PMU
functions to MPP pins. Recently, a discussion started about consolidating
Power Management Unit (PMU) into a single DT node. As we don't want
anymore DT ABI in the way, drop the corresponding reg property from
pinctrl node now. The driver will derive the registers from existing
reg properties.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org> 
Cc: Pawel Moll <pawel.moll@arm.com> 
Cc: Mark Rutland <mark.rutland@arm.com> 
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk> 
Cc: Kumar Gala <galak@codeaurora.org> 
Cc: Russell King <linux@arm.linux.org.uk> 
Cc: Jason Cooper <jason@lakedaemon.net> 
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org 
Cc: linux-arm-kernel@lists.infradead.org 
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index b6fc27f8ed66..3b891dd20993 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -395,8 +395,7 @@
 			pinctrl: pin-ctrl@d0200 {
 				compatible = "marvell,dove-pinctrl";
 				reg = <0xd0200 0x14>,
-				      <0xd0440 0x04>,
-				      <0xd802c 0x08>;
+				      <0xd0440 0x04>;
 				clocks = <&gate_clk 22>;
 
 				pmx_gpio_0: pmx-gpio-0 {
-- 
1.8.5.3

