Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3CTNtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:49:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9966 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3CTNsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:48:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Mar 2013 06:47:53 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/4] ARM: tegra: dalmore: add cpu regulator's node
Date: Wed, 20 Mar 2013 19:14:28 +0530
Message-ID: <1363787070-14801-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1363787070-14801-1-git-send-email-ldewangan@nvidia.com>
References: <1363787070-14801-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dalmore uses the TPS51632 as cpu regulator. This device
is connected on I2C5.

Add dt node for this device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index a61974e..6be9434 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -718,6 +718,21 @@
 		clock-frequency = <408000000>;
 	};
 
+	i2c@7000d000 {
+		status = "okay";
+		clock-frequency = <400000>;
+
+		tps51632 {
+			compatible = "ti,tps51632";
+			reg = <0x43>;
+			regulator-name = "vdd-cpu";
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1520000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+	};
+
 	pmc {
 		nvidia,invert-interrupt;
 	};
-- 
1.7.1.1

