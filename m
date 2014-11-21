Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaKUSfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:35:37 -0500
Received: from mout.web.de ([212.227.17.11]:60938 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaKUSfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:35:34 -0500
Message-ID: <546F85E6.5020306@users.sourceforge.net>
Date: Fri, 21 Nov 2014 19:35:18 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] ALSA: sb: Deletion of unnecessary checks before two function
 calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:rgam9Xkhq+QUuOFD/J2C5PvLmWBX5lBwk6TdgJt/wGWKmYXdFnk
 4HwGdV1sV7rWcXdRcurfIOGg5VSKtt/48JQIrHUvMmLshHz/xjfhUyHl4RU7Vmeim/EShCF
 +mK3eBJt3KkIYfKGtUu43f7GuwJzQ/S3PHOI6bk/YPcvBGtBmJ/nSGNAwHS7N0U1N1/9Z8x
 aNlMzmRfmozbQ4F0z6Izg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 19:32:02 +0100

The functions release_and_free_resource() and snd_util_memhdr_free() test
whether their argument is NULL and then return immediately.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/isa/sb/emu8000_synth.c | 3 +--
 sound/isa/sb/sb_common.c     | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/isa/sb/emu8000_synth.c b/sound/isa/sb/emu8000_synth.c
index 4e3fcfb..95b39be 100644
--- a/sound/isa/sb/emu8000_synth.c
+++ b/sound/isa/sb/emu8000_synth.c
@@ -105,8 +105,7 @@ static int snd_emu8000_delete_device(struct snd_seq_device *dev)
 		snd_device_free(dev->card, hw->pcm);
 	if (hw->emu)
 		snd_emux_free(hw->emu);
-	if (hw->memhdr)
-		snd_util_memhdr_free(hw->memhdr);
+	snd_util_memhdr_free(hw->memhdr);
 	hw->emu = NULL;
 	hw->memhdr = NULL;
 	return 0;
diff --git a/sound/isa/sb/sb_common.c b/sound/isa/sb/sb_common.c
index 3ef9906..f22b448 100644
--- a/sound/isa/sb/sb_common.c
+++ b/sound/isa/sb/sb_common.c
@@ -184,8 +184,7 @@ static int snd_sbdsp_probe(struct snd_sb * chip)
 
 static int snd_sbdsp_free(struct snd_sb *chip)
 {
-	if (chip->res_port)
-		release_and_free_resource(chip->res_port);
+	release_and_free_resource(chip->res_port);
 	if (chip->irq >= 0)
 		free_irq(chip->irq, (void *) chip);
 #ifdef CONFIG_ISA
-- 
2.1.3

