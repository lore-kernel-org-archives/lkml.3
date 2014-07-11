Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaGKOTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:19:18 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13601 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaGKOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:19:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jul 2014 07:12:06 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 5/8] of: Add Tegra124 EMC bindings
Date: Fri, 11 Jul 2014 17:18:30 +0300
Message-ID: <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for the nvidia,tegra124-emc device tree
node.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 .../bindings/memory-controllers/tegra-emc.txt      | 42 ++++++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt

diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
new file mode 100644
index 0000000..2dde17e
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
@@ -0,0 +1,42 @@
+Tegra124 SoC EMC controller
+
+Required properties :
+- compatible : "nvidia,tegra124-emc".
+- reg : Should contain 1 or 2 entries:
+  - EMC register set
+  - MC register set : Required only if no node with
+    'compatible = "nvidia,tegra124-mc"' exists. The MC register set
+    is first read from the MC node. If it doesn't exist, it is read
+    from this property.
+- timings : Should contain 1 entry for each supported clock rate.
+  Entries should be named "timing@n" where n is a 0-based increasing
+  number. The timings must be listed in rate-ascending order.
+
+Required properties for timings :
+- clock-frequency : Should contain the memory clock rate.
+- nvidia,parent-clock-frequency : Should contain the rate of the EMC
+  clock's parent clock.
+- clocks : Must contain an entry for each entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names : Must include the following entries:
+  - emc-parent : EMC's parent clock.
+- The following properties contain EMC timing characterization values:
+  - nvidia,emc-zcal-cnt-long
+  - nvidia,emc-auto-cal-interval
+  - nvidia,emc-ctt-term-ctrl
+  - nvidia,emc-cfg
+  - nvidia,emc-cfg-2
+  - nvidia,emc-sel-dpd-ctrl
+  - nvidia,emc-cfg-dig-dll
+  - nvidia,emc-bgbias-ctl0
+  - nvidia,emc-auto-cal-config
+  - nvidia,emc-auto-cal-config2
+  - nvidia,emc-auto-cal-config3
+  - nvidia,emc-mode-reset
+  - nvidia,emc-mode-1
+  - nvidia,emc-mode-2
+  - nvidia,emc-mode-4
+- nvidia,emc-burst-data : EMC timing characterization data written to
+                          EMC registers.
+- nvidia,mc-burst-data : EMC timing characterization data written to
+                         MC registers.
-- 
1.8.1.5

