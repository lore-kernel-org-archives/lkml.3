Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbaDIGMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:12:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38492 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaDIGMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:12:23 -0400
Date: Wed, 9 Apr 2014 08:12:09 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@karo-electronics.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3 1/3] pwm: make the PWM_POLARITY flag in DTB optional
Message-ID: <20140409061209.GF27055@pengutronix.de>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
 <20140402055350.GX17250@pengutronix.de>
 <20140407113652.GE26985@ulmo>
 <20140408070259.68923987@ipc1.ka-ro>
 <CAAYSxhpqe1BVDigMKQ18qEpYNyHGFQ6n5cXWdnUO7HZKSCwzWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAYSxhpqe1BVDigMKQ18qEpYNyHGFQ6n5cXWdnUO7HZKSCwzWQ@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:06:48 up 227 days, 15:37, 42 users,  load average: 0.10, 0.10,
 0.08
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 01:43:22PM -0700, Tim Kryger wrote:
> On Mon, Apr 7, 2014 at 10:02 PM, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
> > Thierry Reding wrote:
> 
> >> No. You cannot emulate polarity inversion in software.
> >>
> > Why not?
> >
> > duty_ns = period_ns - duty_ns;
> 
> Since I made the same mistake, I will pass along the pointer Thierry gave me.
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
> Either way, hacking the duty in software certainly would get the
> high/low order wrong.

This only relevant if you have some reference signal the PWM must be
relative to, for example if you combine multiple PWMs for motor control.
For PWMs used for backlight or beepers a signal inversion in software is
perfectly fine. And I also think that it makes sense to put it once into
the framework instead of bothering all consumer drivers with the
inversion.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
