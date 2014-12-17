Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaLQStb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:49:31 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:41113 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaLQStZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:49:25 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-pm@vger.kernel.org
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5/8] ARM: shmobile: sh73a0 dtsi: Add Bus State Controller node
Date: Wed, 17 Dec 2014 19:49:10 +0100
Message-Id: <1418842153-17113-6-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
References: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a node for the Bus State Controller (BSC) on sh73a0, to which
multiple external devices can be connected.

The BSC is driven by the ZB clock, and located in PM domain A4S.
A reference to the latter will be added later.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - Postpone power-domains
---
 arch/arm/boot/dts/sh73a0.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sh73a0.dtsi b/arch/arm/boot/dts/sh73a0.dtsi
index b60d0456fc7a0c00..8989b63d6993adb9 100644
--- a/arch/arm/boot/dts/sh73a0.dtsi
+++ b/arch/arm/boot/dts/sh73a0.dtsi
@@ -357,6 +357,16 @@
 		status = "disabled";
 	};
 
+	bsc: bus@fec10000 {
+		compatible = "renesas,bsc-sh73a0", "renesas,bsc", "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0xfec10000 0x400>;
+		ranges = <0 0 0x20000000>;
+		interrupts = <0 39 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&zb_clk>;
+	};
+
 	clocks {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.9.1

