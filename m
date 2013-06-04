Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3FDS5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:57:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8154 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FDS5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:57:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 04 Jun 2013 11:56:50 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <bhelgaas@google.com>,
        <ldewangan@nvidia.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH V3 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
Date: Wed, 5 Jun 2013 00:27:32 +0530
Message-ID: <1370372252-4332-4-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Enable PCIe controller on Cardhu
- Only port 2 is connected on this board
- Add regulators required for Tegra30

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
---
Patch is based on remotes/gitorious_thierryreding_linux/tegra/next and should be applied on top of this.

Changes in V3:
- Added num-lanes property for cardhu as per review comments

 arch/arm/boot/dts/tegra30-cardhu.dtsi |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index 8ad4841..b6270e3 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -27,6 +27,24 @@
 	model = "NVIDIA Tegra30 Cardhu evaluation board";
 	compatible = "nvidia,cardhu", "nvidia,tegra30";
 
+	pcie-controller {
+		status = "okay";
+		pex-clk-supply = <&pex_hvdd_3v3_reg>;
+		vdd-supply = <&ldo1_reg>;
+		avdd-supply = <&ldo2_reg>;
+
+		pci@1,0 {
+			nvidia,num-lanes = <4>;
+		};
+		pci@2,0 {
+			nvidia,num-lanes = <1>;
+		};
+		pci@3,0 {
+			status = "okay";
+			nvidia,num-lanes = <1>;
+		};
+	};
+
 	host1x {
 		dc@54200000 {
 			rgb {
-- 
1.7.0.4

