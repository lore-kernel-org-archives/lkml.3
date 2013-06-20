Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3FTHKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:10:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8349 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3FTHK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:10:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 20 Jun 2013 00:08:20 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <bhelgaas@google.com>,
        <ldewangan@nvidia.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH V1] ARM: dts: tegra: Modify pcie memory space size
Date: Thu, 20 Jun 2013 12:44:51 +0530
Message-ID: <1371712491-31070-1-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- decrease non-prefetch memory size to 128 MB
- increase prefetch memory size to 384 MB
- above change is done because most pcie devices
  prefetch memory size requirement is quite higher
  compared to non-prefetch memory space.

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
---
Patch is based on remotes/gitorious_thierryreding_linux/tegra/next and should be applied on top of this

 arch/arm/boot/dts/tegra20.dtsi |    4 ++--
 arch/arm/boot/dts/tegra30.dtsi |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index fd2a7e1..e09e97f 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -483,8 +483,8 @@
 		ranges = <0x82000000 0 0x80000000 0x80000000 0 0x00001000   /* port 0 registers */
 			  0x82000000 0 0x80001000 0x80001000 0 0x00001000   /* port 1 registers */
 			  0x81000000 0 0          0x82000000 0 0x00010000   /* downstream I/O */
-			  0x82000000 0 0xa0000000 0xa0000000 0 0x10000000   /* non-prefetchable memory */
-			  0xc2000000 0 0xb0000000 0xb0000000 0 0x10000000>; /* prefetchable memory */
+			  0x82000000 0 0xa0000000 0xa0000000 0 0x08000000   /* non-prefetchable memory */
+			  0xc2000000 0 0xa8000000 0xa8000000 0 0x18000000>; /* prefetchable memory */
 
 		clocks = <&tegra_car 70>, <&tegra_car 72>, <&tegra_car 74>,
 			 <&tegra_car 118>;
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index e0b96bd..b02bbb4 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -35,8 +35,8 @@
 			  0x82000000 0 0x00001000 0x00001000 0 0x00001000   /* port 1 configuration space */
 			  0x82000000 0 0x00004000 0x00004000 0 0x00001000   /* port 2 configuration space */
 			  0x81000000 0 0          0x02000000 0 0x00010000   /* downstream I/O */
-			  0x82000000 0 0x20000000 0x20000000 0 0x10000000   /* non-prefetchable memory */
-			  0xc2000000 0 0x30000000 0x30000000 0 0x10000000>; /* prefetchable memory */
+			  0x82000000 0 0x20000000 0x20000000 0 0x08000000   /* non-prefetchable memory */
+			  0xc2000000 0 0x28000000 0x28000000 0 0x18000000>; /* prefetchable memory */
 
 		clocks = <&tegra_car 70>, <&tegra_car 72>, <&tegra_car 74>,
 			 <&tegra_car 118>, <&tegra_car 215>;
-- 
1.7.0.4

