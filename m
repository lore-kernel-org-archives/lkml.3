Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3GYRzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:55:07 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:40188 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab3GYRzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:55:01 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jay Agarwal <jagarwal@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 13/16] ARM: tegra: Fix Beaver's PCIe lane configuration
Date: Thu, 25 Jul 2013 10:53:27 -0700
Message-Id: <1374774810-18459-14-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
References: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Beaver's PCIe lane configuration most closely matches x2 x2 x2 rather
than x4 x1 x1, since clocks 0 and 2 are used, and lanes 0 and 5 are used,
and the only way those align is with a x2 x2 x2 configuration.

Also, disable root port 1; there's nothing connected to it. Root port 0
is the on-board PCIe Ethernet, and port 2 is the mini-PCIe slot.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/boot/dts/tegra30-beaver.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/tegra30-beaver.dts
index 4d9fa31..e1dd644 100644
--- a/arch/arm/boot/dts/tegra30-beaver.dts
+++ b/arch/arm/boot/dts/tegra30-beaver.dts
@@ -18,16 +18,16 @@
 
 		pci@1,0 {
 			status = "okay";
-			nvidia,num-lanes = <4>;
+			nvidia,num-lanes = <2>;
 		};
 
 		pci@2,0 {
-			status = "okay";
-			nvidia,num-lanes = <1>;
+			nvidia,num-lanes = <2>;
 		};
 
 		pci@3,0 {
-			nvidia,num-lanes = <1>;
+			status = "okay";
+			nvidia,num-lanes = <2>;
 		};
 	};
 
-- 
1.8.1.5

