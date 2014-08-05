Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaHEIPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:15:22 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3523 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbaHEIOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:14:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Aug 2014 01:01:25 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 1/3] of: Add descriptions of thermtrip properties to Tegra PMC bindings
Date: Tue, 5 Aug 2014 11:12:58 +0300
Message-ID: <1407226380-747-2-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware-triggered thermal reset requires configuring the I2C
reset procedure. This configuration is read from the device tree,
so document the relevant properties in the binding documentation.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 .../devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt    | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
index 68ac65f..140e2aa 100644
--- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
@@ -38,6 +38,19 @@ Required properties when nvidia,suspend-mode is specified:
 			      Core power good time in uS.
 - nvidia,core-pwr-off-time : Core power off time in uS.
 
+Required properties for hardware-triggered thermal reset:
+    (only tegra30, tegra114, tegra124)
+- nvidia,thermtrip-pmu-i2c-addr : I2C address of the power management unit.
+- nvidia,thermtrip-i2c-controller : Index of the I2C controller the PMU is
+                                    attached to.
+- nvidia,thermtrip-reg-addr : Address (byte) to send reset command to.
+- nvidia,thermtrip-reg-data : Data (byte) to use as reset command.
+
+Optional properties for hardware-triggered thermal reset:
+    (only tegra30, tegra114, tegra124)
+- nvidia,thermtrip-pinmux : Pinmux ID used for I2C access.
+- nvidia,thermtrip-pmu-16bit-ops : Use 16-bit operations.
+
 Required properties when nvidia,suspend-mode=<0>:
 - nvidia,lp0-vec : <start length> Starting address and length of LP0 vector
   The LP0 vector contains the warm boot code that is executed by AVP when
-- 
1.8.1.5

