Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaLBOuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:50:08 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:38938 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaLBOuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:50:05 -0500
X-RL-SENDER: jay.xu@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <ac46058e8f0e6e6689332ae29880610b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun Xu <jay.xu@rock-chips.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        jay.xu@rock-chips.com, sonnyrao@chromium.org, heiko@sntech.de
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH 1/2] ASoC: rockchip-i2s: dt: add an optional property "i2s_clk_out"
Date: Tue,  2 Dec 2014 22:49:25 +0800
Message-Id: <1417531766-29669-2-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an property "i2s_clk_out", which enables to output clock to outside
of rockchip SoCs. Let's make it optional since not each board needs it.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 Documentation/devicetree/bindings/sound/rockchip-i2s.txt | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
index 9b82c20..c8f5ac0 100644
--- a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
+++ b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
@@ -22,6 +22,10 @@ Required properties:
    - "i2s_hclk": clock for I2S BUS
    - "i2s_clk" : clock for I2S controller
 
+Optional property:
+- "i2s_clk_out" : clock output to outside of chip, usally as master clock for audio
+	codec chip
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

