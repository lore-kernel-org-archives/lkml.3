Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3GOIhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:37:02 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:43422 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab3GOIhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:37:00 -0400
Date: Mon, 15 Jul 2013 10:36:44 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] ASoC: kirkwood-i2s: fix a compilation warning
Message-ID: <20130715103644.04e57749@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the function kirkwood_set_rate, when the rate cannot be satisfied
by the internal nor by an external clock, the clock source in undefined:

 warning: ‘clks_ctrl’ may be used uninitialized in this function

As the ALSA subsystem should never gives such a rate, this patch removes
the check of the external clock pointer.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/kirkwood/kirkwood-i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 4c9dad3..8da5cdb 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -111,7 +111,7 @@ static void kirkwood_set_rate(struct snd_soc_dai *dai,
 		kirkwood_set_dco(priv->io, rate);
 
 		clks_ctrl = KIRKWOOD_MCLK_SOURCE_DCO;
-	} else if (!IS_ERR(priv->extclk)) {
+	} else {
 		/* use optional external clk for other rates */
 		dev_dbg(dai->dev, "%s: extclk set rate = %lu -> %lu\n",
 			__func__, rate, 256 * rate);

