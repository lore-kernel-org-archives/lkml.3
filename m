Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbaLLPfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:35:44 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59213 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbaLLPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:35:41 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com
Cc: stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: tegra20: fix GR3D, DSI unit and reg base addresses
Date: Fri, 12 Dec 2014 18:19:19 +0300
Message-Id: <1418397559-19646-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 58ecb23f64ee ("ARM: tegra: add missing unit addresses to DT") added
unit address and changed reg base for GR3D and DSI host1x modules, but these
addresses belongs to GR2D and TVO modules respectively. Fix it by changing
modules unit and reg base addresses to proper ones.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Fixes: 58ecb23f64ee (ARM: tegra: add missing unit addresses to DT)
Cc: <stable@vger.kernel.org> # v3.13+
---
 arch/arm/boot/dts/tegra20.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 8acf5d8..f76fe94 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -68,9 +68,9 @@
 			reset-names = "2d";
 		};
 
-		gr3d@54140000 {
+		gr3d@54180000 {
 			compatible = "nvidia,tegra20-gr3d";
-			reg = <0x54140000 0x00040000>;
+			reg = <0x54180000 0x00040000>;
 			clocks = <&tegra_car TEGRA20_CLK_GR3D>;
 			resets = <&tegra_car 24>;
 			reset-names = "3d";
@@ -130,9 +130,9 @@
 			status = "disabled";
 		};
 
-		dsi@542c0000 {
+		dsi@54300000 {
 			compatible = "nvidia,tegra20-dsi";
-			reg = <0x542c0000 0x00040000>;
+			reg = <0x54300000 0x00040000>;
 			clocks = <&tegra_car TEGRA20_CLK_DSI>;
 			resets = <&tegra_car 48>;
 			reset-names = "dsi";
-- 
2.2.0

