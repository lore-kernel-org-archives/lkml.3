Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3EHK7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:59:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6239 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3EHK7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:59:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 08 May 2013 03:55:59 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <ldewangan@nvidia.com>,
        <bhelgaas@google.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH 3/4] ARM: dts: tegra: Correct PCIe entry
Date: Wed, 8 May 2013 16:27:39 +0530
Message-ID: <1368010660-31465-3-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com>
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add interrupt-names property
- Correct downstream I/O size
- Correct cml clock name for Tegra30
- Patch is based on remotes/gitorious_thierryreding_linux/tegra/next
- and should be applied on top of this.

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
---
 arch/arm/boot/dts/tegra30.dtsi |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 5a270ff..289ef93 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -124,7 +124,7 @@
 		reg-names = "pads", "afi", "cs";
 		interrupts = <0 98 0x04   /* controller interrupt */
 		              0 99 0x04>; /* MSI interrupt */
-
+		interrupt-names = "intr", "msi";
 		bus-range = <0x00 0xff>;
 		#address-cells = <3>;
 		#size-cells = <2>;
@@ -132,13 +132,13 @@
 		ranges = <0x82000000 0 0x00000000 0x00000000 0 0x00001000   /* port 0 configuration space */
 			  0x82000000 0 0x00001000 0x00001000 0 0x00001000   /* port 1 configuration space */
 			  0x82000000 0 0x00004000 0x00004000 0 0x00001000   /* port 2 configuration space */
-			  0x81000000 0 0          0x02000000 0 0x00010000   /* downstream I/O */
+			  0x81000000 0 0          0x02000000 0 0x00100000   /* downstream I/O */
 			  0x82000000 0 0x20000000 0x20000000 0 0x10000000   /* non-prefetchable memory */
 			  0xc2000000 0 0x30000000 0x30000000 0 0x10000000>; /* prefetchable memory */
 
 		clocks = <&tegra_car 70>, <&tegra_car 72>, <&tegra_car 74>,
 			 <&tegra_car 118>, <&tegra_car 215>;
-		clock-names = "pex", "afi", "pcie_xclk", "pll_e", "cml";
+		clock-names = "pex", "afi", "pcie_xclk", "pll_e", "cml0";
 		status = "disabled";
 
 		pci@1,0 {
-- 
1.7.0.4

