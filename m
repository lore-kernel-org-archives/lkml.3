Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750820AbaKURlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:41:09 -0500
Received: from mout.web.de ([212.227.15.4]:58596 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbaKURlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:41:08 -0500
Message-ID: <546F7921.2000406@users.sourceforge.net>
Date: Fri, 21 Nov 2014 18:40:49 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] ALSA: core: Deletion of unnecessary checks before two
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:y34nu6WsO5Ap/99qmvyIUdaN31m0GLrVWqThZRcRryG6Mur5C4H
 lOQRPBQ64wJ4NIfXYd6R4JF2tkud6FLNA8f0YG1/LPDAiHKkjBGNn4xaLaU8Q9QcIiV1msx
 4KCcc/4U83K27ucDjuRNceR94+Se6ABwNukKNxTzxTyIxl04P14nx04LDXR6lFfUrSxeDh4
 TfyIMKgzcHzyUHWvmO7bA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 18:34:48 +0100

The functions snd_seq_oss_timer_delete() and vunmap() perform also input
parameter validation. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/core/seq/oss/seq_oss_init.c | 9 +++------
 sound/core/sgbuf.c                | 3 +--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index b9184d2..b0e32e1 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -403,14 +403,11 @@ free_devinfo(void *private)
 {
 	struct seq_oss_devinfo *dp = (struct seq_oss_devinfo *)private;
 
-	if (dp->timer)
-		snd_seq_oss_timer_delete(dp->timer);
+	snd_seq_oss_timer_delete(dp->timer);
 		
-	if (dp->writeq)
-		snd_seq_oss_writeq_delete(dp->writeq);
+	snd_seq_oss_writeq_delete(dp->writeq);
 
-	if (dp->readq)
-		snd_seq_oss_readq_delete(dp->readq);
+	snd_seq_oss_readq_delete(dp->readq);
 	
 	kfree(dp);
 }
diff --git a/sound/core/sgbuf.c b/sound/core/sgbuf.c
index 0a41850..84fffab 100644
--- a/sound/core/sgbuf.c
+++ b/sound/core/sgbuf.c
@@ -39,8 +39,7 @@ int snd_free_sgbuf_pages(struct snd_dma_buffer *dmab)
 	if (! sgbuf)
 		return -EINVAL;
 
-	if (dmab->area)
-		vunmap(dmab->area);
+	vunmap(dmab->area);
 	dmab->area = NULL;
 
 	tmpb.dev.type = SNDRV_DMA_TYPE_DEV;
-- 
2.1.3

