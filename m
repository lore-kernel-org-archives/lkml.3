Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaKYSyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:54:11 -0500
Received: from mail-ig0-f202.google.com ([209.85.213.202]:50886 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaKYSyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:54:08 -0500
From: Sonny Rao <sonnyrao@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dianders@chromium.org, olof@lixom.net,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kever Yang <kever.yang@rock-chips.com>, eddie.cai@rock-chips.com,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] ARM: dts: rk3288: add arm,cpu-registers-not-fw-configured
Date: Tue, 25 Nov 2014 10:54:00 -0800
Message-Id: <1416941640-324-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will enable use of physical arch timers on rk3288, where each
core comes out of reset with a different virtual offset.  Using
physical timers will help with SMP booting on coreboot and older
u-boot and should also allow suspend-resume and cpu-hotplug to work on
all firmwares.

Firmware which does initialize the cpu registers properly at boot and
cpu-hotplug can remove this property from the device tree.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 0f50d5d..c861f52 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -139,6 +139,7 @@
 
 	timer {
 		compatible = "arm,armv7-timer";
+		arm,cpu-registers-not-fw-configured;
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
 			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
-- 
2.1.2

