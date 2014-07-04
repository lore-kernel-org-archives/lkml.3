Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbaGDUZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:25:55 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38720 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030309AbaGDUZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:25:52 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v7 14/24] clk: max77686: Improve Maxim 77686 PMIC clocks binding
Date: Fri,  4 Jul 2014 22:24:17 +0200
Message-Id: <1404505467-26526-15-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like most clock drivers, the Maxim 77686 PMIC clock binding
follows the convention that the "#clock-cells" property is
used to specify the number of cells in a clock provider.

But the binding document is not clear enough that it shall
be set to 1 since the PMIC support multiple clocks outputs.

Also, explain that the clocks identifiers are defined in a
header file that can be included by Device Tree source with
client nodes to avoid using magic numbers.

Finally, add "clock-output-names" as an optional property
since now is supported by the clock driver.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Mike Turquette <mturquette@linaro.org>
---

Changes since v6: None

Changes since v5:
 - Fix generic driver changes merged into max77802 clock patch by mistake.
   Suggested by Yadwinder Singh Brar.
 - Register clock lookups using clk_register_clkdev() instead of doing manually.
 - Use the managed devm_clk_register() function and remove clk un-registration.
 - Add "clock-output-names" property support. Suggested by Yadwinder Singh Brar.
 - Return the rate unconditionally in recalc_rate. Suggested by Mike Turquette.

Changes since v4: None

Changes since v3:
 - Don't change clock-names property to make clear that it's
   the consumer clock name and should not match the producer clock.
   Suggested by Doug Anderson.
---
 .../devicetree/bindings/clock/maxim,max77686.txt         | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/maxim,max77686.txt b/Documentation/devicetree/bindings/clock/maxim,max77686.txt
index 96ce71b..9c40739 100644
--- a/Documentation/devicetree/bindings/clock/maxim,max77686.txt
+++ b/Documentation/devicetree/bindings/clock/maxim,max77686.txt
@@ -9,13 +9,21 @@ The MAX77686 contains three 32.768khz clock outputs that can be controlled
 Following properties should be presend in main device node of the MFD chip.
 
 Required properties:
-- #clock-cells: simple one-cell clock specifier format is used, where the
-  only cell is used as an index of the clock inside the provider. Following
-  indices are allowed:
+
+- #clock-cells: from common clock binding; shall be set to 1.
+
+Optional properties:
+- clock-output-names: From common clock binding.
+
+Each clock is assigned an identifier and client nodes can use this identifier
+to specify the clock which they consume. Following indices are allowed:
     - 0: 32khz_ap clock,
     - 1: 32khz_cp clock,
     - 2: 32khz_pmic clock.
 
+Clocks are defined as preprocessor macros in dt-bindings/clock/maxim,max77686.h
+header and can be used in device tree sources.
+
 Example: Node of the MFD chip
 
 	max77686: max77686@09 {
@@ -34,5 +42,5 @@ Example: Clock consumer node
 		compatible = "bar,foo";
 		/* ... */
 		clock-names = "my-clock";
-		clocks = <&max77686 2>;
+		clocks = <&max77686 MAX77686_CLK_PMIC>;
 	};
-- 
2.0.0.rc2

