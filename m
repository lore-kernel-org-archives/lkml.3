Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaKNITS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:19:18 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43634 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbaKNITR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:19:17 -0500
Date: Fri, 14 Nov 2014 13:49:07 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2/2] ALSA: ice1712: remove unused variable
Message-ID: <20141114081907.GA6796@sudip-PC>
References: <1415891657-7244-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1415891657-7244-2-git-send-email-sudipm.mukherjee@gmail.com>
 <s5h1tp7jfay.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h1tp7jfay.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 04:22:45PM +0100, Takashi Iwai wrote:
> At Thu, 13 Nov 2014 20:44:17 +0530,
> Sudip Mukherjee wrote:
> > 
<snip>
> >  	if (snd_pcm_format_width(runtime->format) == 16)
> >  		tmp &= ~0x04;
> > diff --git a/sound/pci/ice1712/revo.c b/sound/pci/ice1712/revo.c
> > index 1112ec1..1f40dab 100644
> > --- a/sound/pci/ice1712/revo.c
> > +++ b/sound/pci/ice1712/revo.c
> > @@ -481,7 +481,6 @@ static int ap192_ak4114_init(struct snd_ice1712 *ice)
> >  	static const unsigned char ak4114_init_txcsb[] = {
> >  		0x41, 0x02, 0x2c, 0x00, 0x00
> >  	};
> > -	int err;
> >  
> >  	struct revo51_spec *spec;
> >  	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
> > @@ -489,11 +488,9 @@ static int ap192_ak4114_init(struct snd_ice1712 *ice)
> >  		return -ENOMEM;
> >  	ice->spec = spec;
> >  
> > -	err = snd_ak4114_create(ice->card,
> > -				 ap192_ak4114_read,
> > -				 ap192_ak4114_write,
> > -				 ak4114_init_vals, ak4114_init_txcsb,
> > -				 ice, &spec->ak4114);
> > +	snd_ak4114_create(ice->card, ap192_ak4114_read, ap192_ak4114_write,
> > +			  ak4114_init_vals, ak4114_init_txcsb, ice,
> > +			  &spec->ak4114);
> 
> IMO, this is rather a bug.  It should return the error (with a proper
> error handling).
> 
error handling is already there. ap192_ak4114_init is being called by revo_init,
where the return value is being checked. revo_init is the callback function of
chip_init, so if we return the error value here then chip_init will fail.
but since the author commented "error ignored; it's no fatal error", so i also
thought of ignoring the error.
I will send you a revised patch.

thanks
sudip


> 
> thanks,
> 
> Takashi
> 
> 
> >  	/* AK4114 in Revo cannot detect external rate correctly.
> >  	 * No reason to stop capture stream due to incorrect checks */
> >  	spec->ak4114->check_flags = AK4114_CHECK_NO_RATE;
> > -- 
> > 1.8.1.2
> > 
> > _______________________________________________
> > Alsa-devel mailing list
> > Alsa-devel@alsa-project.org
> > http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> > 
