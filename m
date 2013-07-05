Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3GEMiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:38:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16898 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab3GEMiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:38:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 05 Jul 2013 05:37:09 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: enable gpio-keys on dalmore
Date: Fri, 5 Jul 2013 18:11:51 +0530
Message-ID: <1373028111-24246-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dalmore have the keys mounted on board which are connected
to different pins of Tegra.

Add the keys entry in DTS file to enable key functionality.
This will enable KEY_POWER, KEY_HOME, KEY_VOLUMEUP and
KEY_VOLUMEDOWN.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index cb640eb..886b66d 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -976,4 +976,33 @@
 			 <&tegra_car TEGRA114_CLK_EXTERN1>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		power {
+			label = "Power";
+			gpios = <&gpio TEGRA_GPIO(Q, 0) GPIO_ACTIVE_LOW>;
+			linux,code = <116>; /* KEY_POWER */
+			gpio-key,wakeup;
+		};
+
+		home {
+			label = "Home";
+			gpios = <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_LOW>;
+			linux,code = <102>; /* KEY_HOME */
+		};
+
+		volume_up {
+			label = "VolumeUp";
+			gpios = <&gpio TEGRA_GPIO(R, 2) GPIO_ACTIVE_LOW>;
+			linux,code = <115>; /* KEY_VOLUMEUP */
+		};
+
+		volume_down {
+			label = "VolumeDown";
+			gpios = <&gpio TEGRA_GPIO(R, 1) GPIO_ACTIVE_LOW>;
+			linux,code = <114>; /* KEY_VOLUMEDOWN */
+		};
+	};
 };
-- 
1.7.1.1

