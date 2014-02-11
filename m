Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaBKULm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:11:42 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:48314 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaBKULj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:11:39 -0500
From: Stefan Agner <stefan@agner.ch>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, josephl@nvidia.com
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH] ARM: tegra: dalmore: fix irq trigger type
Date: Tue, 11 Feb 2014 21:11:32 +0100
Message-Id: <4fcfcfdbc86c37c6d47ec32cdbd987f3b406e9b5.1392147256.git.stefan@agner.ch>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trigger type needs to be IRQ_TYPE_LEVEL_HIGH since the interrupt
signal gets inverted by the PMC (configured by the invert-interrupt
property).

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
I could not test that patch since I don't have such hardware.
However, I stumbled on that error while tracing a similar error
on Colibri T30.

 arch/arm/boot/dts/tegra114-dalmore.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 73aecfb..f5025fc 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -888,8 +888,9 @@
 		palmas: tps65913@58 {
 			compatible = "ti,palmas";
 			reg = <0x58>;
-			interrupts = <0 86 IRQ_TYPE_LEVEL_LOW>;
 
+			/* active-low configured by PMC invert-interrupt */
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 			#interrupt-cells = <2>;
 			interrupt-controller;
 
-- 
1.8.5.4

