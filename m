Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbbAFKiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:38:15 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50123 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbbAFKiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:38:09 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ARM: tegra: rely on bootloader pinmux programming on nyan-big
Date: Tue,  6 Jan 2015 11:37:26 +0100
Message-Id: <1420540653-14816-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following 6dbaff2b, the kernel expects that the bootloader has correctly
programmed the Tegra pinmux.

DTs for the Jetson and the Venice2 had been updated already but this one
was left behind.

Have tested this with the stock vendor firmware (coreboot) and have found no
issues.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 arch/arm/boot/dts/tegra124-nyan-big.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts b/arch/arm/boot/dts/tegra124-nyan-big.dts
index 53181d3..4752572 100644
--- a/arch/arm/boot/dts/tegra124-nyan-big.dts
+++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
@@ -44,10 +44,10 @@
 	};
 
 	pinmux@0,70000868 {
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinmux_default>;
+		pinctrl-names = "boot";
+		pinctrl-0 = <&pinmux_boot>;
 
-		pinmux_default: common {
+		pinmux_boot: common {
 			dap_mclk1_pw4 {
 				nvidia,pins = "dap_mclk1_pw4";
 				nvidia,function = "extperiph1";
-- 
1.9.3

