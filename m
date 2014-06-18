Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967402AbaFRObY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:31:24 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19957 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967030AbaFRO14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:27:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Jun 2014 07:18:34 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 1/7] of: Add NVIDIA Tegra SATA controller binding
Date: Wed, 18 Jun 2014 17:23:20 +0300
Message-ID: <1403101406-15439-2-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com>
References: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for the SATA
controller found on NVIDIA Tegra SoCs.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
v2:
- added target-5v-supply and target-12v-supply
- changed wording to be similar with other Tegra drivers

 .../devicetree/bindings/ata/tegra-sata.txt         | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/tegra-sata.txt

diff --git a/Documentation/devicetree/bindings/ata/tegra-sata.txt b/Documentation/devicetree/bindings/ata/tegra-sata.txt
new file mode 100644
index 0000000..946f207
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/tegra-sata.txt
@@ -0,0 +1,30 @@
+Tegra124 SoC SATA AHCI controller
+
+Required properties :
+- compatible : "nvidia,tegra124-ahci".
+- reg : Should contain 2 entries:
+  - AHCI register set (SATA BAR5)
+  - SATA register set
+- interrupts : Defines the interrupt used by SATA
+- clocks : Must contain an entry for each entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names : Must include the following entries:
+  - sata
+  - sata-oob
+  - cml1
+  - pll_e
+- resets : Must contain an entry for each entry in reset-names.
+  See ../reset/reset.txt for details.
+- reset-names : Must include the following entries:
+  - sata
+  - sata-oob
+  - sata-cold
+- phys : Must contain an entry for each entry in phy-names.
+  See ../phy/phy-bindings.txt for details.
+- phy-names : Must include the following entries:
+  - sata-phy : XUSB PADCTL SATA PHY
+- hvdd-supply : Defines the SATA HVDD regulator
+- vddio-supply : Defines the SATA VDDIO regulator
+- avdd-supply : Defines the SATA AVDD regulator
+- target-5v-supply : Defines the SATA 5V power regulator
+- target-12v-supply : Defines the SATA 12V power regulator
-- 
1.8.1.5

