Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbaHVOGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:06:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33570 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbaHVOG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 6/6] ARM: dts: dra7-evm: Mark uart1 rxd as wakeup capable
Date: Fri, 22 Aug 2014 09:03:55 -0500
Message-ID: <1408716235-26164-7-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716235-26164-1-git-send-email-nm@ti.com>
References: <1408716235-26164-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark rxd as wakeupcapable for 115200n8 no hardware-flow control
configuration. If h/w flow control is being used, then rts/cts
appropriately should be used.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 50f8022..a329177 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -303,6 +303,8 @@
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart1_pins>;
+	interrupts-extended = <&gic GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH
+			       &dra7_pmx_core 0x3e0>;
 };
 
 &uart2 {
-- 
1.7.9.5

