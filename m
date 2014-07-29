Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaG2Udt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:33:49 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:37983 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaG2UdL (ORCPT
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
Subject: [PATCH 5/5] ARM: dts: mmc slot node gone on rk3288 => no more address / size cells
Date: Tue, 29 Jul 2014 13:31:56 -0700
Message-Id: <1406665916-23396-6-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1406665916-23396-1-git-send-email-dianders@chromium.org>
References: <1406665916-23396-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've removed the slot node from all rk3288 device trees, so we no
longer need address-cells or size-cells.

If Jaehoon's (mmc: dw_mmc: replace "disable-wp" from slot's quirk to
host's quirk) patch lands before my (ARM: dts: Add emmc and sdmmc to
the rk3288 device tree) then this could be squashed into the later
patch.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index fd77a65..d2d0086 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -85,8 +85,6 @@
 		fifo-depth = <0x100>;
 		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
 		reg = <0xff0c0000 0x4000>;
-		#address-cells = <1>;
-		#size-cells = <0>;
 	};
 
 	emmc: dwmmc@ff0f0000 {
@@ -96,8 +94,6 @@
 		fifo-depth = <0x100>;
 		interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 		reg = <0xff0f0000 0x4000>;
-		#address-cells = <1>;
-		#size-cells = <0>;
 	};
 
 	i2c1: i2c@ff140000 {
-- 
2.0.0.526.g5318336

