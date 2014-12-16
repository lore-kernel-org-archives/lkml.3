Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaLPImP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:42:15 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33120 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaLPImM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:42:12 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/3] ARM: tegra: Add Tegra124 ACTMON support
Date: Tue, 16 Dec 2014 09:41:21 +0100
Message-Id: <1418719298-25314-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418719298-25314-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1418719298-25314-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device node for the ACTMON block to the Tegra124 device tree.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v2:	* Add operating-points property
---
 arch/arm/boot/dts/tegra124.dtsi | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index a49e7da..9d7baa8 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -215,6 +215,29 @@
 		reg = <0x0 0x60007000 0x0 0x1000>;
 	};
 
+	actmon@0,6000c800 {
+		compatible = "nvidia,tegra124-actmon";
+		reg = <0x0 0x6000c800 0x0 0x400>;
+		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA124_CLK_ACTMON>,
+			 <&tegra_car TEGRA124_CLK_EMC>;
+		clock-names = "actmon", "emc";
+		resets = <&tegra_car 119>;
+		reset-names = "actmon";
+		operating-points = <
+			/* KHz	uV */
+			/* TODO: Add more points below 102 MHz */
+			102000	800000
+			204000	800000
+			300000	820000
+			396000	850000
+			528000	880000
+			600000	910000
+			792000	980000
+			924000	1010000
+		>;
+	};
+
 	gpio: gpio@0,6000d000 {
 		compatible = "nvidia,tegra124-gpio", "nvidia,tegra30-gpio";
 		reg = <0x0 0x6000d000 0x0 0x1000>;
-- 
1.9.3

