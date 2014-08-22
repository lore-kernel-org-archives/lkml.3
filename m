Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaHVOGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:06:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58904 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544AbaHVOG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:06:28 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 4/6] ARM: dts: AM437x: switch to compatible pinctrl
Date: Fri, 22 Aug 2014 09:03:53 -0500
Message-ID: <1408716235-26164-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716235-26164-1-git-send-email-nm@ti.com>
References: <1408716235-26164-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ti,am437-padconf is available, switch over to that compatible
property. Retain pinctrl-single for legacy support.

While at it, mark the pinctrl as interrupt controller so that it can
be used with interrupts-extended property for wakeup events.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 9b3d2ba..b384830 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -58,10 +58,12 @@
 	};
 
 	am43xx_pinmux: pinmux@44e10800 {
-		compatible = "pinctrl-single";
+		compatible = "ti,am437-padconf", "pinctrl-single";
 		reg = <0x44e10800 0x31c>;
 		#address-cells = <1>;
 		#size-cells = <0>;
+		#interrupt-cells = <1>;
+		interrupt-controller;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;
 	};
-- 
1.7.9.5

