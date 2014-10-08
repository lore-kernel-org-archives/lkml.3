Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaJHH7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:59:16 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:41178 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaJHH6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:58:54 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, dianders@chromium.org,
        Jianqun <jay.xu@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-rockchip@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] ASoC: rockchip-i2s: fix infinite loop in rockchip_snd_txctrl
Date: Wed,  8 Oct 2014 00:58:51 -0700
Message-Id: <1412755131-27542-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get into an infinite loop if the I2S_CLR register fails to
clear due to a missing break statement, so add that.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 033487c..f373e37 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -108,8 +108,10 @@ static void rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
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
1.8.3.2

