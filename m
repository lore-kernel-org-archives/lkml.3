Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaFZUvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:51:48 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33123 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaFZUuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:50:10 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 07/10] ARM: tegra: tegra124: Enable IOMMU for SDMMC controllers
Date: Thu, 26 Jun 2014 22:49:47 +0200
Message-Id: <1403815790-8548-8-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The SDMMC controllers can use the IOMMU to avoid the need for bounce
buffers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/boot/dts/tegra124.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 82751d2878c4..bfffb4c102fb 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -607,6 +607,7 @@
 		resets = <&tegra_car 14>;
 		reset-names = "sdhci";
 		status = "disabled";
+		iommus = <&mc TEGRA_SWGROUP_SDMMC1A>;
 	};
 
 	sdhci@0,700b0200 {
@@ -618,6 +619,7 @@
 		resets = <&tegra_car 9>;
 		reset-names = "sdhci";
 		status = "disabled";
+		iommus = <&mc TEGRA_SWGROUP_SDMMC2A>;
 	};
 
 	sdhci@0,700b0400 {
@@ -629,6 +631,7 @@
 		resets = <&tegra_car 69>;
 		reset-names = "sdhci";
 		status = "disabled";
+		iommus = <&mc TEGRA_SWGROUP_SDMMC3A>;
 	};
 
 	sdhci@0,700b0600 {
@@ -640,6 +643,7 @@
 		resets = <&tegra_car 15>;
 		reset-names = "sdhci";
 		status = "disabled";
+		iommus = <&mc TEGRA_SWGROUP_SDMMC4A>;
 	};
 
 	ahub@0,70300000 {
-- 
2.0.0

