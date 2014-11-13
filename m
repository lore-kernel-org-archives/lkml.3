Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaKME73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 23:59:29 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12641 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaKME72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 23:59:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 12 Nov 2014 20:59:37 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: roth: Fix SD card VDD_IO regulator
Date: Thu, 13 Nov 2014 13:59:03 +0900
Message-ID: <1415854743-11670-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415854743-11670-1-git-send-email-acourbot@nvidia.com>
References: <1415854743-11670-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vddio_sdmmc3 is a vdd_io, and thus should be under the vqmmc-supply
property, not vmmc-supply.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra114-roth.dts | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-roth.dts b/arch/arm/boot/dts/tegra114-roth.dts
index 1f6eaba92f67..10f42553831f 100644
--- a/arch/arm/boot/dts/tegra114-roth.dts
+++ b/arch/arm/boot/dts/tegra114-roth.dts
@@ -916,8 +916,6 @@
 						regulator-name = "vddio-sdmmc3";
 						regulator-min-microvolt = <1800000>;
 						regulator-max-microvolt = <3300000>;
-						regulator-always-on;
-						regulator-boot-on;
 					};
 
 					ldousb {
@@ -962,7 +960,7 @@
 	sdhci@78000400 {
 		status = "okay";
 		bus-width = <4>;
-		vmmc-supply = <&vddio_sdmmc3>;
+		vqmmc-supply = <&vddio_sdmmc3>;
 		cd-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_LOW>;
 		power-gpios = <&gpio TEGRA_GPIO(H, 0) GPIO_ACTIVE_HIGH>;
 	};
-- 
2.1.3

