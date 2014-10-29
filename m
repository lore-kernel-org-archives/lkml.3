Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452AbaJ2QYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:24:42 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39927 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934323AbaJ2QYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:24:35 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/13] ARM: tegra: Add EMC to Tegra124 device tree
Date: Wed, 29 Oct 2014 17:22:25 +0100
Message-Id: <1414599796-30597-8-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

This adds a node for the EMC memory controller. It is always enabled, but only
provides read-only functionality without board-specific timing tables.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 arch/arm/boot/dts/tegra124.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 0ee30f6..97c9f8b 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -567,6 +567,13 @@
 		#iommu-cells = <1>;
 	};
 
+	emc@0,7001b000 {
+		compatible = "nvidia,tegra124-emc";
+		reg = <0x0 0x7001b000 0x0 0x1000>;
+
+		nvidia,memory-controller = <&mc>;
+	};
+
 	sata@0,70020000 {
 		compatible = "nvidia,tegra124-ahci";
 
-- 
1.9.3

