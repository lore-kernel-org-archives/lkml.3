Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbbAFKi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:38:27 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:53336 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbbAFKiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:38:21 -0500
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
Subject: [PATCH 4/4] ARM: tegra: remove wp-gpios from the generic nyan dtsi
Date: Tue,  6 Jan 2015 11:37:29 +0100
Message-Id: <1420540653-14816-5-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the nyan-blaze has a micro-sd slot, as opposed to nyan-big, which has a full SD
slot.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 arch/arm/boot/dts/tegra124-nyan-big.dts | 4 ++++
 arch/arm/boot/dts/tegra124-nyan.dtsi    | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts b/arch/arm/boot/dts/tegra124-nyan-big.dts
index 2041077..598c090 100644
--- a/arch/arm/boot/dts/tegra124-nyan-big.dts
+++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
@@ -6,6 +6,10 @@
 	model = "Acer Chromebook 13 CB5-311";
 	compatible = "google,nyan-big", "google,nyan", "nvidia,tegra124";
 
+	sdhci@0,700b0400 { /* SD Card on this bus */
+		wp-gpios = <&gpio TEGRA_GPIO(Q, 4) GPIO_ACTIVE_LOW>;
+	};
+
 	sound {
 		nvidia,model = "Acer Chromebook 13 CB5-311";
 	};
diff --git a/arch/arm/boot/dts/tegra124-nyan.dtsi b/arch/arm/boot/dts/tegra124-nyan.dtsi
index 4c68658..12d757e 100644
--- a/arch/arm/boot/dts/tegra124-nyan.dtsi
+++ b/arch/arm/boot/dts/tegra124-nyan.dtsi
@@ -820,7 +820,6 @@
 		status = "okay";
 		cd-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_LOW>;
 		power-gpios = <&gpio TEGRA_GPIO(R, 0) GPIO_ACTIVE_HIGH>;
-		wp-gpios = <&gpio TEGRA_GPIO(Q, 4) GPIO_ACTIVE_LOW>;
 		bus-width = <4>;
 		no-1-8-v;
 		vqmmc-supply = <&vddio_sdmmc3>;
-- 
1.9.3

