Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3EXPci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 11:32:38 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:48959 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3EXPcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 11:32:36 -0400
MIME-Version: 1.0
X-Originating-IP: [139.11.160.113]
In-Reply-To: <519CFFDD.4080203@metafoo.de>
References: <519CD1CC.8070507@koalo.de>
	<519CFFDD.4080203@metafoo.de>
Date: Fri, 24 May 2013 17:32:35 +0200
Message-ID: <CABDT8WxS+Aq_feGqhzUMK-=DkZsnOULrH_fd+j0OP0czGnFdAw@mail.gmail.com>
Subject: Re: [PATCH] ASoC: Add support for BCM2708
From: Florian Meier <florian.meier@koalo.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        swarren@wwwdotorg.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/22 Lars-Peter Clausen <lars@metafoo.de>
>
> On 05/22/2013 04:10 PM, Florian Meier wrote:
> [...]
> > diff --git a/sound/soc/bcm2708/bcm2708-i2s.c b/sound/soc/bcm2708/bcm2708-i2s.c
> > new file mode 100644
> > index 0000000..a8e995f
> > --- /dev/null
> > +++ b/sound/soc/bcm2708/bcm2708-i2s.c
> > @@ -0,0 +1,964 @@
> [...]
> > +static int bcm2708_i2s_startup(struct snd_pcm_substream *substream,
> > +                            struct snd_soc_dai *dai)
> > +{
> > +     struct bcm2708_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
> > +
> > [...]
> > +             } else {
> > +                     snd_pcm_hw_constraint_minmax(substream->runtime,
> > +                                     SNDRV_PCM_HW_PARAM_RATE,
> > +                                     first_runtime->rate,
> > +                                     first_runtime->rate);
> > +             }
>
> Setting the symmetric_rates lets the core take care of setting the proper
> constraints on the rate. It probably makes sense to also add a
> symmetric_formats since this isn't the only driver that has the requirement
> that the formats for playback and capture match.


You are right! I forgot to remove this after I found the symmetric_rates flag.
For symmetric_formats I will have a closer look into the ALSA sources.



> [...]
> > diff --git a/sound/soc/bcm2708/bcm2708-pcm.c b/sound/soc/bcm2708/bcm2708-pcm.c
> > new file mode 100644
> > index 0000000..4b3e688
> > --- /dev/null
> > +++ b/sound/soc/bcm2708/bcm2708-pcm.c
> > @@ -0,0 +1,303 @@
>
> I think you should be able to remove the bulk of this driver by using the
> generic PCM dmaengine driver.


As implied in the header of this file, I would really like to use the
generic PCM dmaengine driver,
but I would also like to maintain compatibility to the Raspberry Pi
downstream kernel.
Therefore, I have to wait until the downstream kernel migrates to the
new version.



> [...]
> > +
> > +#include "bcm2708-pcm.h"
> > +
> > +static const struct snd_pcm_hardware bcm2708_pcm_hardware = {
> > +     .info                   = SNDRV_PCM_INFO_MMAP |
> > +                               SNDRV_PCM_INFO_MMAP_VALID |
> > +                               SNDRV_PCM_INFO_INTERLEAVED |
> > +                               SNDRV_PCM_INFO_PAUSE |
> > +                               SNDRV_PCM_INFO_RESUME |
> > +                               SNDRV_PCM_INFO_JOINT_DUPLEX |
> > +                               SNDRV_PCM_INFO_NO_PERIOD_WAKEUP,
>
> I don't think you actually support the last one, and neither pause and
> resume are supported.

I will have a closer look at these flags. Thanks!
