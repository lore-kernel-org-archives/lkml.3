Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935198AbaKNK71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:59:27 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58891 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934378AbaKNK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:59:25 -0500
Date: Fri, 14 Nov 2014 16:29:15 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ALSA: ice1712: consider error value
Message-ID: <20141114105915.GA10385@sudip-PC>
References: <1415961547-10330-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1415961547-10330-2-git-send-email-sudipm.mukherjee@gmail.com>
 <s5h61eihxkc.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h61eihxkc.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 11:43:31AM +0100, Takashi Iwai wrote:
> At Fri, 14 Nov 2014 16:09:06 +0530,
> Sudip Mukherjee wrote:
> > 
> > earlier we were ignoring the return value of snd_ak4114_create and
> > always returning 0.
> > now we are returning the actual status. revo_init is calling this
> > function, and revo_init is checking the return value.
> 
> It's not enough only to change there.  The problem is that
> spec->ak4114 is dereferenced after snd_ak4114_create(), and this might
> be NULL.  So it should return the error before that point.
> 

oops .. i should have looked carefully.

one more thought:
shouldn't we also do a kfree(spec) on error ?

thanks
sudip

> 
> Takashi
> 
> 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  sound/pci/ice1712/revo.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/sound/pci/ice1712/revo.c b/sound/pci/ice1712/revo.c
> > index 1112ec1..2835196 100644
> > --- a/sound/pci/ice1712/revo.c
> > +++ b/sound/pci/ice1712/revo.c
> > @@ -498,7 +498,7 @@ static int ap192_ak4114_init(struct snd_ice1712 *ice)
> >  	 * No reason to stop capture stream due to incorrect checks */
> >  	spec->ak4114->check_flags = AK4114_CHECK_NO_RATE;
> >  
> > -	return 0; /* error ignored; it's no fatal error */
> > +	return err;
> >  }
> >  
> >  static int revo_init(struct snd_ice1712 *ice)
> > -- 
> > 1.8.1.2
> > 
