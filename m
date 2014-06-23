Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaFWHdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:33:44 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8796 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaFWHdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:33:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 23 Jun 2014 00:27:41 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: roth: fix unsupported pinmux properties
Date: Mon, 23 Jun 2014 16:32:58 +0900
Message-ID: <1403508779-25896-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403508779-25896-1-git-send-email-acourbot@nvidia.com>
References: <1403508779-25896-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pinmux subsystem complained that the nvidia,low-power-mode property
is not supported by the sdio1, sdio3 and gma drive groups. In addition
gma also does not support nvidia,drive-type. Remove these properties so
the pinmux configuration can properly be applied.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra114-roth.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-roth.dts b/arch/arm/boot/dts/tegra114-roth.dts
index 0b0e8e07d965..a67885250f81 100644
--- a/arch/arm/boot/dts/tegra114-roth.dts
+++ b/arch/arm/boot/dts/tegra114-roth.dts
@@ -730,7 +730,6 @@
 				nvidia,pins = "drive_sdio1";
 				nvidia,high-speed-mode = <TEGRA_PIN_ENABLE>;
 				nvidia,schmitt = <TEGRA_PIN_DISABLE>;
-				nvidia,low-power-mode = <TEGRA_PIN_LP_DRIVE_DIV_1>;
 				nvidia,pull-down-strength = <36>;
 				nvidia,pull-up-strength = <20>;
 				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_SLOW>;
@@ -740,7 +739,6 @@
 				nvidia,pins = "drive_sdio3";
 				nvidia,high-speed-mode = <TEGRA_PIN_ENABLE>;
 				nvidia,schmitt = <TEGRA_PIN_DISABLE>;
-				nvidia,low-power-mode = <TEGRA_PIN_LP_DRIVE_DIV_1>;
 				nvidia,pull-down-strength = <36>;
 				nvidia,pull-up-strength = <20>;
 				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_FASTEST>;
@@ -750,12 +748,10 @@
 				nvidia,pins = "drive_gma";
 				nvidia,high-speed-mode = <TEGRA_PIN_ENABLE>;
 				nvidia,schmitt = <TEGRA_PIN_DISABLE>;
-				nvidia,low-power-mode = <TEGRA_PIN_LP_DRIVE_DIV_1>;
 				nvidia,pull-down-strength = <2>;
 				nvidia,pull-up-strength = <2>;
 				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_FASTEST>;
 				nvidia,slew-rate-falling = <TEGRA_PIN_SLEW_RATE_FASTEST>;
-				nvidia,drive-type = <1>;
 			};
 		};
 	};
-- 
2.0.0

