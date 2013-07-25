Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3GYRzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:55:01 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:40696 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3GYRyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:54:55 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jay Agarwal <jagarwal@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 12/16] ARM: tegra: Enable PCIe controller on Beaver
Date: Thu, 25 Jul 2013 10:53:26 -0700
Message-Id: <1374774810-18459-13-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
References: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCIe lane 0 is connected to an onboard Gigabit Ethernet (RTL8168evl) and
lane 4 is routed to the board's miniPCIe slot.

Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/boot/dts/tegra30-beaver.dts | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/tegra30-beaver.dts
index 87c5f7b..4d9fa31 100644
--- a/arch/arm/boot/dts/tegra30-beaver.dts
+++ b/arch/arm/boot/dts/tegra30-beaver.dts
@@ -10,6 +10,27 @@
 		reg = <0x80000000 0x7ff00000>;
 	};
 
+	pcie-controller {
+		status = "okay";
+		pex-clk-supply = <&sys_3v3_pexs_reg>;
+		vdd-supply = <&ldo1_reg>;
+		avdd-supply = <&ldo2_reg>;
+
+		pci@1,0 {
+			status = "okay";
+			nvidia,num-lanes = <4>;
+		};
+
+		pci@2,0 {
+			status = "okay";
+			nvidia,num-lanes = <1>;
+		};
+
+		pci@3,0 {
+			nvidia,num-lanes = <1>;
+		};
+	};
+
 	pinmux {
 		pinctrl-names = "default";
 		pinctrl-0 = <&state_default>;
-- 
1.8.1.5

