Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaKME71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 23:59:27 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12638 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaKME7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 23:59:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 12 Nov 2014 20:59:35 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: Remove eMMC vmmc property for roth/tn7
Date: Thu, 13 Nov 2014 13:59:02 +0900
Message-ID: <1415854743-11670-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This property was wrong and broke eMMC since commit 52221610d. Align the
eMMC properties to those of other Tegra boards.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Stephen, Thierry, could we merge these two guys for 3.18? Roth and TN7
are effectively broken until these fixes are in. Thanks!

 arch/arm/boot/dts/tegra114-roth.dts | 1 -
 arch/arm/boot/dts/tegra114-tn7.dts  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-roth.dts b/arch/arm/boot/dts/tegra114-roth.dts
index c7c6825f11fb..1f6eaba92f67 100644
--- a/arch/arm/boot/dts/tegra114-roth.dts
+++ b/arch/arm/boot/dts/tegra114-roth.dts
@@ -971,7 +971,6 @@
 	sdhci@78000600 {
 		status = "okay";
 		bus-width = <8>;
-		vmmc-supply = <&vdd_1v8>;
 		non-removable;
 	};
 
diff --git a/arch/arm/boot/dts/tegra114-tn7.dts b/arch/arm/boot/dts/tegra114-tn7.dts
index 963662145635..3c3e2afc537d 100644
--- a/arch/arm/boot/dts/tegra114-tn7.dts
+++ b/arch/arm/boot/dts/tegra114-tn7.dts
@@ -240,7 +240,6 @@
 	sdhci@78000600 {
 		status = "okay";
 		bus-width = <8>;
-		vmmc-supply = <&vdd_1v8>;
 		non-removable;
 	};
 
-- 
2.1.3

