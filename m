Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3FJJEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:04:20 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50390 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3FJJEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:04:16 -0400
Date: Mon, 10 Jun 2013 10:04:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 12/32] ARM: ux500: Remove superfluous 'psize' attribute
 from Audio platform data
Message-ID: <20130610090411.GB20297@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-13-git-send-email-lee.jones@linaro.org>
 <20130501144213.GG25256@gmail.com>
 <20130502083849.GH25256@gmail.com>
 <CACRpkdYbqU=bHrzf6Vpv-KFYN_+z6+y1ocNHtkLEO7ihHEd=dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYbqU=bHrzf6Vpv-KFYN_+z6+y1ocNHtkLEO7ihHEd=dA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Linus Walleij wrote:

> On Thu, May 2, 2013 at 10:38 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> >> > 'psize' is used to calculate the maximum DMA burst size. However it
> >> > is only taken into consideration when editing the DMA channel's
> >> > configuration. The Audio DMA platform data is only used to allocate
> >> > a channel, not configure it. That will be done at a later date within
> >> > the MSP driver.
> >> >
> >> > We're also removing comments which are no longer required, as
> >> > 'data_width' is no longer set in any device's platform data period.
> >> >
> >> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> >> Linus Walleij wrote:
> >> So if I understand correctly this is now handled by dmaengine_pcm.c,
> >> os that right?
> >
> > Unfortunately not. At the moment ux500 sound is very broken in
> > Mainline. I looked at it recently and the driver is almost completely
> > different to the one maintained internally.
> 
> I was more thinking that the dmaengine_pcm.c which appears
> to have its functions called from the ux500 ASoC driver should
> do the calls to slave config to set up proper DMA characteristics
> for the channel.
> 
> Maybe that part is in the MSP driver as you say, is that so?
> 
> > There were DMA changes relating to this driver pending for v3.10,
> > which I believe have just been taking into -next. I will straighten
> > out the DMA issues shortly, but there are other ones remaining still -
> > mostly surrounding widgets. Ideally this is something Ola should fix,
> > as he has the expertise to do so, but he doesn't appear to have been
> > very active upstream of late.
> 
> IIRC there are also patches from Fabio to this stuff so I'm
> a bit confused, but if the intention is to merge this through
> ASoC with some other stuff, by all means:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Linus,

Would you mind taking this through your tree now that the DMA stuff
has gone in please?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
