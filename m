Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbbADNWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 08:22:09 -0500
Received: from mout.web.de ([212.227.15.14]:53656 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbbADNWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 08:22:07 -0500
Message-ID: <54A93E67.8070105@users.sourceforge.net>
Date: Sun, 04 Jan 2015 14:21:43 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>,
        Johannes Berg <johannes@sipsolutions.net>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 9/13] ALSA: i2sbus: Delete an unnecessary check before the
 function call "snd_pcm_suspend_all"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A9355F.4050102@users.sourceforge.net>
In-Reply-To: <54A9355F.4050102@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:wSipFbYSKDrw7tnU+ETC6hNybJc3rRs1vqrsuEgkUMuinweCiz1
 dx7PkQ8XhMlPhDlD5FowDFcXIwW5MWFumz7JbE9xD/jQcKqvx8/SdyS2HZYDFJymp38MKX5
 DbuDKrWZC3mLiU7dBPDnmxjzJyl31txvz9h6gDqbe0ovZSj4z1Ez43zJUtips60iIFzVcXl
 x2JJtEF6GBR2wc4wbgATA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 3 Jan 2015 20:43:01 +0100

The snd_pcm_suspend_all() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/aoa/soundbus/i2sbus/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 4e2b4fb..837ba99 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -381,10 +381,8 @@ static int i2sbus_suspend(struct macio_dev* dev, pm_message_t state)
 
 	list_for_each_entry(i2sdev, &control->list, item) {
 		/* Notify Alsa */
-		if (i2sdev->sound.pcm) {
-			/* Suspend PCM streams */
-			snd_pcm_suspend_all(i2sdev->sound.pcm);
-		}
+		/* Suspend PCM streams */
+		snd_pcm_suspend_all(i2sdev->sound.pcm);
 
 		/* Notify codecs */
 		list_for_each_entry(cii, &i2sdev->sound.codec_list, list) {
-- 
2.2.1

