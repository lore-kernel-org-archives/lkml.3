Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161484AbaDPXJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:09:13 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:61455 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbaDPXJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:09:06 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 3/3] ARM: tegra: fix Venice2 SD card VQMMC supply
Date: Wed, 16 Apr 2014 16:08:39 -0700
Message-Id: <1397689719-28882-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397689719-28882-1-git-send-email-abrestic@chromium.org>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
 <1397689719-28882-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VDDIO_SDMMC3 is the VQMMC (I/O) supply, not the VMMC (core) supply,
for the SD slot on Venice2.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v1:
 - removed vqmmc supply for eMMC
---
 arch/arm/boot/dts/tegra124-venice2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index c17283c..91b5916 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -933,7 +933,7 @@
 		power-gpios = <&gpio TEGRA_GPIO(R, 0) GPIO_ACTIVE_HIGH>;
 		status = "okay";
 		bus-width = <4>;
-		vmmc-supply = <&vddio_sdmmc3>;
+		vqmmc-supply = <&vddio_sdmmc3>;
 	};
 
 	sdhci@0,700b0600 {
-- 
1.9.1.423.g4596e3a

