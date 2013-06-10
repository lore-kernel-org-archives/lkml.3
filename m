Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3FJV1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:27:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2808 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3FJV1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:27:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 10 Jun 2013 14:25:39 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, Stephen Warren <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 4/4] arm: tegra: Add power-supplies link between battery and charger
Date: Mon, 10 Jun 2013 17:26:42 -0400
Message-ID: <1370899602-22123-5-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370899602-22123-1-git-send-email-rklein@nvidia.com>
References: <1370899602-22123-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power supply core now supports detecting linkages between batteries
and chargers through the use of the power-supplies property. Adding
this to the battery, the core will use the phandle list to find
the associated charger and pair them up. This facilitates notifications
from the charger to the battery when ac power is dissconnected
or connected for instance.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index cfeb0f5..b92922f 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -727,6 +727,7 @@
 			battery-name = "battery";
 			sbs,i2c-retry-count = <2>;
 			sbs,poll-retry-count = <100>;
+			power-supplies = <&charger>;
 		};
 	};
 
@@ -763,7 +764,7 @@
 			vsys-l1-supply = <&vdd_ac_bat_reg>;
 			vsys-l2-supply = <&vdd_ac_bat_reg>;
 
-			charger {
+			charger: charger {
 				compatible = "ti,tps65090-charger";
 				ti,enable-low-current-chrg;
 			};
-- 
1.7.9.5

