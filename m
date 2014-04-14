Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaDNRm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:42:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54015 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbaDNRmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:42:53 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <ivan.khoronzhuk@ti.com>, <grygorii.strashko@ti.com>, <olof@lixom.net>,
        <w-kwok2@ti.com>, <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 4/5] ARM: dts: keystone: update reset node to work with reset driver
Date: Mon, 14 Apr 2014 20:41:22 +0300
Message-ID: <1397497283-16391-5-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397497283-16391-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1397497283-16391-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset controller registers are part of the PLL Controller MMRs.
According to TRM there are the following registers:
RSTYPE, RSCTRL, RSCFG and RSISO. Currently declared only one of them,
but that is not enough to correctly setup reset properties, so add
whole range of pll registers - pllregs.

Also add range for reset multiplex registers for SoC on the device.
These registers are located in Bootcfg memory space and needed
to setup behaviour after appropriate watchdog is triggered.

Add "ti,wdt_list" option to declare what watchdog are used to reboot
the SoC.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/boot/dts/keystone.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
index 90823eb..9d6b850 100644
--- a/arch/arm/boot/dts/keystone.dtsi
+++ b/arch/arm/boot/dts/keystone.dtsi
@@ -69,7 +69,9 @@
 
 		rstctrl: reset-controller {
 			compatible = "ti,keystone-reset";
-			reg = <0x023100e8 4>;	/* pll reset control reg */
+			reg = <0x23100e4 0x10>, <0x2620328 0x10>;
+			reg-names = "pllregs", "muxregs";
+			ti,wdt_list = <0>;
 		};
 
 		/include/ "keystone-clocks.dtsi"
-- 
1.8.3.2

