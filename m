Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3H1JeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:34:14 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:54002 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab3H1JeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:34:12 -0400
Date: Wed, 28 Aug 2013 11:34:59 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
Message-ID: <20130828113459.48ecbb34@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the nodes to instantiate the audio devices of the Dove
boards.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 arch/arm/boot/dts/dove.dtsi                  | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 499abad..78227e2 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -573,6 +573,24 @@
 					phy-handle = <&ethphy>;
 				};
 			};
+
+			i2s0: audio-controller@b0000 {
+				compatible = "marvell,mvebu-audio";
+				reg = <0xb0000 0x2210>;
+				interrupts = <19>, <20>;
+				clocks = <&gate_clk 12>;
+				clock-names = "internal";
+				status = "disabled";
+			};
+
+			i2s1: audio-controller@b4000 {
+				compatible = "marvell,mvebu-audio";
+				reg = <0xb4000 0x2210>;
+				interrupts = <21>, <22>;
+				clocks = <&gate_clk 13>;
+				clock-names = "internal";
+				status = "disabled";
+			};
 		};
 	};
 };


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
