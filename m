Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaDOBno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:43:44 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:61006 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaDOBmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:42:55 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 4/4] ARM: tegra: fix Venice2 VQMMC regulators
Date: Mon, 14 Apr 2014 18:42:43 -0700
Message-Id: <1397526163-20126-5-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VDDIO_SDMMC3 is the VQMMC supply, not the VMMC supply, for the SD
slot.  Add 1.8V_VDDIO as the VQMMC supply for the eMMC.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/arm/boot/dts/tegra124-venice2.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index c17283c..53061ef 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -933,12 +933,13 @@
 		power-gpios = <&gpio TEGRA_GPIO(R, 0) GPIO_ACTIVE_HIGH>;
 		status = "okay";
 		bus-width = <4>;
-		vmmc-supply = <&vddio_sdmmc3>;
+		vqmmc-supply = <&vddio_sdmmc3>;
 	};
 
 	sdhci@0,700b0600 {
 		status = "okay";
 		bus-width = <8>;
+		vqmmc-supply = <&vddio_1v8>;
 	};
 
 	ahub@0,70300000 {
-- 
1.9.1.423.g4596e3a

