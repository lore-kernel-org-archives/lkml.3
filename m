Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaIOOfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:35:09 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:56462 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751979AbaIOOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:35:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3871:3873:4321:4384:4605:5007:7652:7903:9010:10004:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fall18_669bdf1c1733f
X-Filterd-Recvd-Size: 1726
Message-ID: <1410791701.18787.3.camel@joe-AO725>
Subject: Re: [PATCH v2] sound: pci: ctxfi: pr_* replaced with dev_*
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 07:35:01 -0700
In-Reply-To: <1410790181-16457-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1410790181-16457-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 19:39 +0530, Sudip Mukherjee wrote:
> pr_* macros replaced with dev_* as they are more preffered over pr_*.
[]
> diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
[]
> @@ -1282,8 +1282,8 @@ static int atc_identify_card(struct ct_atc *atc, unsigned int ssid)
>  	p = snd_pci_quirk_lookup_id(vendor_id, device_id, list);
>  	if (p) {
>  		if (p->value < 0) {
> -			pr_err("ctxfi: Device %04x:%04x is black-listed\n",
> -			       vendor_id, device_id);
> +			dev_err(atc->card->dev, "ctxfi: Device %04x:%04x is black-listed\n",
> +				vendor_id, device_id);

You should probably remove the "ctxfi: " from the dev_<level>
uses as the card->dev name is emitted by dev_err

			dev_err(atc->card->dev, "Device %04x:%04x is black-listed\n",
				vendor_id, device_id);


etc...


