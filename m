Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbaFPSDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:03:17 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:54616 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbaFPSDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:03:15 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 03/10] Documentation: dt: improve Maxim 77686 PMIC clocks binding
Date: Mon, 16 Jun 2014 20:02:31 +0200
Message-Id: <1402941758-11216-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
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

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 .../devicetree/bindings/clock/maxim,max77686.txt          | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/maxim,max77686.txt b/Documentation/devicetree/bindings/clock/maxim,max77686.txt
index 96ce71b..8dea305 100644
--- a/Documentation/devicetree/bindings/clock/maxim,max77686.txt
+++ b/Documentation/devicetree/bindings/clock/maxim,max77686.txt
@@ -9,13 +9,18 @@ The MAX77686 contains three 32.768khz clock outputs that can be controlled
 Following properties should be presend in main device node of the MFD chip.
 
 Required properties:
-- #clock-cells: simple one-cell clock specifier format is used, where the
-  only cell is used as an index of the clock inside the provider. Following
-  indices are allowed:
+
+- #clock-cells: from common clock binding; shall be set to 1.
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
@@ -33,6 +38,6 @@ Example: Clock consumer node
 	foo@0 {
 		compatible = "bar,foo";
 		/* ... */
-		clock-names = "my-clock";
-		clocks = <&max77686 2>;
+		clock-names = "32khz_pmic";
+		clocks = <&max77686 MAX77686_CLK_PMIC>;
 	};
-- 
2.0.0.rc2

