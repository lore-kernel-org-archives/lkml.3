Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaIVIIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:08:31 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55692 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaIVII2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:08:28 -0400
Date: Mon, 22 Sep 2014 13:38:16 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] sound: pci: ctxfi: pr_* replaced with dev_*
Message-ID: <20140922080816.GA4870@sudip-PC>
References: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1411315421-24138-3-git-send-email-sudipm.mukherjee@gmail.com>
 <s5h4mw06skq.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h4mw06skq.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 09:08:05AM +0200, Takashi Iwai wrote:
> At Sun, 21 Sep 2014 21:33:39 +0530,
> Sudip Mukherjee wrote:
> > 
> > pr_* macros replaced with dev_* as they are more preffered over pr_*.
> 
> In this patch, it's not trivial conversion, so it's not bad to spend
> more words to explain how you did it.  Nevertheless...
> 
> (snip)
> > diff --git a/sound/pci/ctxfi/ctamixer.c b/sound/pci/ctxfi/ctamixer.c
> > index fed6e6a..955b2af 100644
> > --- a/sound/pci/ctxfi/ctamixer.c
> > +++ b/sound/pci/ctxfi/ctamixer.c
> > @@ -258,7 +258,8 @@ static int get_amixer_rsc(struct amixer_mgr *mgr,
> >  	}
> >  	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
> >  	if (err) {
> > -		pr_err("ctxfi: Can't meet AMIXER resource request!\n");
> > +		dev_err(((struct hw *)(mgr->mgr.hw))->card->dev,
> > +			"Can't meet AMIXER resource request!\n");
> 
> Do we agree that such a change is too ugly, right?  And...
yes , it looks bad. we can have a pointer to the card in the struct of the managers.
> 
> > diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
> > index 3e29e13..6c185d0 100644
> > --- a/sound/pci/ctxfi/ctatc.c
> > +++ b/sound/pci/ctxfi/ctatc.c
> > @@ -186,7 +186,7 @@ static unsigned int convert_format(snd_pcm_format_t snd_format,
> >  	case SNDRV_PCM_FORMAT_FLOAT_LE:
> >  		return SRC_SF_F32;
> >  	default:
> > -		pr_err("ctxfi: not recognized snd format is %d\n",
> > +		dev_err(card->dev, "ctxfi: not recognized snd format is %d\n",
> >  			snd_format);
> 
> You forgot to strip the superfluous prefix in many places.

oops .. sorry .. 

sudip
> 
> 
> Takashi
