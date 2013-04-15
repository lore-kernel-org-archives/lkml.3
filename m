Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935234Ab3DOIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:09:26 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:34015 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab3DOIJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:09:24 -0400
Date: Mon, 15 Apr 2013 09:09:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: ab8500: Fix get_mode for shared mode
 regulators
Message-ID: <20130415080918.GA6512@gmail.com>
References: <1365424274.21989.2.camel@phoenix>
 <CAFRkauBC3mo3GiVeFJ-yUJscybpHje_94rC6oXZ1O5mm8M=9tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFRkauBC3mo3GiVeFJ-yUJscybpHje_94rC6oXZ1O5mm8M=9tA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

> Ping.
> 
> Hi Lee,
> Can you review this patch.
> I think this one is a bug fix.

Bengt is the SME for all things ab*-regulator related.

No one knows the driver better than him.

Bengt, would you mind reviewing?

> 2013/4/8 Axel Lin <axel.lin@ingics.com>:
> > The special handling code for getting shared mode status is wrong
> > because it needs to check info->shared_mode->lp_mode_req for
> > both regulators that shared the same mode register.
> >
> > In set_mode(), current code ensures we won't set mode to REGULATOR_MODE_IDLE
> > if only one of the regulator requests to set idle.
> >
> > In get_mode(), we can just remove the special handling code for shared mode.
> > Read the register value always returns correct status no matter the regulator
> > has shared mode register or not.
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > ---
> >  drivers/regulator/ab8500.c |    8 --------
> >  1 file changed, 8 deletions(-)
> >
> > diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> > index 9ebd131..acdffc5 100644
> > --- a/drivers/regulator/ab8500.c
> > +++ b/drivers/regulator/ab8500.c
> > @@ -456,14 +456,6 @@ static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
> >                 return -EINVAL;
> >         }
> >
> > -       /* Need special handling for shared mode */
> > -       if (info->shared_mode) {
> > -               if (info->shared_mode->lp_mode_req)
> > -                       return REGULATOR_MODE_IDLE;
> > -               else
> > -                       return REGULATOR_MODE_NORMAL;
> > -       }
> > -
> >         if (info->mode_mask) {
> >                 /* Dedicated register for handling mode */
> >                 ret = abx500_get_register_interruptible(info->dev,
> >
> >
> >

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
