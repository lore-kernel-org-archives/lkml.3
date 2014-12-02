Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbaLBVHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:07:51 -0500
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:47943 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932365AbaLBVHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:07:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:599:960:965:966:973:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3868:3871:4321:4385:4390:4395:5007:6261:7576:7903:8660:9592:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:12740:13148:13230:13255:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fall57_43b8a8403661e
X-Filterd-Recvd-Size: 4440
Message-ID: <1417554464.2902.4.camel@perches.com>
Subject: Re: [PATCH 1/2] ALSA: ctxfi: Deletion of an unnecessary check
 before the function call "kfree"
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Date: Tue, 02 Dec 2014 13:07:44 -0800
In-Reply-To: <547E2738.1090708@users.sourceforge.net>
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
	 <547E2738.1090708@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-02 at 21:55 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 2 Dec 2014 20:00:33 +0100
> 
> The kfree() function performs also input parameter validation.
> Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  sound/pci/ctxfi/ctdaio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
> index c1c3f88..1712332 100644
> --- a/sound/pci/ctxfi/ctdaio.c
> +++ b/sound/pci/ctxfi/ctdaio.c
> @@ -577,7 +577,7 @@ static int get_daio_rsc(struct daio_mgr *mgr,
>  error:
>  	if (dao)
>  		kfree(dao);
> -	else if (dai)
> +	else
>  		kfree(dai);
>  
>  	spin_lock_irqsave(&mgr->mgr_lock, flags);

I think this not nice and would prefer something like:

---
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


