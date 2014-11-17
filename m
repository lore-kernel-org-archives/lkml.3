Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaKQKed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:34:33 -0500
Received: from mout.web.de ([212.227.15.14]:64161 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbaKQKec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:34:32 -0500
Message-ID: <5469CF2E.6040408@users.sourceforge.net>
Date: Mon, 17 Nov 2014 11:34:22 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] ALSA: ice17xx: Deletion of unnecessary checks before
 the function call "snd_ac97_resume"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:w2eKxJz5q+eK68kzcpy6e8QuVOMyS0KTaREvvDKQzVxPdOmmktM
 jHfKax0QkRI5Wlr4/kMJ7vG9dl+R2o+iLNCXQS4idZoNE3QxOcmErW4vOl+CHGvk9vGL+jZ
 4pPmuiDQ2a+//EIQdrg2fYmSbDObjHC1yqbIZkeD7AmNMAcRPEBNyZclEFsuKwTNfvbs9c8
 wwMiwEqe7aJmubLIuwqhA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 17 Nov 2014 11:28:02 +0100

The snd_ac97_resume() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/pci/ice1712/ice1712.c | 3 +--
 sound/pci/ice1712/ice1724.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 87f7fc4..e1e18b5 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2905,8 +2905,7 @@ static int snd_ice1712_resume(struct device *dev)
 	outw(ice->pm_saved_spdif_ctrl, ICEMT(ice, ROUTE_SPDOUT));
 	outw(ice->pm_saved_route, ICEMT(ice, ROUTE_PSDOUT03));
 
-	if (ice->ac97)
-		snd_ac97_resume(ice->ac97);
+	snd_ac97_resume(ice->ac97);
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 	return 0;
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 08cb08a..0e56835 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2884,8 +2884,7 @@ static int snd_vt1724_resume(struct device *dev)
 	outb(ice->pm_saved_spdif_cfg, ICEREG1724(ice, SPDIF_CFG));
 	outl(ice->pm_saved_route, ICEMT1724(ice, ROUTE_PLAYBACK));
 
-	if (ice->ac97)
-		snd_ac97_resume(ice->ac97);
+	snd_ac97_resume(ice->ac97);
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 	return 0;
-- 
2.1.3


