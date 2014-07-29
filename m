Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaG2Udq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:33:46 -0400
Received: from mail-yk0-f201.google.com ([209.85.160.201]:37884 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaG2UdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:33:11 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: dts: Take the mmc slot node out of rk3288-evb
Date: Tue, 29 Jul 2014 13:31:55 -0700
Message-Id: <1406665916-23396-5-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1406665916-23396-1-git-send-email-dianders@chromium.org>
References: <1406665916-23396-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Jaehoon's (mmc: dw_mmc: replace "disable-wp" from slot's quirk to
host's quirk) the slot node is no longer used.  Remove it.

Note that if Jaehoon's patch lands before my (ARM: dts: Enable emmc
and sdmmc on the rk3288-evb boards) then this could be squashed into
the later.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/rk3288-evb.dtsi | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index ec580fa..b69008f 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -41,17 +41,13 @@
 	broken-cd;
 	bus-width = <8>;
 	cap-mmc-highspeed;
+	disable-wp;
 	mmc-ddr-1_8v;
 	non-removable;
 	num-slots = <1>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_clk &emmc_cmd &emmc_pwr &emmc_bus8>;
 	status = "okay";
-
-	slot@0 {
-		reg = <0>;
-		disable-wp;
-	};
 };
 
 &sdmmc {
@@ -59,15 +55,11 @@
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
 	card-detect-delay = <200>;
+	disable-wp;			/* wp not hooked up */
 	num-slots = <1>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc_clk &sdmmc_cmd &sdmmc_cd &sdmmc_bus4>;
 	status = "okay";
-
-	slot@0 {
-		reg = <0>;
-		disable-wp;		/* wp not hooked up */
-	};
 };
 
 &i2c0 {
-- 
2.0.0.526.g5318336

