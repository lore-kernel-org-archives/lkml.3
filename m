Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161208Ab3LFSHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:07:30 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:38822 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161126Ab3LFSHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:07:25 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 06/10] ARM: dts: sun7i: Add pin muxing options for the GMAC
Date: Sat,  7 Dec 2013 01:29:39 +0800
Message-Id: <1386350983-13281-7-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386350983-13281-1-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A20 has EMAC and GMAC muxed on the same pins.
Add pin sets with gmac function for MII and RGMII mode to the DTSI.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index ebb2cce..64b1391 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -246,6 +246,28 @@
 				allwinner,drive = <0>;
 				allwinner,pull = <0>;
 			};
+
+			gmac_pins_mii: gmac_mii {
+				allwinner,pins = "PA0", "PA1", "PA2",
+						"PA3", "PA4", "PA5", "PA6",
+						"PA7", "PA8", "PA9", "PA10",
+						"PA11", "PA12", "PA13", "PA14",
+						"PA15", "PA16";
+				allwinner,function = "gmac";
+				allwinner,drive = <3>;
+				allwinner,pull = <0>;
+			};
+
+			gmac_pins_rgmii: gmac_rgmii {
+				allwinner,pins = "PA0", "PA1", "PA2",
+						"PA3", "PA4", "PA5", "PA6",
+						"PA7", "PA8", "PA10",
+						"PA11", "PA12", "PA13",
+						"PA15", "PA16";
+				allwinner,function = "gmac";
+				allwinner,drive = <3>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {
-- 
1.8.5.1

