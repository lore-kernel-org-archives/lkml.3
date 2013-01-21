Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3AUGaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:30:55 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37429 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3AUGay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:30:54 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Cc: Sekhar Nori <nsekhar@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Heiko Schocher <hs@denx.de>
Subject: [PATCH 1/2] ARM: davinci: da850: add DT node for eth0.
Date: Mon, 21 Jan 2013 11:59:18 +0530
Message-Id: <1358749759-20517-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358749759-20517-1-git-send-email-prabhakar.lad@ti.com>
References: <1358749759-20517-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Add eth0 device tree node information to da850 by
providing interrupt details and local mac address of eth0.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: netdev@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Heiko Schocher <hs@denx.de>
---
 arch/arm/boot/dts/da850-evm.dts |    3 +++
 arch/arm/boot/dts/da850.dtsi    |   15 +++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 37dc5a3..a1d6e3e 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -24,5 +24,8 @@
 		serial2: serial@1d0d000 {
 			status = "okay";
 		};
+		eth0: emac@1e20000 {
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 640ab75..309cc99 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -56,5 +56,20 @@
 			interrupt-parent = <&intc>;
 			status = "disabled";
 		};
+		eth0: emac@1e20000 {
+			compatible = "ti,davinci-dm6467-emac";
+			reg = <0x220000 0x4000>;
+			ti,davinci-ctrl-reg-offset = <0x3000>;
+			ti,davinci-ctrl-mod-reg-offset = <0x2000>;
+			ti,davinci-ctrl-ram-offset = <0>;
+			ti,davinci-ctrl-ram-size = <0x2000>;
+			local-mac-address = [ 00 00 00 00 00 00 ];
+			interrupts = <33
+					34
+					35
+					36
+					>;
+			interrupt-parent = <&intc>;
+		};
 	};
 };
-- 
1.7.4.1

