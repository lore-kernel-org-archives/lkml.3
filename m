Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbaGOROd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:14:33 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:57116 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbaGORCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:14 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Tony Lindgren <tony@atomide.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 43/94] ARM: dts: dra7-evm: Make VDDA_1V8_PHY supply always on
Date: Tue, 15 Jul 2014 20:00:58 +0300
Message-Id: <1405443709-15288-43-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

After clarification from the hardware team it was found that
this 1.8V PHY supply can't be switched OFF when SoC is Active.

Since the PHY IPs don't contain isolation logic built in the design to
allow the power rail to be switched off, there is a very high risk
of IP reliability and additional leakage paths which can result in
additional power consumption.

The only scenario where this rail can be switched off is part of Power on
reset sequencing, but it needs to be kept always-on during operation.

This patch is required for proper functionality of USB, SATA
and PCIe on DRA7-evm.

CC: Rajendra Nayak <rnayak@ti.com>
CC: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/boot/dts/dra7-evm.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 4adc280..8308954 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -240,6 +240,7 @@
 					regulator-name = "ldo3";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
 					regulator-boot-on;
 				};
 
-- 
1.7.10.4

