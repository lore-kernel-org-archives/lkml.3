Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaLBR4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:56:41 -0500
Received: from mout.web.de ([212.227.15.14]:62433 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbaLBR4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:56:38 -0500
Message-ID: <547DFD4E.50207@users.sourceforge.net>
Date: Tue, 02 Dec 2014 18:56:30 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] ALSA: trident: Deletion of a check before snd_util_memhdr_free()
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:54Os4YkjEg8Fkr00bzXBv18bzZRe176UEW6kuHUhB+ZQrE1+gc3
 ymUZzyAk7xYDBsiz3Y0ip5dn53IU9PNgr66ULxGh/ZMY6Sxgm3lYZT2IAgP751shlMMJcC/
 jNHzF6QZqnhxdixn8prM7wlzwtExm1BYuahPKd6tI9sn0fnwFJqlt7CQ96VwFs/ZElQXDds
 XWpRfoFs6A2gvEcnxYGwA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Dec 2014 18:52:21 +0100

The snd_util_memhdr_free() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/pci/trident/trident_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/pci/trident/trident_main.c b/sound/pci/trident/trident_main.c
index da875dc..57cd757 100644
--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -3702,8 +3702,7 @@ static int snd_trident_free(struct snd_trident *trident)
 		free_irq(trident->irq, trident);
 	if (trident->tlb.buffer.area) {
 		outl(0, TRID_REG(trident, NX_TLBC));
-		if (trident->tlb.memhdr)
-			snd_util_memhdr_free(trident->tlb.memhdr);
+		snd_util_memhdr_free(trident->tlb.memhdr);
 		if (trident->tlb.silent_page.area)
 			snd_dma_free_pages(&trident->tlb.silent_page);
 		vfree(trident->tlb.shadow_entries);
-- 
2.1.3

