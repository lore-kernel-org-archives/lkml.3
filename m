Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbbAZKTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:19:17 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:40084 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbbAZKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:18:42 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH 4/4] sound: jz4740: Enable codec clock during dai_probe
Date: Mon, 26 Jan 2015 10:18:31 +0000
Message-ID: <1422267511-6649-5-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we are moving away from platform to DT, we cant rely on the board
file to do this now. So enable it here.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
---
 sound/soc/jz4740/jz4740-i2s.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index 3c309fc..a7e4a7b 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -376,6 +376,10 @@ static int jz4740_i2s_dai_probe(struct snd_soc_dai *dai)
 		JZ_AIC_CONF_I2S |
 		JZ_AIC_CONF_INTERNAL_CODEC;
 
+	/* enable codec sysclk */
+	clk_set_rate(i2s->clk_i2s, 12000000);
+	clk_prepare_enable(i2s->clk_i2s);
+
 	jz4740_i2s_write(i2s, JZ_REG_AIC_CONF, JZ_AIC_CONF_RESET);
 	jz4740_i2s_write(i2s, JZ_REG_AIC_CONF, conf);
 
-- 
1.9.1

