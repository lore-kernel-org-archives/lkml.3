Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbaGOROY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:14:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35431 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbaGORCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:14 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tushar Behera <tushar.b@samsung.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 51/94] ARM: dts: Update the parent for Audss clocks in Exynos5420
Date: Tue, 15 Jul 2014 20:01:06 +0300
Message-Id: <1405443709-15288-51-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tushar Behera <tushar.b@samsung.com>

Currently CLK_FOUT_EPLL was set as one of the parents of AUDSS mux.
As per the user manual, it should be CLK_MAU_EPLL.

The problem surfaced when the bootloader in Peach-pit board set
the EPLL clock as the parent of AUDSS mux. While booting the kernel,
we used to get a system hang during late boot if CLK_MAU_EPLL was
disabled.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Reported-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Tested-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index e385322..79e9119 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -167,7 +167,7 @@
 		compatible = "samsung,exynos5420-audss-clock";
 		reg = <0x03810000 0x0C>;
 		#clock-cells = <1>;
-		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_FOUT_EPLL>,
+		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MAU_EPLL>,
 			 <&clock CLK_SCLK_MAUDIO0>, <&clock CLK_SCLK_MAUPCM0>;
 		clock-names = "pll_ref", "pll_in", "sclk_audio", "sclk_pcm_in";
 	};
-- 
1.7.10.4

