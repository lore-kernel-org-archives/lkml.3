Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3DWSJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:09:45 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5678 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab3DWSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:09:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Apr 2013 11:09:42 -0700
From: Bibek Basu <bbasu@nvidia.com>
To: <linus.walleij@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bibek Basu <bbasu@nvidia.com>
Subject: [PATCH 2/2] ARM: DT: tegra: pinctrl suspend resume hook
Date: Tue, 23 Apr 2013 23:39:02 +0530
Message-ID: <1366740542-26127-2-git-send-email-bbasu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366740542-26127-1-git-send-email-bbasu@nvidia.com>
References: <1366740542-26127-1-git-send-email-bbasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pinmux as the first node of tegra DT
so as to achieve pinctrl as last device to suspend and
first device to resume.

Signed-off-by: Bibek Basu <bbasu@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi | 12 ++++++------
 arch/arm/boot/dts/tegra20.dtsi  | 16 ++++++++--------
 arch/arm/boot/dts/tegra30.dtsi  | 13 +++++++------
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index a58a761..36596ae 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -11,6 +11,12 @@
 		serial3 = &uartd;
 	};
 
+	pinmux: pinmux {
+		compatible = "nvidia,tegra114-pinmux";
+		reg = <0x70000868 0x148		/* Pad control registers */
+		       0x70003000 0x40c>;	/* Mux registers */
+	};
+
 	host1x {
 		compatible = "nvidia,tegra114-host1x", "simple-bus";
 		reg = <0x50000000 0x00028000>;
@@ -165,12 +171,6 @@
 		interrupt-controller;
 	};
 
-	pinmux: pinmux {
-		compatible = "nvidia,tegra114-pinmux";
-		reg = <0x70000868 0x148		/* Pad control registers */
-		       0x70003000 0x40c>;	/* Mux registers */
-	};
-
 	/*
 	 * There are two serial driver i.e. 8250 based simple serial
 	 * driver and APB DMA based serial driver for higher baudrate
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index a5a9615..6d8a663 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -12,6 +12,14 @@
 		serial4 = &uarte;
 	};
 
+	pinmux: pinmux {
+		compatible = "nvidia,tegra20-pinmux";
+		reg = <0x70000014 0x10   /* Tri-state registers */
+		       0x70000080 0x20   /* Mux registers */
+		       0x700000a0 0x14   /* Pull-up/down registers */
+		       0x70000868 0xa8>; /* Pad control registers */
+	};
+
 	host1x {
 		compatible = "nvidia,tegra20-host1x", "simple-bus";
 		reg = <0x50000000 0x00024000>;
@@ -196,14 +204,6 @@
 		interrupt-controller;
 	};
 
-	pinmux: pinmux {
-		compatible = "nvidia,tegra20-pinmux";
-		reg = <0x70000014 0x10   /* Tri-state registers */
-		       0x70000080 0x20   /* Mux registers */
-		       0x700000a0 0x14   /* Pull-up/down registers */
-		       0x70000868 0xa8>; /* Pad control registers */
-	};
-
 	das {
 		compatible = "nvidia,tegra20-das";
 		reg = <0x70000c00 0x80>;
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 9f33086..b4b79f0 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -12,6 +12,13 @@
 		serial4 = &uarte;
 	};
 
+	pinmux: pinmux {
+		compatible = "nvidia,tegra30-pinmux";
+		reg = <0x70000868 0xd4    /* Pad control registers */
+		       0x70003000 0x3e4>; /* Mux registers */
+	};
+
+
 	host1x {
 		compatible = "nvidia,tegra30-host1x", "simple-bus";
 		reg = <0x50000000 0x00024000>;
@@ -216,12 +223,6 @@
 		interrupt-controller;
 	};
 
-	pinmux: pinmux {
-		compatible = "nvidia,tegra30-pinmux";
-		reg = <0x70000868 0xd4    /* Pad control registers */
-		       0x70003000 0x3e4>; /* Mux registers */
-	};
-
 	/*
 	 * There are two serial driver i.e. 8250 based simple serial
 	 * driver and APB DMA based serial driver for higher baudrate
-- 
1.8.1.5

