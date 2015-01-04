Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbbADMzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 07:55:53 -0500
Received: from mout.web.de ([212.227.15.14]:51000 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbADMzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 07:55:52 -0500
Message-ID: <54A9384D.4080302@users.sourceforge.net>
Date: Sun, 04 Jan 2015 13:55:41 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 3/13] ALSA: emu10k1: Delete an unnecessary check before the
 function call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A9355F.4050102@users.sourceforge.net>
In-Reply-To: <54A9355F.4050102@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Pd1e3PmAhaUsmY13JyQruJU9P2dWa4qm+Tf8HBKgIMrKModHROz
 DOW7MECs6LJgdRkgSgWzfS/k1zSyEd81nOCRnCTL9AHxaSyZOwUM4J7TTVhLbIFtszJsU87
 ReBq6AjkFNIVjpfIfqtFnJfXE6WC+SZfuM8aLb/EAGG0rSCsRQ6eeMMXEdYxNtphRI+L/XB
 V2deWbf06gkAMEQSzSpLQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 3 Jan 2015 17:06:04 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/pci/emu10k1/p16v.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/pci/emu10k1/p16v.c b/sound/pci/emu10k1/p16v.c
index b672755..3c60b43 100644
--- a/sound/pci/emu10k1/p16v.c
+++ b/sound/pci/emu10k1/p16v.c
@@ -166,11 +166,8 @@ static struct snd_pcm_hardware snd_p16v_capture_hw = {
 static void snd_p16v_pcm_free_substream(struct snd_pcm_runtime *runtime)
 {
 	struct snd_emu10k1_pcm *epcm = runtime->private_data;
-  
-	if (epcm) {
-		/* dev_dbg(emu->card->dev, "epcm free: %p\n", epcm); */
-		kfree(epcm);
-	}
+
+	kfree(epcm);
 }
 
 /* open_playback callback */
-- 
2.2.1

