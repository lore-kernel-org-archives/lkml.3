Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3IXAVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:21:30 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:35526 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3IXAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:21:24 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH V2 3/6] clk: exynos5250: add clock ID for div_pcm0
Date: Mon, 23 Sep 2013 17:21:15 -0700
Message-Id: <1379982078-23381-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379982078-23381-1-git-send-email-abrestic@chromium.org>
References: <1379711637-5226-1-git-send-email-abrestic@chromium.org>
 <1379982078-23381-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no gate for the PCM clock input to the AudioSS block, so
the parent of sclk_pcm is div_pcm0.  Add a clock ID for it so that
we can reference it in device trees.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 Documentation/devicetree/bindings/clock/exynos5250-clock.txt | 1 +
 drivers/clk/samsung/clk-exynos5250.c                         | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
index 24765c1..67e9a47 100644
--- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
@@ -62,6 +62,7 @@ clock which they consume.
   div_i2s1		157
   div_i2s2		158
   sclk_hdmiphy		159
+  div_pcm0		160
 
 
    [Peripheral Clock Gates]
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index adf3234..dec5376 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -108,7 +108,7 @@ enum exynos5250_clks {
 	sclk_mmc0, sclk_mmc1, sclk_mmc2, sclk_mmc3, sclk_sata, sclk_usb3,
 	sclk_jpeg, sclk_uart0, sclk_uart1, sclk_uart2, sclk_uart3, sclk_pwm,
 	sclk_audio1, sclk_audio2, sclk_spdif, sclk_spi0, sclk_spi1, sclk_spi2,
-	div_i2s1, div_i2s2, sclk_hdmiphy,
+	div_i2s1, div_i2s2, sclk_hdmiphy, div_pcm0,
 
 	/* gate clocks */
 	gscl0 = 256, gscl1, gscl2, gscl3, gscl_wa, gscl_wb, smmu_gscl0,
@@ -301,7 +301,7 @@ static struct samsung_div_clock exynos5250_div_clks[] __initdata = {
 	DIV(none, "div_dp", "mout_dp", DIV_DISP1_0, 24, 4),
 	DIV(none, "div_jpeg", "mout_jpeg", DIV_GEN, 4, 4),
 	DIV(none, "div_audio0", "mout_audio0", DIV_MAU, 0, 4),
-	DIV(none, "div_pcm0", "sclk_audio0", DIV_MAU, 4, 8),
+	DIV(div_pcm0, "div_pcm0", "sclk_audio0", DIV_MAU, 4, 8),
 	DIV(none, "div_sata", "mout_sata", DIV_FSYS0, 20, 4),
 	DIV(none, "div_usb3", "mout_usb3", DIV_FSYS0, 24, 4),
 	DIV(none, "div_mmc0", "mout_mmc0", DIV_FSYS1, 0, 4),
-- 
1.8.4

