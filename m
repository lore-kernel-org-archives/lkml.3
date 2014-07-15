Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaGOP0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:26:09 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19170 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaGOP0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:26:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Jul 2014 08:14:46 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 3/6] clk: tegra: Update binding doc Tegra132
Date: Tue, 15 Jul 2014 18:24:33 +0300
Message-ID: <1405437890-6468-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra132 has almost the same clock structure than Tegra124. This patch
documents the missing clock IDs.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 .../bindings/clock/nvidia,tegra124-car.txt         |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
index ded5d62..28129a9 100644
--- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
@@ -1,4 +1,4 @@
-NVIDIA Tegra124 Clock And Reset Controller
+NVIDIA Tegra124 and Tegra132 Clock And Reset Controller
 
 This binding uses the common clock binding:
 Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -7,14 +7,16 @@ The CAR (Clock And Reset) Controller on Tegra is the HW module responsible
 for muxing and gating Tegra's clocks, and setting their rates.
 
 Required properties :
-- compatible : Should be "nvidia,tegra124-car"
+- compatible : Should be "nvidia,tegra124-car" or "nvidia,tegra132-car"
 - reg : Should contain CAR registers location and length
 - clocks : Should contain phandle and clock specifiers for two clocks:
   the 32 KHz "32k_in", and the board-specific oscillator "osc".
 - #clock-cells : Should be 1.
   In clock consumers, this cell represents the clock ID exposed by the
   CAR. The assignments may be found in header file
-  <dt-bindings/clock/tegra124-car.h>.
+  <dt-bindings/clock/tegra124-car.h>. The following clocks do not exist
+  in the nvidia,tegra132-car binding: TEGRA124_CLK_CCLK_G,
+  TEGRA124_CLK_CCLK_LP, TEGRA124_CLK_PLL_X and TEGRA124_CLK_PLL_X_OUT0.
 - #reset-cells : Should be 1.
   In clock consumers, this cell represents the bit number in the CAR's
   array of CLK_RST_CONTROLLER_RST_DEVICES_* registers.
-- 
1.7.7.rc0.72.g4b5ea.dirty

