Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaIOP0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:26:13 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41333 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaIOP0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:26:12 -0400
Date: Mon, 15 Sep 2014 20:55:54 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sound: pci: ctxfi: pr_* replaced with dev_*
Message-ID: <20140915152554.GA26218@sudip-PC>
References: <1410790181-16457-1-git-send-email-sudipm.mukherjee@gmail.com>
 <s5hvbop3qjn.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hvbop3qjn.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 04:29:48PM +0200, Takashi Iwai wrote:
> At Mon, 15 Sep 2014 19:39:41 +0530,
> Sudip Mukherjee wrote:
> > 
> > pr_* macros replaced with dev_* as they are more preffered over pr_*.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> > 
> > in v1 Takashi mentioned that now we have card->dev
> > so v2 is using card->dev as much as possible.
> > 
> >  sound/pci/ctxfi/ctatc.c      | 24 ++++++++++++++----------
> >  sound/pci/ctxfi/cthw20k1.c   | 15 +++++++++------
> >  sound/pci/ctxfi/cthw20k2.c   | 22 ++++++++++++++--------
> >  sound/pci/ctxfi/ctmixer.c    |  6 ++++--
> >  sound/pci/ctxfi/ctpcm.c      |  9 ++++++---
> >  sound/pci/ctxfi/ctresource.c | 20 +++++++++++++-------
> >  sound/pci/ctxfi/xfi.c        | 15 +++++++++------
> >  7 files changed, 69 insertions(+), 42 deletions(-)
> > 
> > diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
> > index d92a08c..a786bc1 100644
> > --- a/sound/pci/ctxfi/ctatc.c
> > +++ b/sound/pci/ctxfi/ctatc.c
> > @@ -1282,8 +1282,8 @@ static int atc_identify_card(struct ct_atc *atc, unsigned int ssid)
> >  	p = snd_pci_quirk_lookup_id(vendor_id, device_id, list);
> >  	if (p) {
> >  		if (p->value < 0) {
> > -			pr_err("ctxfi: Device %04x:%04x is black-listed\n",
> > -			       vendor_id, device_id);
> > +			dev_err(atc->card->dev, "ctxfi: Device %04x:%04x is black-listed\n",
> > +				vendor_id, device_id);
> 
> You need no prefix for dev_xxx().
> 
i was also thinking that . :)
> > diff --git a/sound/pci/ctxfi/ctresource.c b/sound/pci/ctxfi/ctresource.c
> > index e49d2be..80beecb 100644
> > --- a/sound/pci/ctxfi/ctresource.c
> > +++ b/sound/pci/ctxfi/ctresource.c
> (snip)
> > @@ -282,8 +287,9 @@ int rsc_mgr_uninit(struct rsc_mgr *mgr)
> >  		case SUM:
> >  			break;
> >  		default:
> > -			pr_err("ctxfi: Invalid resource type value %d!\n",
> > -				mgr->type);
> > +			dev_err(&(((struct hw *)mgr->hw)->pci->dev),
> > +				"ctxfi: Invalid resource type value %d!\n",
> > +				 mgr->type);
> 
> Did you really conclude that this is the best way?
> Also, is it good to mix up the usages of both card->dev and &pci->dev?
> Think again.
> 

i have a doubt regarding this :- 
in the snd_card_new()  card->dev is being assigned with &pci->dev , 
then are not they the same ?

i was trying to get some way of finding out the reference of card->dev from the resource manager ,
but ...  :( 
i will try again and if i cant find any way i will ask for some hint from you.

i am still a newbie , and started this  pr_* to dev_* on your inspiration , and i hope
you will not be irritated by my patches . :)

thanks
sudip


> 
> thanks,
> 
> Takashi
