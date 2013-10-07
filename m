Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3JGKrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:47:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44750 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3JGKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:47:30 -0400
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <bigeasy@linutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH] ARM: dts: omap3-beagle: Adapt USB OTG to generic PHY framework
Date: Mon, 7 Oct 2013 13:46:50 +0300
Message-ID: <1381142810-14541-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic PHY framewrok expects different properties than the
old USB PHY framework. Supply those properties.

Fixes USB OTG port on beagle after the Generic PHY framework was
merged in greg/usb-next. [1]

[1] - https://lkml.org/lkml/2013/9/27/581

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index 7669c16..fa532aa 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -173,6 +173,8 @@
 &usb_otg_hs {
 	interface-type = <0>;
 	usb-phy = <&usb2_phy>;
+	phys = <&usb2_phy>;
+	phy-names = "usb2-phy";
 	mode = <3>;
 	power = <50>;
 };
-- 
1.7.4.1

