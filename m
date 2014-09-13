Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaIMAlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 20:41:25 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:59121 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaIMAlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 20:41:23 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <e5774fcf25f4349342f37ca643c5bef6>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH 2/5] ASoC: rockchip-i2s: fix master mode set bit error
Date: Sat, 13 Sep 2014 08:41:03 +0800
Message-Id: <1410568863-21723-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix error format set to I2S master or slave mode.
Test on RK3288 board with max98090.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/rockchip_i2s.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 8d8e4b5..870a664 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -165,13 +165,14 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	struct rk_i2s_dev *i2s = to_info(cpu_dai);
 	unsigned int mask = 0, val = 0;
 
-	mask = I2S_CKR_MSS_SLAVE;
+	mask = I2S_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
-		val = I2S_CKR_MSS_SLAVE;
+		/* Set source clock in Master mode */
+		val = I2S_CKR_MSS_MASTER;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
-		val = I2S_CKR_MSS_MASTER;
+		val = I2S_CKR_MSS_SLAVE;
 		break;
 	default:
 		return -EINVAL;
-- 
1.9.1


