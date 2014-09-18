Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbaIRLbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:31:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33157 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbaIRLbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:31:36 -0400
Date: Thu, 18 Sep 2014 17:01:25 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sound: pci: ctxfi: pr_* replaced with dev_*
Message-ID: <20140918113125.GA4625@sudip-PC>
References: <1410790181-16457-1-git-send-email-sudipm.mukherjee@gmail.com>
 <s5hvbop3qjn.wl-tiwai@suse.de>
 <20140915152554.GA26218@sudip-PC>
 <s5hwq94agtr.wl-tiwai@suse.de>
 <20140918092126.GA31651@sudip-PC>
 <s5hbnqd8c0v.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hbnqd8c0v.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:21:20PM +0200, Takashi Iwai wrote:
> At Thu, 18 Sep 2014 14:51:26 +0530,
> Sudip Mukherjee wrote:
> > 
> > On Mon, Sep 15, 2014 at 08:17:52PM +0200, Takashi Iwai wrote:
> > > At Mon, 15 Sep 2014 20:55:54 +0530,
> > > Sudip Mukherjee wrote:
> > > > 
> > > > On Mon, Sep 15, 2014 at 04:29:48PM +0200, Takashi Iwai wrote:
> > > > > At Mon, 15 Sep 2014 19:39:41 +0530,
> > > > > Sudip Mukherjee wrote:
> > <snip>
> > > > > > 
> > > > > > diff --git a/sound/pci/ctxfi/ctresource.c b/sound/pci/ctxfi/ctresource.c
> > > > > > index e49d2be..80beecb 100644
> > > > > > --- a/sound/pci/ctxfi/ctresource.c
> > > > > > +++ b/sound/pci/ctxfi/ctresource.c
> > > > > (snip)
> > > > > > @@ -282,8 +287,9 @@ int rsc_mgr_uninit(struct rsc_mgr *mgr)
> > > > > >  		case SUM:
> > > > > >  			break;
> > > > > >  		default:
> > > > > > -			pr_err("ctxfi: Invalid resource type value %d!\n",
> > > > > > -				mgr->type);
> > > > > > +			dev_err(&(((struct hw *)mgr->hw)->pci->dev),
> > > > > > +				"ctxfi: Invalid resource type value %d!\n",
> > > > > > +				 mgr->type);
> > > > > 
> > > > > Did you really conclude that this is the best way?
> > > > > Also, is it good to mix up the usages of both card->dev and &pci->dev?
> > > > > Think again.
> > > > > 
> > > > 
> > > > i have a doubt regarding this :- 
> > > > in the snd_card_new()  card->dev is being assigned with &pci->dev , 
> > > > then are not they the same ?
> > > 
> > > Yes, but how can it be guaranteed in future?  We may avoid the
> > > problems in future by keeping the consistency at this moment.  It's
> > > one of the good points of keeping code consistent, in addition to:
> > > increased readability / understandability and making the bug easier to
> > > be spotted.
> > 
> > understood the point.
> > > 
> > > > i was trying to get some way of finding out the reference of card->dev from the resource manager ,
> > > > but ...  :( 
> > > > i will try again and if i cant find any way i will ask for some hint from you.
> > > 
> > > Good!  A hint is that there is no 100% perfect way to achieve this.
> > > It's always compromise, and you'll have to choose which one is better
> > > than others.  For that, you'll have to evaluate multiple
> > > implementations, and it's a really good exercise for coding.
> > > 
> > 
> > i can find the rsc_mgr from the snd_card or ct_atc 
> > but if i want to find the reference to the device from the managers , then 
> > either i can go with
> > 1) &(((struct hw *)mgr->hw)->pci->dev) 
> > or
> > 2) use pci_get_drvdata with ((struct hw *)mgr->hw)->pci
> > or
> > 3) using container_of with &(((struct hw *)mgr->hw)->pci->dev) to find the pointer to snd_card via card_dev , but it becomes too complicated  :( 
> > 
> > we can get to all the managers (rsc_mgr, amixer_mgr, src_mgr ...) using atc->rsc_mgrs[] , then there should be some simple way to go
> > the opposite way (reaching atc from the managers)  . container_of will not work .. :( 
> > or am i missing something?? 
> 
> Adding a new field pointing to card to each struct.

i seriously did not think of that , i was under the impression that a newbie is not supposed to change or add to the designs.
anyways, i feel that i understand the code a little better than what i understood at the the time of my first patch.
and definitely your "writing-an-alsa-driver" has helped a lot .

thanks
sudip
> 
> 
> Takashi
