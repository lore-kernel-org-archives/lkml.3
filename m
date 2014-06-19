Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbaFSHtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:49:21 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17655 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbaFSHtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:49:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Jun 2014 00:39:55 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] ARM: tegra: TN7: relax some regulators
Date: Thu, 19 Jun 2014 16:49:14 +0900
Message-ID: <1403164154-1362-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the regulator-always-on property from some regulators that do not
need it. On recent kernels fixed regulators which supply is always on
fail registration.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Stephen, do you think you could queue this for 3.16-rc2 or 3? Without
this the TN7 panel does not show up which makes the device virtually
unusable.

 arch/arm/boot/dts/tegra114-tn7.dts | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-tn7.dts b/arch/arm/boot/dts/tegra114-tn7.dts
index 963662145635..abcfe77c3a99 100644
--- a/arch/arm/boot/dts/tegra114-tn7.dts
+++ b/arch/arm/boot/dts/tegra114-tn7.dts
@@ -114,7 +114,6 @@
 						regulator-name = "vs-pmu-1v8";
 						regulator-min-microvolt = <1800000>;
 						regulator-max-microvolt = <1800000>;
-						regulator-always-on;
 						regulator-boot-on;
 					};
 
@@ -130,7 +129,6 @@
 						regulator-name = "vd-smps10-out1";
 						regulator-min-microvolt = <5000000>;
 						regulator-max-microvolt = <5000000>;
-						regulator-always-on;
 						regulator-boot-on;
 					};
 
@@ -138,7 +136,6 @@
 						regulator-name = "vd-smps10-out2";
 						regulator-min-microvolt = <5000000>;
 						regulator-max-microvolt = <5000000>;
-						regulator-always-on;
 						regulator-boot-on;
 					};
 
-- 
2.0.0

