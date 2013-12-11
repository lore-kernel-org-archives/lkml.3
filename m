Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab3LKKWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:22:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47120 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3LKKWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:22:11 -0500
From: Nishanth Menon <nm@ti.com>
To: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/2] ARM: dts: omap2430-sdp: add flags for ethernet functionality
Date: Wed, 11 Dec 2013 04:21:45 -0600
Message-ID: <1386757305-12545-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386757305-12545-1-git-send-email-nm@ti.com>
References: <1386757305-12545-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ethernet transition from board file to dts missed the required pdata
conversion. So fix the same.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap2430-sdp.dts |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/omap2430-sdp.dts b/arch/arm/boot/dts/omap2430-sdp.dts
index 2c90d29..ec9263a 100644
--- a/arch/arm/boot/dts/omap2430-sdp.dts
+++ b/arch/arm/boot/dts/omap2430-sdp.dts
@@ -39,6 +39,11 @@
 	ranges = <5 0 0x08000000 0x01000000>;
 	ethernet@gpmc {
 		compatible = "smsc,lan91c94";
+		reg-io-width = <2>;
+		smsc,nowait;
+		smsc,leda = "100_10";
+		smsc,ledb = "TX_RX";
+
 		interrupt-parent = <&gpio5>;
 		interrupts = <21 IRQ_TYPE_LEVEL_LOW>;	/* gpio149 */
 		reg = <5 0x300 0xf>;
-- 
1.7.9.5

