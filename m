Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642AbaDJFzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 01:55:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36673 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaDJFz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 01:55:28 -0400
Date: Thu, 10 Apr 2014 07:55:23 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tim Kryger <tim.kryger@linaro.org>,
        Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@karo-electronics.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3 1/3] pwm: make the PWM_POLARITY flag in DTB optional
Message-ID: <20140410055523.GK27055@pengutronix.de>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
 <20140402055350.GX17250@pengutronix.de>
 <20140407113652.GE26985@ulmo>
 <20140408070259.68923987@ipc1.ka-ro>
 <CAAYSxhpqe1BVDigMKQ18qEpYNyHGFQ6n5cXWdnUO7HZKSCwzWQ@mail.gmail.com>
 <20140409061209.GF27055@pengutronix.de>
 <20140409072248.GB9886@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140409072248.GB9886@ulmo>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:52:30 up 228 days, 15:23, 38 users,  load average: 0.06, 0.11,
 0.08
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 09:22:50AM +0200, Thierry Reding wrote:
> On Wed, Apr 09, 2014 at 08:12:09AM +0200, Sascha Hauer wrote:
> > On Tue, Apr 08, 2014 at 01:43:22PM -0700, Tim Kryger wrote:
> > > On Mon, Apr 7, 2014 at 10:02 PM, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
> > > > Thierry Reding wrote:
> > > 
> > > >> No. You cannot emulate polarity inversion in software.
> > > >>
> > > > Why not?
> > > >
> > > > duty_ns = period_ns - duty_ns;
> > > 
> > > Since I made the same mistake, I will pass along the pointer Thierry gave me.
> > > 
> > > In include/linux/pwm.h the second difference for an inverted signal is
> > > described.
> > > 
> > > /**
> > >  * enum pwm_polarity - polarity of a PWM signal
> > >  * @PWM_POLARITY_NORMAL: a high signal for the duration of the duty-
> > >  * cycle, followed by a low signal for the remainder of the pulse
> > >  * period
> > >  * @PWM_POLARITY_INVERSED: a low signal for the duration of the duty-
> > >  * cycle, followed by a high signal for the remainder of the pulse
> > >  * period
> > >  */
> > > enum pwm_polarity {
> > > PWM_POLARITY_NORMAL,
> > > PWM_POLARITY_INVERSED,
> > > };
> > > 
> > > Of course, I suspect not all PWM hardware respects this definition of
> > > inverted output.
> > > 
> > > Either way, hacking the duty in software certainly would get the
> > > high/low order wrong.
> > 
> > This only relevant if you have some reference signal the PWM must be
> > relative to, for example if you combine multiple PWMs for motor control.
> > For PWMs used for backlight or beepers a signal inversion in software is
> > perfectly fine. And I also think that it makes sense to put it once into
> > the framework instead of bothering all consumer drivers with the
> > inversion.
> 
> The PWM framework itself doesn't have enough knowledge about what a PWM
> is being used for. Therefore it cannot determine whether emulating
> polarity inversion by reversing the duty cycle will be appropriate.
> 
> Putting such functionality into the core will prevent PWM channels from
> being used for cases where the signal polarity does matter

The PWM core is in no way prepared for handling such situations. Should
we want to add support it a PWM_POLARITY_INVERSED flag would be the
least of our problems. It could be renamed to
PWM_POLARITY_INVERSED_ASYNC for the beeper/led drivers which do not need
synchronization.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
