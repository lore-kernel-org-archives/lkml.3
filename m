Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3AVVLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:11:02 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:33518 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3AVVK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:10:58 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH v3 3/3] arm: mvebu: enable gpio expander over i2c on Mirabox platform
Date: Tue, 22 Jan 2013 22:10:25 +0100
Message-Id: <1358889025-8530-4-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com>
References: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Globalscale Mirabox platform can be connected to the JTAG/GPIO box
through the Multi-IO port. The GPIO box use the NXP PCA9505 I/O port
expansion IC to provide 40-bit parallel input/output GPIOs. This patch
enable the use of this expander on the Mirabox.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/armada-370-mirabox.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370-mirabox.dts b/arch/arm/boot/dts/armada-370-mirabox.dts
index 3b40713..d9b32d3 100644
--- a/arch/arm/boot/dts/armada-370-mirabox.dts
+++ b/arch/arm/boot/dts/armada-370-mirabox.dts
@@ -52,5 +52,15 @@
 			phy = <&phy1>;
 			phy-mode = "rgmii-id";
 		};
+		i2c@d0011000 {
+			status = "okay";
+			clock-frequency = <100000>;
+			pca9505: pca9505@25 {
+				compatible = "nxp,pca9505";
+				gpio-controller;
+				#gpio-cells = <2>;
+				reg = <0x25>;
+			};
+		};
 	};
 };
-- 
1.7.9.5

