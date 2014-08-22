Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaHVOGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:06:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44121 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532AbaHVOG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:06:26 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/6] ARM: dts: OMAP5: switch to compatible pinctrl
Date: Fri, 22 Aug 2014 09:03:51 -0500
Message-ID: <1408716235-26164-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716235-26164-1-git-send-email-nm@ti.com>
References: <1408716235-26164-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ti,omap5-padconf is available, switch over to that compatible
property. Retain pinctrl-single for legacy support.

While at it, mark pinctrl as interrupt controller so that it can be
used with interrupts-extended property for wakeup events.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index df0a09b..04acda6 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -188,18 +188,22 @@
 		};
 
 		omap5_pmx_core: pinmux@4a002840 {
-			compatible = "ti,omap4-padconf", "pinctrl-single";
+			compatible = "ti,omap5-padconf", "pinctrl-single";
 			reg = <0x4a002840 0x01b6>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			#interrupt-cells = <1>;
+			interrupt-controller;
 			pinctrl-single,register-width = <16>;
 			pinctrl-single,function-mask = <0x7fff>;
 		};
 		omap5_pmx_wkup: pinmux@4ae0c840 {
-			compatible = "ti,omap4-padconf", "pinctrl-single";
+			compatible = "ti,omap5-padconf", "pinctrl-single";
 			reg = <0x4ae0c840 0x0038>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			#interrupt-cells = <1>;
+			interrupt-controller;
 			pinctrl-single,register-width = <16>;
 			pinctrl-single,function-mask = <0x7fff>;
 		};
-- 
1.7.9.5

