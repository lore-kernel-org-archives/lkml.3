Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaKSDNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:13:25 -0500
Received: from irl-smtp01.263.net ([54.76.167.174]:34605 "EHLO
	irl-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaKSDNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:13:23 -0500
X-RL-SENDER: jay.xu@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <6fdb93b48037068fbb3b10ac95943858>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun Xu <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, huangtao@rock-chips.com
Cc: Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH 1/2] ASoC: rockchip-i2s: dt: add i2s_clkout to list of clocks
Date: Wed, 19 Nov 2014 11:06:04 +0800
Message-Id: <1416366365-4632-2-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416366365-4632-1-git-send-email-jay.xu@rock-chips.com>
References: <1416366365-4632-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2s_clkout property, which enables output clock to chip outside,
this is generally for audio codec outside.

Also add it to example.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 Documentation/devicetree/bindings/sound/rockchip-i2s.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
index 9b82c20..3d23b15 100644
--- a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
+++ b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
@@ -21,6 +21,7 @@ Required properties:
 - clock-names: should contain followings:
    - "i2s_hclk": clock for I2S BUS
    - "i2s_clk" : clock for I2S controller
+   - "i2s_clko" : clock for codec outside of chip
 
 Example for rk3288 I2S controller:
 
@@ -32,6 +33,6 @@ i2s@ff890000 {
 	#size-cells = <0>;
 	dmas = <&pdma1 0>, <&pdma1 1>;
 	dma-names = "tx", "rx";
-	clock-names = "i2s_hclk", "i2s_clk";
-	clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
+	clock-names = "i2s_hclk", "i2s_clk", "i2s_clko";
+	clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>, <&cru SCLK_I2S0_CLKOUT>;
 };
-- 
1.9.1

