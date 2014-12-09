Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbaLINQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:16:13 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40004 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbaLINQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:16:09 -0500
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
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] of: Add binding for NVIDIA Tegra ACTMON node
Date: Tue,  9 Dec 2014 14:15:04 +0100
Message-Id: <1418130912-24725-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418130912-24725-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1418130912-24725-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This block gathers statistics about various counters and can be configured to
fire interrupts when thresholds are crossed.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v2:	* Add operating-points property
---
 .../devicetree/bindings/arm/tegra/actmon.txt       | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/actmon.txt

diff --git a/Documentation/devicetree/bindings/arm/tegra/actmon.txt b/Documentation/devicetree/bindings/arm/tegra/actmon.txt
new file mode 100644
index 0000000..b4069df
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/tegra/actmon.txt
@@ -0,0 +1,38 @@
+Tegra124 Activity Monitor driver
+
+Required properties:
+
+- compatible: should be "nvidia,tegra124-actmon"
+- reg: offset and length of the register set for the device
+- interrupts: standard interrupt property
+- clocks: Must contain a phandle and clock specifier pair for each entry in clock-names. See ../clock/clock-bindings.txt for details.
+- clock-names: Must include the following entries:
+  - actmon
+  - emc
+- resets: Must contain an entry for each entry in reset-names. See ../reset/reset.txt for details.
+- reset-names: Must include the following entries:
+  - actmon
+- operating-points: Supported operating points. See ../power/opp.txt for details.
+
+Example:
+	actmon@6000c800 {
+		compatible = "nvidia,tegra124-actmon";
+		reg = <0x0 0x6000c800 0x0 0x400>;
+		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA124_CLK_ACTMON>,
+			 <&tegra_car TEGRA124_CLK_EMC>;
+		clock-names = "actmon", "emc";
+		resets = <&tegra_car 119>;
+		reset-names = "actmon";
+		operating-points = <
+			/* kHz	uV */
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
-- 
1.9.3

