Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbbAZOxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:53:30 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:29458 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbbAZOx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:53:27 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <Zubair.Kakakhel@imgtec.com>,
        <lars@metafoo.de>
Subject: [PATCH_V3 4/4] sound: jz4740: set i2s clk rate to 12MHz
Date: Mon, 26 Jan 2015 14:53:13 +0000
Message-ID: <1422283993-53642-5-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422283993-53642-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422283993-53642-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2s clock rate is not set to 12MHz currently. Set it before enabling
the clock.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

---
V2 changes: Removed clk_prepare_enable call as clock was already being
enabled elsewhere. Just set rate to 12MHz.
---
 sound/soc/jz4740/jz4740-i2s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index 07f7781..c2e5852 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -125,6 +125,7 @@ static int jz4740_i2s_startup(struct snd_pcm_substream *substream,
 	ctrl |= JZ_AIC_CTRL_FLUSH;
 	jz4740_i2s_write(i2s, JZ_REG_AIC_CTRL, ctrl);
 
+	clk_set_rate(i2s->clk_i2s, 12000000);
 	clk_prepare_enable(i2s->clk_i2s);
 
 	conf = jz4740_i2s_read(i2s, JZ_REG_AIC_CONF);
-- 
1.9.1

