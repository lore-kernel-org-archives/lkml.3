Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab3CISNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:13:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5565 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3CISNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:13:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 09 Mar 2013 10:13:13 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pdeschrijver@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 4/5] ARM: DT: tegra114: add KBC controller DT entry
Date: Sat, 9 Mar 2013 23:41:17 +0530
Message-ID: <1362852678-13421-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra114 SoCs have the matrix keyboard controller which
supports 11x8 type of matrix. The number of rows and columns
are configurable.

Add DT entry for KBC controller with compatibility as "nvidia,tegra114-kbc",
"nvidia,tegra20-kbc".

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Add compatible for kbc as nvidia,tegra114-kbc and nvidia,tegra20-kbc.

 arch/arm/boot/dts/tegra114.dtsi |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 300082d..21ff340 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -248,6 +248,14 @@
 		clocks = <&tegra_car 4>;
 	};
 
+	kbc {
+		compatible = "nvidia,tegra114-kbc", "nvidia,tegra20-kbc";
+		reg = <0x7000e200 0x100>;
+		interrupts = <0 85 0x04>;
+		clocks = <&tegra_car 36>;
+		status = "disabled";
+	};
+
 	pmc {
 		compatible = "nvidia,tegra114-pmc";
 		reg = <0x7000e400 0x400>;
-- 
1.7.1.1

