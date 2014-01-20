Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaATOPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:15:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46764 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaATOMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:12:47 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <lee.jones@linaro.org>, <arnd@arndb.de>, <sre@debian.org>,
        <mark.rutland@arm.com>, <m.paolino@virtualopensystems.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v6 06/10] ARM: dts: omap4: Update omap-usb-host node
Date: Mon, 20 Jan 2014 16:11:27 +0200
Message-ID: <1390227091-4523-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390227091-4523-1-git-send-email-rogerq@ti.com>
References: <1390227091-4523-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap-usb-host driver expects a certain name for internal
and external reference clocks. Provide these clocks.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index d3f8a6e..39a05ce 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -697,6 +697,12 @@
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
+			clocks = <&init_60m_fclk>,
+				 <&xclk60mhsp1_ck>,
+				 <&xclk60mhsp2_ck>;
+			clock-names = "refclk_60m_int",
+				      "refclk_60m_ext_p1",
+				      "refclk_60m_ext_p2";
 
 			usbhsohci: ohci@4a064800 {
 				compatible = "ti,ohci-omap3", "usb-ohci";
-- 
1.8.3.2

