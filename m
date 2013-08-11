Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3HKQ4G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:56:06 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:4795 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754256Ab3HKQwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717945"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/16] sound/soc/pxa/mioa701_wm9713.c: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:42 +0200
Message-Id: <1376239917-15594-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
arity of the called function.

The semantic match that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,f;
@@

f(...,
- ARRAY_AND_SIZE(e)
+ e,ARRAY_SIZE(e)
  ,...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 sound/soc/pxa/mioa701_wm9713.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/pxa/mioa701_wm9713.c b/sound/soc/pxa/mioa701_wm9713.c
index 97b711e..20fdce6 100644
--- a/sound/soc/pxa/mioa701_wm9713.c
+++ b/sound/soc/pxa/mioa701_wm9713.c
@@ -133,10 +133,11 @@ static int mioa701_wm9713_init(struct snd_soc_pcm_runtime *rtd)
 	unsigned short reg;
 
 	/* Add mioa701 specific widgets */
-	snd_soc_dapm_new_controls(dapm, ARRAY_AND_SIZE(mioa701_dapm_widgets));
+	snd_soc_dapm_new_controls(dapm, mioa701_dapm_widgets,
+				  ARRAY_SIZE(mioa701_dapm_widgets));
 
 	/* Set up mioa701 specific audio path audio_mapnects */
-	snd_soc_dapm_add_routes(dapm, ARRAY_AND_SIZE(audio_map));
+	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
 
 	/* Prepare GPIO8 for rear speaker amplifier */
 	reg = codec->driver->read(codec, AC97_GPIO_CFG);

