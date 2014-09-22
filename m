Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaIVIPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:15:52 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50210 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaIVIPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:15:48 -0400
Date: Mon, 22 Sep 2014 13:45:41 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] sound: pci: ctxfi: added reference of snd_card
Message-ID: <20140922081541.GC4870@sudip-PC>
References: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
 <s5h61gg6sq2.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h61gg6sq2.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 09:04:53AM +0200, Takashi Iwai wrote:
> At Sun, 21 Sep 2014 21:33:37 +0530,
> Sudip Mukherjee wrote:
> > 
> > added and initialized a pointer of snd_card in the struct hw to get a reference of
> > the card in other functions
> 
> You need to explain why this change is needed.  The above text shows
> what it'd do, but it doesn't give any explanation to convince why this
> patch must be merged in.  In this case, it's a preliminary patch for
> the changes to convert to dev_*() later.  It's the most important bit,
> so don't forget it.
>
then do i mention in the commit that it is the preliminary patch for the later changes to dev_* ?
i was thinking that we can get a reference of the card from other functions which are using struct hw
is a reason by itself.

thanks
sudip
> 
> thanks,
> 
> Takashi
> 
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  sound/pci/ctxfi/ctatc.c      | 1 +
> >  sound/pci/ctxfi/cthardware.h | 2 ++
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
> > index d92a08c..b21eda4 100644
> > --- a/sound/pci/ctxfi/ctatc.c
> > +++ b/sound/pci/ctxfi/ctatc.c
> > @@ -1333,6 +1333,7 @@ static int atc_create_hw_devs(struct ct_atc *atc)
> >  		pr_err("Failed to create hw obj!!!\n");
> >  		return err;
> >  	}
> > +	hw->card = atc->card;
> >  	atc->hw = hw;
> >  
> >  	/* Initialize card hardware. */
> > diff --git a/sound/pci/ctxfi/cthardware.h b/sound/pci/ctxfi/cthardware.h
> > index 5977e9a..940bbd0 100644
> > --- a/sound/pci/ctxfi/cthardware.h
> > +++ b/sound/pci/ctxfi/cthardware.h
> > @@ -20,6 +20,7 @@
> >  
> >  #include <linux/types.h>
> >  #include <linux/pci.h>
> > +#include <sound/core.h>
> >  
> >  enum CHIPTYP {
> >  	ATC20K1,
> > @@ -184,6 +185,7 @@ struct hw {
> >  	void *irq_callback_data;
> >  
> >  	struct pci_dev *pci;	/* the pci kernel structure of this card */
> > +	struct snd_card *card; /* pointer to this card */
> >  	int irq;
> >  	unsigned long io_base;
> >  	unsigned long mem_base;
> > -- 
> > 1.8.1.2
> > 
