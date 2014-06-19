Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaFSLwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:52:45 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14535 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaFSLwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:52:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Jun 2014 04:43:15 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <pdeschrijver@nvidia.com>, <rui.zhang@intel.com>,
        <edubezval@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <mikko.perttunen@kapsi.fi>,
        <mlongnecker@nvidia.com>, <dtundlam@nvidia.com>, <talho@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [RFC 1/5] ARM: tegra: Add PMC thermtrip programming to Jetson TK1 device tree
Date: Thu, 19 Jun 2014 14:50:36 +0300
Message-ID: <1403178640-16052-2-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403178640-16052-1-git-send-email-mperttunen@nvidia.com>
References: <1403178640-16052-1-git-send-email-mperttunen@nvidia.com>
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
index 16082c0..896c24b 100644
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
 
 	/* SD card */
-- 
1.8.1.5

