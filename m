Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3J2NcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:32:13 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64186 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3J2NcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:32:10 -0400
Date: Tue, 29 Oct 2013 14:32:05 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Johan Hovold <jhovold@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/9] backlight: atmel-pwm-bl: fix reported brightness
Message-ID: <20131029133205.GD29615@localhost>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1382522143-32072-2-git-send-email-jhovold@gmail.com>
 <20131025110836.GQ18477@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025110836.GQ18477@ns203013.ovh.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 01:08:36PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 11:55 Wed 23 Oct     , Johan Hovold wrote:
> > The driver supports 16-bit brightness values, but the value returned
> > from get_brightness was truncated to eight bits.
> > 
> > Cc: stable@vger.kernel.org
> > Acked-by: Jingoo Han <jg1.han@samsung.com>
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > ---
> >  drivers/video/backlight/atmel-pwm-bl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> > index 66885fb..8aac273 100644
> > --- a/drivers/video/backlight/atmel-pwm-bl.c
> > +++ b/drivers/video/backlight/atmel-pwm-bl.c
> > @@ -70,7 +70,7 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
> >  static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
> >  {
> >  	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
> > -	u8 intensity;
> > +	u32 intensity;
> >  
> >  	if (pwmbl->pdata->pwm_active_low) {
> >  		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
> > @@ -80,7 +80,7 @@ static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
> >  			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
> >  	}
> >  
> > -	return intensity;
> > +	return (u16)intensity;
> no cast mask it

Yeah, perhaps that is better. I discussed this a bit with Jingoo Han in
the thread of the original post. I'll respin.

Thanks,
Johan

> >  }
> >  
> >  static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
> > -- 
> > 1.8.4
> > 
