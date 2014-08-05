Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbaHEIOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:14:51 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3850 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbaHEIOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:14:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Aug 2014 01:05:28 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 2/3] ARM: tegra: Add PMC thermtrip programming to Jetson TK1 device tree
Date: Tue, 5 Aug 2014 11:12:59 +0300
Message-ID: <1407226380-747-3-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the required information to reset the board during an overheating
situation to the Jetson TK1 device tree. The thermal reset is handled by the
PMC by sending an I2C message to the PMIC. The entries specify the I2C
message to be sent.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 624b0fb..ee178c4 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1617,6 +1617,11 @@
 		nvidia,core-pwr-off-time = <61036>;
 		nvidia,core-power-req-active-high;
 		nvidia,sys-clock-req-active-high;
+
+		nvidia,thermtrip-pmu-i2c-addr = <0x40>;
+		nvidia,thermtrip-i2c-controller = <4>;
+		nvidia,thermtrip-reg-addr = <0x36>;
+		nvidia,thermtrip-reg-data = <0x2>;
 	};
 
 	padctl@0,7009f000 {
-- 
1.8.1.5

