Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaKWMxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 07:53:55 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:12854 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbaKWMxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 07:53:36 -0500
X-IronPort-AV: E=Sophos;i="5.07,443,1413237600"; 
   d="scan'208";a="109082633"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: kernel-janitors@vger.kernel.org, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] sound/soc/omap/am3517evm.c: fix error return code
Date: Sun, 23 Nov 2014 13:48:10 +0100
Message-Id: <1416746890-22719-10-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416746890-22719-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416746890-22719-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

It was forgotten to initialize ret to the result of calling
snd_soc_dai_set_sysclk, unlike at the other calls in the same function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/soc/omap/am3517evm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/omap/am3517evm.c b/sound/soc/omap/am3517evm.c
index 009533a..df65f98 100644
--- a/sound/soc/omap/am3517evm.c
+++ b/sound/soc/omap/am3517evm.c
@@ -59,7 +59,7 @@ static int am3517evm_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	snd_soc_dai_set_sysclk(cpu_dai, OMAP_MCBSP_FSR_SRC_FSX, 0,
+	ret = snd_soc_dai_set_sysclk(cpu_dai, OMAP_MCBSP_FSR_SRC_FSX, 0,
 				SND_SOC_CLOCK_IN);
 	if (ret < 0) {
 		printk(KERN_ERR "can't set CPU system clock OMAP_MCBSP_FSR_SRC_FSX\n");

