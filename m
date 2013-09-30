Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3I3Sm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:42:29 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:37890 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab3I3Sm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:42:28 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 2/2] [RESEND] snd-ac97-codec: Use complete =?iso-8859-1?q?ID=09when_the_codec_is_not?= known
Date: Mon, 30 Sep 2013 20:42:03 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
References: <201309272028.03764.linux@rainbow-software.org> <s5h61ti7k2l.wl%tiwai@suse.de>
In-Reply-To: <s5h61ti7k2l.wl%tiwai@suse.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201309302042.04122.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 September 2013 11:08:50 Takashi Iwai wrote:
> At Fri, 27 Sep 2013 20:28:03 +0200,
>
> Ondrej Zary wrote:
> > Currently, if the codec ID is not known, the last byte of the ID is used
> > as name. It's not helpful at all, use full codec ID instead.
>
> The full bytes are already shown at the beginning, no?
> It's masked because the upper three bytes are shown in printable form,
> and the last byte is usually a model number.

Thanks, I see now. So this patch is not needed.

>
> Takashi
>
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> >  sound/pci/ac97/ac97_codec.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
> > index bf578ba2..30a40a8 100644
> > --- a/sound/pci/ac97/ac97_codec.c
> > +++ b/sound/pci/ac97/ac97_codec.c
> > @@ -1830,7 +1830,7 @@ void snd_ac97_get_name(struct snd_ac97 *ac97,
> > unsigned int id, char *name, int m pid->patch(ac97);
> >  		}
> >  	} else
> > -		sprintf(name + strlen(name), " id %x", id & 0xff);
> > +		sprintf(name + strlen(name), " id %x", id);
> >  }
> >
> >  /**
> > --
> > Ondrej Zary
> > _______________________________________________
> > Alsa-devel mailing list
> > Alsa-devel@alsa-project.org
> > http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel


-- 
Ondrej Zary
