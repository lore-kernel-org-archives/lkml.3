Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaCEQX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:23:59 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:44192 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaCEQX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:23:57 -0500
X-Auth-Info: 5VDUrNiEYfTqQQ8y29R/21jKmBC0vunoLOSBQYHCsPk=
Date: Wed, 5 Mar 2014 17:23:50 +0100
From: Pavel Machek <pavel@denx.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, dinguyen@altera.com
Subject: [PATCH] dts: add support for MMC on socfpga boards
Message-ID: <20140305162350.GA3674@pollux.denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add DTS binding for MMC on socfpga boards. Tested on Sockit.
    
Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 537f1a5..cad7526 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -521,6 +521,23 @@
 			reg-io-width = <4>;
 		};
 
+		mmc: dwmmc0@ff704000 {
+			compatible = "snps,dw-mshc";
+			reg = <0xff704000 0x1000>;
+			interrupts = <0 139 4>;
+			clock-frequency = <12500000>; /*12.5 MHz*/
+			#address-cells = <1>;
+			#size-cells = <0>;
+			num-slots = <1>;
+			supports-highspeed;
+			broken-cd;
+			fifo-depth = <0x400>;
+			slot@0 {
+				reg = <0>;
+				bus-width = <4>;
+			};
+		};
+
 		rstmgr@ffd05000 {
 			compatible = "altr,rst-mgr";
 			reg = <0xffd05000 0x1000>;
