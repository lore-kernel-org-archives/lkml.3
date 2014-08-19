Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaHSDnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 23:43:40 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:35842 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaHSDjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 23:39:41 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 23:39:37 EDT
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Tue, 19 Aug 2014 06:34:10 +0300
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        devicetree@vger.kernel.org, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 09/15] ARM: tegra: Add the DFLL to Tegra124 device tree
Date: Tue, 19 Aug 2014 06:33:19 +0300
Message-Id: <1408419205-10048-10-git-send-email-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

The DFLL clocksource is a separate IP block from the usual
clock-and-reset controller, so it gets its own device tree node.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 arch/arm/boot/dts/tegra124.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 03916ef..8ff4332 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -544,6 +544,28 @@
 		status = "disabled";
 	};
 
+	dfll: dfll@0,70110000 {
+		compatible = "nvidia,tegra124-dfll";
+		reg = <0 0x70110000 0 0x100>, /* DFLL control */
+		      <0 0x70110000 0 0x100>, /* I2C output control */
+		      <0 0x70110100 0 0x100>, /* Integrated I2C controller */
+		      <0 0x70110200 0 0x100>; /* Look-up table RAM */
+		interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA124_CLK_DFLL_SOC>,
+			 <&tegra_car TEGRA124_CLK_DFLL_REF>,
+			 <&tegra_car TEGRA124_CLK_I2C5>;
+		clock-names = "soc", "ref", "i2c";
+		#clock-cells = <0>;
+		clock-output-names = "dfllCPU_out";
+		nvidia,sample-rate = <12500>;
+		nvidia,droop-ctrl = <0x00000f00>;
+		nvidia,force-mode = <1>;
+		nvidia,cf = <10>;
+		nvidia,ci = <0>;
+		nvidia,cg = <2>;
+		status = "disabled";
+	};
+
 	ahub@0,70300000 {
 		compatible = "nvidia,tegra124-ahub";
 		reg = <0x0 0x70300000 0x0 0x200>,
-- 
1.8.1.5

