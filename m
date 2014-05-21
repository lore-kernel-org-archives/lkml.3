Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaEUO3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:29:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44380 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbaEUO3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:29:08 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <santosh.shilimkar@ti.com>,
        <arnd@arndb.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v4 4/5] ARM: dts: keystone: update reset node to work with reset driver
Date: Wed, 21 May 2014 17:27:33 +0300
Message-ID: <1400682454-24535-5-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The keystone driver requires the next additional properties:

"ti,syscon-pll" - syscon register range used to access pll controller
		  registers in order to use reset control registers.
"ti,syscon-dev" - syscon register range used to access device state
		  control registers in order to use mux block
		  registers for all watchdogs.

"ti,wdt_list"	- option to declare what watchdog are used to reboot
		  the SoC, so set "0" WDT as default.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/boot/dts/keystone.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
index 8b899ba..783da60 100644
--- a/arch/arm/boot/dts/keystone.dtsi
+++ b/arch/arm/boot/dts/keystone.dtsi
@@ -78,7 +78,9 @@
 
 		rstctrl: reset-controller {
 			compatible = "ti,keystone-reset";
-			reg = <0x023100e8 4>;	/* pll reset control reg */
+			ti,syscon-pll = <&pllctrl>;
+			ti,syscon-dev = <&devctrl>;
+			ti,wdt_list = <0>;
 		};
 
 		/include/ "keystone-clocks.dtsi"
-- 
1.8.3.2

