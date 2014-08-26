Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbaHZHvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:51:13 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41509 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHZHvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:51:12 -0400
Date: Tue, 26 Aug 2014 13:21:00 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: pci: ctxfi: ctatc.c: printk replacement
Message-ID: <20140826075100.GA1751@sudip-PC>
References: <1408989412-30805-1-git-send-email-sudipm.mukherjee@gmail.com>
 <s5h8umbu5oi.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8umbu5oi.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 08:27:09AM +0200, Takashi Iwai wrote:
> At Mon, 25 Aug 2014 23:26:52 +0530,
> Sudip Mukherjee wrote:
> > 
> > printk replaced ith corresponding pr_err
> > fixed three broken user-visible strings
> > fixed a checkpatch warning of space before new line
> 
> Fixes are good, but is this the final patch for ctxfi?
> If you're going to post another one, please fold them into a single
> patch.  All patches do basically the same job, so splitting patches
> doesn't help much in such a case.  Patches should be split logically.
> 
> Also, if you fix broken strings, better to do it consistently to all
> targeted strings, instead of picking up random ones.
> 
> 
> thanks,
> 
> Takashi

Hi,
I was posting them separately as i was thinking it will become a big patch. 
For the broken string , it was actually not random . I did it only for those string that were affected by my patch.
Anyways, I will send you a complete one for ctxfi.

thanks
sudip

> 
> > 
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  sound/pci/ctxfi/ctatc.c | 23 ++++++++++-------------
> >  1 file changed, 10 insertions(+), 13 deletions(-)
> > 
> > diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
> > index af632bd..41597a8 100644
> > --- a/sound/pci/ctxfi/ctatc.c
> > +++ b/sound/pci/ctxfi/ctatc.c
> > @@ -185,7 +185,7 @@ static unsigned int convert_format(snd_pcm_format_t snd_format)
> >  	case SNDRV_PCM_FORMAT_FLOAT_LE:
> >  		return SRC_SF_F32;
> >  	default:
> > -		printk(KERN_ERR "ctxfi: not recognized snd format is %d \n",
> > +		pr_err("ctxfi: not recognized snd format is %d\n",
> >  			snd_format);
> >  		return SRC_SF_S16;
> >  	}
> > @@ -1282,7 +1282,7 @@ static int atc_identify_card(struct ct_atc *atc, unsigned int ssid)
> >  	p = snd_pci_quirk_lookup_id(vendor_id, device_id, list);
> >  	if (p) {
> >  		if (p->value < 0) {
> > -			printk(KERN_ERR "ctxfi: "
> > +			pr_err("ctxfi: "
> >  			       "Device %04x:%04x is black-listed\n",
> >  			       vendor_id, device_id);
> >  			return -ENOENT;
> > @@ -1315,8 +1315,7 @@ int ct_atc_create_alsa_devs(struct ct_atc *atc)
> >  		err = alsa_dev_funcs[i].create(atc, i,
> >  				alsa_dev_funcs[i].public_name);
> >  		if (err) {
> > -			printk(KERN_ERR "ctxfi: "
> > -			       "Creating alsa device %d failed!\n", i);
> > +			pr_err("ctxfi: Creating alsa device %d failed!\n", i);
> >  			return err;
> >  		}
> >  	}
> > @@ -1332,7 +1331,7 @@ static int atc_create_hw_devs(struct ct_atc *atc)
> >  
> >  	err = create_hw_obj(atc->pci, atc->chip_type, atc->model, &hw);
> >  	if (err) {
> > -		printk(KERN_ERR "Failed to create hw obj!!!\n");
> > +		pr_err("Failed to create hw obj!!!\n");
> >  		return err;
> >  	}
> >  	atc->hw = hw;
> > @@ -1351,8 +1350,7 @@ static int atc_create_hw_devs(struct ct_atc *atc)
> >  
> >  		err = rsc_mgr_funcs[i].create(atc->hw, &atc->rsc_mgrs[i]);
> >  		if (err) {
> > -			printk(KERN_ERR "ctxfi: "
> > -			       "Failed to create rsc_mgr %d!!!\n", i);
> > +			pr_err("ctxfi: Failed to create rsc_mgr %d!!!\n", i);
> >  			return err;
> >  		}
> >  	}
> > @@ -1399,7 +1397,7 @@ static int atc_get_resources(struct ct_atc *atc)
> >  		err = daio_mgr->get_daio(daio_mgr, &da_desc,
> >  					(struct daio **)&atc->daios[i]);
> >  		if (err) {
> > -			printk(KERN_ERR "ctxfi: Failed to get DAIO "
> > +			pr_err("ctxfi: Failed to get DAIO "
> >  					"resource %d!!!\n", i);
> >  			return err;
> >  		}
> > @@ -1603,8 +1601,7 @@ static int atc_resume(struct ct_atc *atc)
> >  	/* Do hardware resume. */
> >  	err = atc_hw_resume(atc);
> >  	if (err < 0) {
> > -		printk(KERN_ERR "ctxfi: pci_enable_device failed, "
> > -		       "disabling device\n");
> > +		pr_err("ctxfi: pci_enable_device failed, disabling device\n");
> >  		snd_card_disconnect(atc->card);
> >  		return err;
> >  	}
> > @@ -1701,7 +1698,7 @@ int ct_atc_create(struct snd_card *card, struct pci_dev *pci,
> >  	/* Find card model */
> >  	err = atc_identify_card(atc, ssid);
> >  	if (err < 0) {
> > -		printk(KERN_ERR "ctatc: Card not recognised\n");
> > +		pr_err("ctatc: Card not recognised\n");
> >  		goto error1;
> >  	}
> >  
> > @@ -1717,7 +1714,7 @@ int ct_atc_create(struct snd_card *card, struct pci_dev *pci,
> >  
> >  	err = ct_mixer_create(atc, (struct ct_mixer **)&atc->mixer);
> >  	if (err) {
> > -		printk(KERN_ERR "ctxfi: Failed to create mixer obj!!!\n");
> > +		pr_err("ctxfi: Failed to create mixer obj!!!\n");
> >  		goto error1;
> >  	}
> >  
> > @@ -1744,6 +1741,6 @@ int ct_atc_create(struct snd_card *card, struct pci_dev *pci,
> >  
> >  error1:
> >  	ct_atc_destroy(atc);
> > -	printk(KERN_ERR "ctxfi: Something wrong!!!\n");
> > +	pr_err("ctxfi: Something wrong!!!\n");
> >  	return err;
> >  }
> > -- 
> > 1.8.1.2
> > 
