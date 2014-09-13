Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaIMBFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 21:05:05 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:51498 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaIMBFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 21:05:03 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <80f79d987c7103b70b7a1953c32b58d2>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH] ASoC: rockchip-i2s: dt: swap tx and rx channed request number
Date: Sat, 13 Sep 2014 09:04:41 +0800
Message-Id: <1410570281-23681-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference to RK3288 TRM, fix an error channel id for i2s tx and rx
Table 10-1 DMAC_BUS Request Mapping Table
Req number	Source	Polarity
0		I2S tx	High level
1		I2S rx	High level

Tested on RK3288 board.

Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
 Documentation/devicetree/bindings/sound/rockchip-i2s.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
index 6c55fcf..9b82c20 100644
--- a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
+++ b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
@@ -31,7 +31,7 @@ i2s@ff890000 {
 	#address-cells = <1>;
 	#size-cells = <0>;
 	dmas = <&pdma1 0>, <&pdma1 1>;
-	dma-names = "rx", "tx";
+	dma-names = "tx", "rx";
 	clock-names = "i2s_hclk", "i2s_clk";
 	clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
 };
-- 
1.9.1


