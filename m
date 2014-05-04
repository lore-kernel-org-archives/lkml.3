Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaEDQYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:24:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbaEDPmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.14 154/158] ARM: tegra: remove UART5/UARTE from tegra124.dtsi
Date: Sun,  4 May 2014 11:41:03 -0400
Message-Id: <20140504154050.938613338@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 862f0eea38409ff0d7f226c1245b787e3f0e2607 upstream.

Tegra124 only has 4 UARTs. Parts of the documentation hint at a fifth
UART, but this appears to be left-over from earlier SoC documentation.
Remove the non-existent DT node for UART5.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/tegra124.dtsi |   13 -------------
 1 file changed, 13 deletions(-)

--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -164,19 +164,6 @@
 		status = "disabled";
 	};
 
-	serial@70006400 {
-		compatible = "nvidia,tegra124-uart", "nvidia,tegra20-uart";
-		reg = <0x70006400 0x40>;
-		reg-shift = <2>;
-		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car TEGRA124_CLK_UARTE>;
-		resets = <&tegra_car 66>;
-		reset-names = "serial";
-		dmas = <&apbdma 20>, <&apbdma 20>;
-		dma-names = "rx", "tx";
-		status = "disabled";
-	};
-
 	pwm@7000a000 {
 		compatible = "nvidia,tegra124-pwm", "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;


