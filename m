Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaLXJjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 04:39:17 -0500
Received: from regular1.263xmail.com ([211.150.99.133]:52629 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaLXJjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 04:39:14 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <4c21586cc7c5f2e7fb0e1e36ab9e251c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: lgirdwood@gmail.com, heiko@sntech.de, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, sonnyrao@chromium.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH v2 2/3] ASoC: rockchip: i2s: set TDL and RDL to 16 samples
Date: Wed, 24 Dec 2014 17:37:01 +0800
Message-Id: <1419413822-11539-3-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419413822-11539-1-git-send-email-jay.xu@rock-chips.com>
References: <1419325709-15374-1-git-send-email-jay.xu@rock-chips.com>
 <1419413822-11539-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set Transmit Data Level(TDL) and Receive Data Level(RDL) to 16 samples.
Without this setting, the TDL is default to be 0x00 (means 0 sample),
and the RDL is default to be 0x1f (means 32 samples).

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
changes since v1:
- modify commit message "bit" to "sample", suggested by dgreid

 sound/soc/rockchip/rockchip_i2s.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index c74ba37..1cd7efc 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -247,6 +247,10 @@ static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
 
 	regmap_update_bits(i2s->regmap, I2S_TXCR, I2S_TXCR_VDW_MASK, val);
 	regmap_update_bits(i2s->regmap, I2S_RXCR, I2S_RXCR_VDW_MASK, val);
+	regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_TDL_MASK,
+			   I2S_DMACR_TDL(16));
+	regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_RDL_MASK,
+			   I2S_DMACR_RDL(16));
 
 	return 0;
 }
-- 
1.9.1


