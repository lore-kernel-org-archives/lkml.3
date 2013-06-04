Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3FDS5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:57:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8144 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3FDS5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:57:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 04 Jun 2013 11:56:44 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <bhelgaas@google.com>,
        <ldewangan@nvidia.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH V3 3/4] ARM: dts: tegra: Correct PCIe entry
Date: Wed, 5 Jun 2013 00:27:31 +0530
Message-ID: <1370372252-4332-3-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add interrupt-names property
- Correct downstream I/O size

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
---
Patch is based on remotes/gitorious_thierryreding_linux/tegra/next and should be applied on top of this.

Changes in V3:
- Avoided changes in cml clock as per review comment

 arch/arm/boot/dts/tegra30.dtsi |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index a242b2e..a301389 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -21,7 +21,7 @@
 		reg-names = "pads", "afi", "cs";
 		interrupts = <0 98 0x04   /* controller interrupt */
 		              0 99 0x04>; /* MSI interrupt */
-
+		interrupt-names = "intr", "msi";
 		bus-range = <0x00 0xff>;
 		#address-cells = <3>;
 		#size-cells = <2>;
@@ -29,7 +29,7 @@
 		ranges = <0x82000000 0 0x00000000 0x00000000 0 0x00001000   /* port 0 configuration space */
 			  0x82000000 0 0x00001000 0x00001000 0 0x00001000   /* port 1 configuration space */
 			  0x82000000 0 0x00004000 0x00004000 0 0x00001000   /* port 2 configuration space */
-			  0x81000000 0 0          0x02000000 0 0x00010000   /* downstream I/O */
+			  0x81000000 0 0          0x02000000 0 0x00100000   /* downstream I/O */
 			  0x82000000 0 0x20000000 0x20000000 0 0x10000000   /* non-prefetchable memory */
 			  0xc2000000 0 0x30000000 0x30000000 0 0x10000000>; /* prefetchable memory */
 
-- 
1.7.0.4

