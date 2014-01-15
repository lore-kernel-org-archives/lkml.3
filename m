Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaAOPwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:52:45 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:36400 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbaAOPwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:52:40 -0500
Date: Wed, 15 Jan 2014 16:51:33 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 1/8] ASoC: simple-card: simplify code
Message-ID: <20140115165133.507595c9@armhf>
In-Reply-To: <20140115113551.0eb13409@armhf>
References: <20140115113551.0eb13409@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check of the mandatory fields is done for DT in its specific sequence.
Move the global check to the non-DT sequence.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c      | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 2a1b1b5..f0784ca 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -225,16 +225,16 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 
 		memcpy(cinfo, dev->platform_data, sizeof(*cinfo));
 		cinfo->snd_card.dev = dev;
-	}
 
-	if (!cinfo->name	||
-	    !cinfo->card	||
-	    !cinfo->codec_dai.name	||
-	    !(cinfo->codec		|| of_codec)	||
-	    !(cinfo->platform		|| of_platform)	||
-	    !(cinfo->cpu_dai.name	|| of_cpu)) {
-		dev_err(dev, "insufficient asoc_simple_card_info settings\n");
-		return -EINVAL;
+		if (!cinfo->name	||
+		    !cinfo->card	||
+		    !cinfo->codec_dai.name	||
+		    !cinfo->codec	||
+		    !cinfo->platform	||
+		    !cinfo->cpu_dai.name) {
+			dev_err(dev, "insufficient asoc_simple_card_info settings\n");
+			return -EINVAL;
+		}
 	}
 
 	/*
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
