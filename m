Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3A2M7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:59:04 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5713 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3A2M65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:58:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 29 Jan 2013 04:56:38 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/7] ARM: DT: tegra114: add GPIO DT entry
Date: Tue, 29 Jan 2013 18:26:18 +0530
Message-ID: <1359464183-6255-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
References: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra114 has the GPIO controllers with 8 GPIO bank and each bank
supports 32 pins.

Add DT entry for GPIO controller. Tegra114 GPIO controller is
compatible with Tegra30 GPIO controller driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 96a8235..9ce1a68 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -37,6 +37,23 @@
 		reg = <0x6000c004 0x14c>;
 	};
 
+	gpio: gpio {
+		compatible = "nvidia,tegra114-gpio", "nvidia,tegra30-gpio";
+		reg = <0x6000d000 0x1000>;
+		interrupts = <0 32 0x04
+			      0 33 0x04
+			      0 34 0x04
+			      0 35 0x04
+			      0 55 0x04
+			      0 87 0x04
+			      0 89 0x04
+			      0 125 0x04>;
+		#gpio-cells = <2>;
+		gpio-controller;
+		#interrupt-cells = <2>;
+		interrupt-controller;
+	};
+
 	serial@70006000 {
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
-- 
1.7.1.1

