Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaKWTLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:11:19 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:35890 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbaKWTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:11:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,444,1413237600"; 
   d="scan'208";a="109113985"
Date: Sun, 23 Nov 2014 20:11:15 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
cc: Jaroslav Kysela <perex@perex.cz>, kernel-janitors@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] sound/pci/ctxfi/ctatc.c: fix error return code
In-Reply-To: <20141123171505.GA8265@sudip-PC>
Message-ID: <alpine.DEB.2.02.1411232010410.2071@localhost6.localdomain6>
References: <1416746890-22719-1-git-send-email-Julia.Lawall@lip6.fr> <1416746890-22719-6-git-send-email-Julia.Lawall@lip6.fr> <20141123171505.GA8265@sudip-PC>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Nov 2014, Sudip Mukherjee wrote:

> On Sun, Nov 23, 2014 at 01:48:06PM +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Initialize err before returning on failure, as done elsewhere in the
> > function.
> <snip>
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > ---
> >  sound/pci/ctxfi/ctatc.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
> > index 58b235c..a2f997a 100644
> > --- a/sound/pci/ctxfi/ctatc.c
> > +++ b/sound/pci/ctxfi/ctatc.c
> > @@ -1725,8 +1725,10 @@ int __devinit ct_atc_create(struct snd_card *card, struct pci_dev *pci,
> >  	atc_connect_resources(atc);
> >  
> >  	atc->timer = ct_timer_new(atc);
> > -	if (!atc->timer)
> > +	if (!atc->timer) {
> > +		err = -ENOMEM;
> >  		goto error1;
> > +	}
> >  
> >  	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, atc, &ops);
> >  	if (err < 0)
> > 
> just a small doubt..
> looks like this patch you have already sent on 19 Aug 2012 and has been already applied via 4d8ce1c9966663bad69e738952179f3cc52710bf
> 
> or am i missing something?

Yes, very sorry.  I sent out the wrong patch series.

julia
