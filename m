Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaJ2JqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:46:14 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:41031 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbaJ2JqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:46:11 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <386358ee974f0d69c1be1844da491959>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH] ASoC: rockchip-i2s: fix infinite loop in rockchip_snd_rxctrl
Date: Wed, 29 Oct 2014 17:45:51 +0800
Message-Id: <1414575951-18015-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get into an infinite loop if the I2S_CLR register fails to
clear due to a missing break statement, so add that.

Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/rockchip_i2s.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index f373e37..c74ba37 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -154,8 +154,10 @@ static void rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
 			while (val) {
 				regmap_read(i2s->regmap, I2S_CLR, &val);
 				retry--;
-				if (!retry)
+				if (!retry) {
 					dev_warn(i2s->dev, "fail to clear\n");
+					break;
+				}
 			}
 		}
 	}
-- 
1.9.1


