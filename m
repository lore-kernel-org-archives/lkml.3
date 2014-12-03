Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaLCR7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:59:37 -0500
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:38301 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750891AbaLCR7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:59:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:800:960:966:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3865:3866:3867:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4385:4605:5007:6119:6261:8603:9025:9592:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12663:12683:12740:13208:13229:14096:14097:14394:21060:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: scene77_53586b8e69949
X-Filterd-Recvd-Size: 4611
Message-ID: <1417629571.2902.16.camel@perches.com>
Subject: [PATCH] ALSA: ctxfi: Neaten get_daio_rsc
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Wed, 03 Dec 2014 09:59:31 -0800
In-Reply-To: <s5hh9xcr68v.wl-tiwai@suse.de>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <547E2612.6010304@users.sourceforge.net>
	 <s5hvblt6xav.wl-tiwai@suse.de> <547EF64B.1080403@users.sourceforge.net>
	 <s5h61dssy5n.wl-tiwai@suse.de> <1417626888.2902.13.camel@perches.com>
	 <s5hh9xcr68v.wl-tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the pointer declarations into the blocks that use them.
Neaten the kfree calls when the _init functions fail.

Trivially reduces object size (defconfig x86-64)

$ size sound/pci/ctxfi/ctdaio.o.*
   text	   data	    bss	    dec	    hex	filename
   5287	    224	      0	   5511	   1587	sound/pci/ctxfi/ctdaio.o.new
   5319	    224	      0	   5543	   15a7	sound/pci/ctxfi/ctdaio.o.old

Signed-off-by: Joe Perches <joe@perches.com>
Noticed-by: Markus Elfring <elfring@users.sourceforge.net>
---
On Wed, 2014-12-03 at 18:30 +0100, Takashi Iwai wrote:
> At Wed, 03 Dec 2014 09:14:48 -0800, Joe Perches wrote:
> > On Wed, 2014-12-03 at 13:41 +0100, Takashi Iwai wrote:
> > Takashi, what did you think of this?
> > https://lkml.org/lkml/2014/12/2/771
> > 
> > Just unnecessary?
> 
> Well, this one looks more consistent.  But honestly speaking, it's
> rather a matter of taste.  So I'm not so much inclined to merge the
> stuff, too, sorry.  If it's proven to reduce the compiled size, etc,
> I'll happily apply it, though.

 sound/pci/ctxfi/ctdaio.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index c1c3f88..9b87dd2 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -528,8 +528,6 @@ static int get_daio_rsc(struct daio_mgr *mgr,
 			struct daio **rdaio)
 {
 	int err;
-	struct dai *dai = NULL;
-	struct dao *dao = NULL;
 	unsigned long flags;
 
 	*rdaio = NULL;
@@ -544,27 +542,30 @@ static int get_daio_rsc(struct daio_mgr *mgr,
 		return err;
 	}
 
+	err = -ENOMEM;
 	/* Allocate mem for daio resource */
 	if (desc->type <= DAIO_OUT_MAX) {
-		dao = kzalloc(sizeof(*dao), GFP_KERNEL);
-		if (!dao) {
-			err = -ENOMEM;
+		struct dao *dao = kzalloc(sizeof(*dao), GFP_KERNEL);
+		if (!dao)
 			goto error;
-		}
+
 		err = dao_rsc_init(dao, desc, mgr);
-		if (err)
+		if (err) {
+			kfree(dao);
 			goto error;
+		}
 
 		*rdaio = &dao->daio;
 	} else {
-		dai = kzalloc(sizeof(*dai), GFP_KERNEL);
-		if (!dai) {
-			err = -ENOMEM;
+		struct dai *dai = kzalloc(sizeof(*dai), GFP_KERNEL);
+		if (!dai)
 			goto error;
-		}
+
 		err = dai_rsc_init(dai, desc, mgr);
-		if (err)
+		if (err) {
+			kfree(dai);
 			goto error;
+		}
 
 		*rdaio = &dai->daio;
 	}
@@ -575,11 +576,6 @@ static int get_daio_rsc(struct daio_mgr *mgr,
 	return 0;
 
 error:
-	if (dao)
-		kfree(dao);
-	else if (dai)
-		kfree(dai);
-
 	spin_lock_irqsave(&mgr->mgr_lock, flags);
 	daio_mgr_put_rsc(&mgr->mgr, desc->type);
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);


