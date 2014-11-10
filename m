Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaKJNNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:13:19 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:48313 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbaKJNNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:13:16 -0500
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v4 REPOST 4/5] ARM: tegra: Add PMC thermtrip programming to Jetson TK1 device tree
Date: Mon, 10 Nov 2014 15:12:16 +0200
Message-Id: <1415625137-4791-5-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415625137-4791-1-git-send-email-mikko.perttunen@kapsi.fi>
References: <1415625137-4791-1-git-send-email-mikko.perttunen@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

This adds the required information to reset the board during an overheating
situation to the Jetson TK1 device tree. The thermal reset is handled by the
PMC by sending an I2C message to the PMIC. The entries specify the I2C
message to be sent.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Reviewed-by: Wei Ni <wni@nvidia.com>
Tested-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index f46a789..57ead69 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1457,7 +1457,7 @@
 	};
 
 	/* Expansion PWR_I2C_*, on-board components */
-	i2c@0,7000d000 {
+	pmic_bus: i2c@0,7000d000 {
 		status = "okay";
 		clock-frequency = <400000>;
 
@@ -1672,6 +1672,13 @@
 		nvidia,core-pwr-off-time = <61036>;
 		nvidia,core-power-req-active-high;
 		nvidia,sys-clock-req-active-high;
+
+		i2c-thermtrip {
+			nvidia,i2c-bus = <&pmic_bus>;
+			nvidia,bus-addr = <0x40>;
+			nvidia,reg-addr = <0x36>;
+			nvidia,reg-data = <0x2>;
+		};
 	};
 
 	/* Serial ATA */
-- 
2.1.3

