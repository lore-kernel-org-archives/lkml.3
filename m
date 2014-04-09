Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbaDIGFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:05:10 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:58407 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbaDIGFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:05:06 -0400
Date: Wed, 9 Apr 2014 08:04:50 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3 1/3] pwm: make the PWM_POLARITY flag in DTB optional
Message-ID: <20140409080450.4856681c@ipc1.ka-ro>
In-Reply-To: <CAAYSxhpL_0FJvuvGODMTZDm7DtK3eBTVYdhf1Ot7PW94gSM8iw@mail.gmail.com>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
	<1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
	<1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
	<20140402055350.GX17250@pengutronix.de>
	<20140407113652.GE26985@ulmo>
	<20140408070259.68923987@ipc1.ka-ro>
	<CAAYSxhpL_0FJvuvGODMTZDm7DtK3eBTVYdhf1Ot7PW94gSM8iw@mail.gmail.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Tim Kryger wrote:
> On Mon, Apr 7, 2014 at 10:02 PM, Lothar Waßmann <LW@karo-electronics.de>wrote:
> >
> >
> > Thierry Reding wrote:
> >
> > > No. You cannot emulate polarity inversion in software.
> > >
> > Why not?
> >
> > duty_ns = period_ns - duty_ns;
> >
> 
> Since I made the same mistake, I will pass along the pointer Thierry gave
> me.
> 
> In include/linux/pwm.h the second difference for an inverted signal is
> described.
> 
> /**
>  * enum pwm_polarity - polarity of a PWM signal
>  * @PWM_POLARITY_NORMAL: a high signal for the duration of the duty-
>  * cycle, followed by a low signal for the remainder of the pulse
>  * period
>  * @PWM_POLARITY_INVERSED: a low signal for the duration of the duty-
>  * cycle, followed by a high signal for the remainder of the pulse
>  * period
>  */
> enum pwm_polarity {
> PWM_POLARITY_NORMAL,
> PWM_POLARITY_INVERSED,
> };
> 
> Of course, I suspect not all PWM hardware respects this definition of
> inverted output.
> 
> Either way, hacking the duty in software certainly would get the high/low
> order wrong.
> 
OK. But for a periodic signal this doesn't make any difference. It's
just a matter of where you set your reference point.
Only if you program the PWM to create a single cycle you would see the
difference. I wonder if this is a real life usecase though.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
