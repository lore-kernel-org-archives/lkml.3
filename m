Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaCCOyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:54:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32866 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbaCCOvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:51:10 -0500
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <akpm@linux-foundation.org>, <nm@ti.com>,
        <balajitk@ti.com>, <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RESEND Patch 2/9] ARM: dts: am335x-evm: add SD card hotplug support
Date: Mon, 3 Mar 2014 20:20:19 +0530
Message-ID: <1393858226-32595-4-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
References: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

Add card detect gpio for SD card slot

Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/boot/dts/am335x-evm.dts | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 07d61bb..28ae040 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -260,6 +260,12 @@
 		>;
 	};
 
+	mmc1_pins: pinmux_mmc1_pins {
+		pinctrl-single,pins = <
+			0x160 (PIN_INPUT | MUX_MODE7) /* spi0_cs1.gpio0_6 */
+		>;
+	};
+
 	lcd_pins_s0: lcd_pins_s0 {
 		pinctrl-single,pins = <
 			0x20 0x01	/* gpmc_ad8.lcd_data16, OUTPUT | MODE1 */
@@ -644,6 +650,9 @@
 	status = "okay";
 	vmmc-supply = <&vmmc_reg>;
 	bus-width = <4>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
 };
 
 &sham {
-- 
1.9.0

