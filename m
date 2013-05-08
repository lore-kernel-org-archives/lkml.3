Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3EHK7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:59:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17672 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3EHK7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:59:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 08 May 2013 03:59:18 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <ldewangan@nvidia.com>,
        <bhelgaas@google.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
Date: Wed, 8 May 2013 16:27:40 +0530
Message-ID: <1368010660-31465-4-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com>
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Enable PCIe controller on Cardhu
- Only port 2 is connected on this board
- Add regulators required for Tegra30
- Patch is based on remotes/gitorious_thierryreding_linux/tegra/next
- and should be applied on top of this.

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
---
 arch/arm/boot/dts/tegra30-cardhu.dtsi |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index d2fdf95..8f8e07b 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -27,6 +27,17 @@
 	model = "NVIDIA Tegra30 Cardhu evaluation board";
 	compatible = "nvidia,cardhu", "nvidia,tegra30";
 
+	pcie-controller {
+		status = "okay";
+		pex-clk-supply = <&pex_hvdd_3v3_reg>;
+		vdd-supply = <&ldo1_reg>;
+		avdd-supply = <&ldo2_reg>;
+
+		pci@3,0 {
+			status = "okay";
+		};
+	};
+
 	host1x {
 		dc@54200000 {
 			rgb {
-- 
1.7.0.4

