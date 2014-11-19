Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaKSIHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:07:42 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:40717 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbaKSIHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:07:41 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <4b8a38f2930fcf886500744bbe5f1bd2>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, huangtao@rock-chips.com
Cc: Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH v2 1/2] ASoC: rockchip-i2s: dt: add an optional property "i2s_clk_out"
Date: Wed, 19 Nov 2014 16:07:27 +0800
Message-Id: <1416384447-29391-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416366365-4632-2-git-send-email-jay.xu@rock-chips.com>
References: <1416366365-4632-2-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an property "i2s_clk_out", which enables to output clock to outside
of rockchip SoCs. Let's make it optional since not each board needs it.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
changes since v1:
- make "i2s_clk_out" optional, suggested by Sonny

 Documentation/devicetree/bindings/sound/rockchip-i2s.txt | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
index 9b82c20..6dedd0d 100644
--- a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
+++ b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
@@ -22,6 +22,10 @@ Required properties:
    - "i2s_hclk": clock for I2S BUS
    - "i2s_clk" : clock for I2S controller
 
+Optional property:
+   - "i2s_clk_out" : clock output to outside of chip, usally as master clock for audio
+   codec chip
+
 Example for rk3288 I2S controller:
 
 i2s@ff890000 {
@@ -32,6 +36,6 @@ i2s@ff890000 {
 	#size-cells = <0>;
 	dmas = <&pdma1 0>, <&pdma1 1>;
 	dma-names = "tx", "rx";
-	clock-names = "i2s_hclk", "i2s_clk";
-	clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
+	clock-names = "i2s_hclk", "i2s_clk", "i2s_clk_out";
+	clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>, <&cru SCLK_I2S0_CLKOUT>;
 };
-- 
1.9.1


