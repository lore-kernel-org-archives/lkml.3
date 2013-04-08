Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965228Ab3DHPk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:40:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13658 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760355Ab3DHPkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:40:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 08 Apr 2013 08:40:11 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <ldewangan@nvidia.com>,
        <bhelgaas@google.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH 3/3] ARM: dts: tegra: Add PCIe entry for cardhu
Date: Mon, 8 Apr 2013 21:11:28 +0530
Message-ID: <1365435688-4179-3-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>

- Add PCIe node entry for cardhu
- Enable only root port 2
- Initialize regulators required for tegra30
- Based on git://gitorious.org/thierryreding/linux.git

 arch/arm/boot/dts/tegra30-cardhu.dtsi |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index d2fdf95..b64113e 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -137,6 +137,17 @@
 		};
 	};
 
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
 	serial@70006000 {
 		status = "okay";
 	};
-- 
1.7.0.4

