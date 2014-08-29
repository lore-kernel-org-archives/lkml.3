Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaH2WNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:13:31 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:43090 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889AbaH2WN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:13:29 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2014 18:13:28 EDT
X-RL-SENDER: jay.xu@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <01877b9b21fc2c3314e858e41bfd4b66>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        yongjun_wei@trendmicro.com.cn, heiko@sntech.de, dianders@chromium.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH 1/2] rockchip-i2s: dt: add grf requested properties to set power of I2S controller
Date: Fri, 29 Aug 2014 15:07:05 -0700
Message-Id: <1409350027-17604-2-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409350027-17604-1-git-send-email-jay.xu@rock-chips.com>
References: <1409350027-17604-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "rockchip,grf" for driver to get physical address of GRF, and "rockchip,grf-io-vsel"
for driver to set voltage for I2S controller according to hardware request.

Requested by rk3xxx I2S controller and tested ok on rk3288-pinky board.

Change-Id: I2587d15c25e64c569857369326653d8a450bae19
Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
 Documentation/devicetree/bindings/sound/rockchip-i2s.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
index 6c55fcf..b995fe6 100644
--- a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
+++ b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
@@ -9,6 +9,8 @@ Required properties:
    - "rockchip,rk3066-i2s": for rk3066
    - "rockchip,rk3188-i2s", "rockchip,rk3066-i2s": for rk3188
    - "rockchip,rk3288-i2s", "rockchip,rk3066-i2s": for rk3288
+- rockchip,grf: physical base address of GRF.
+- rockchip,grf-io-vsel: select this if I2S controller powerd by 1.8v.
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: should contain the I2S interrupt.
@@ -26,12 +28,14 @@ Example for rk3288 I2S controller:
 
 i2s@ff890000 {
 	compatible = "rockchip,rk3288-i2s", "rockchip,rk3066-i2s";
+	rockchip,grf = <&grf>;
+	rockchip,grf-io-vsel;
 	reg = <0xff890000 0x10000>;
 	interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 	#address-cells = <1>;
 	#size-cells = <0>;
 	dmas = <&pdma1 0>, <&pdma1 1>;
-	dma-names = "rx", "tx";
+	dma-names = "tx", "rx";
 	clock-names = "i2s_hclk", "i2s_clk";
 	clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
 };
-- 
1.8.3.2

