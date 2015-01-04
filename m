Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbbADNDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 08:03:00 -0500
Received: from mout.web.de ([212.227.17.11]:50378 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbbADNC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 08:02:59 -0500
Message-ID: <54A939F9.1060809@users.sourceforge.net>
Date: Sun, 04 Jan 2015 14:02:49 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 5/13] ALSA: emux: Delete an unnecessary check before the function
 call "snd_sf_free"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A9355F.4050102@users.sourceforge.net>
In-Reply-To: <54A9355F.4050102@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:64HA1EsDmBvlQDAamCYL5XUGM89si5JiSZRkcUlvs/4fGzyBHuv
 PVzx5AKdd6dKMkVXjlk9MrjVJIGkp0VjI8UZ/IB3owob5gZ9RipKkzEWZRDU8WLIJn6anzc
 yS+Z3jzgVrHV+r3OPYhUVwlGwNEUHej6SxchFKaj37yBOwOpF4Ygk4ucdU3+h80M8YJhMTC
 ugQRDfazIv49nEYPahLnQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 3 Jan 2015 18:28:21 +0100

The snd_sf_free() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/synth/emux/emux.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index 9352207..f27a1c8 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -160,12 +160,8 @@ int snd_emux_free(struct snd_emux *emu)
 	snd_emux_detach_seq_oss(emu);
 #endif
 	snd_emux_detach_seq(emu);
-
 	snd_emux_delete_hwdep(emu);
-
-	if (emu->sflist)
-		snd_sf_free(emu->sflist);
-
+	snd_sf_free(emu->sflist);
 	kfree(emu->voices);
 	kfree(emu->name);
 	kfree(emu);
-- 
2.2.1

