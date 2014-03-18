Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbaCRXJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:09:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39314 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757568AbaCRXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:09:49 -0400
Date: Wed, 19 Mar 2014 00:09:46 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: pwm: set polarity on non DT platforms
Message-ID: <20140318230946.GL12021@piout.net>
References: <1395081521-16568-1-git-send-email-alexandre.belloni@free-electrons.com>
 <CAK5ve-JU-XfX-wTnr72riWbnSfOcnofjsXpVuyweCndjBe=UgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-JU-XfX-wTnr72riWbnSfOcnofjsXpVuyweCndjBe=UgQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/03/2014 at 16:02:51 -0700, Bryan Wu wrote :
> On Mon, Mar 17, 2014 at 11:38 AM, Alexandre Belloni
> <alexandre.belloni@free-electrons.com> wrote:
> > Set inversed polarity when .active_low is set in the platform_data. With device
> > tree, this is taken care of by of_pwm_xlate_with_flags(), called from
> > of_pwm_get().
> >
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> >  drivers/leds/leds-pwm.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> > index 605047428b5a..09681556a6aa 100644
> > --- a/drivers/leds/leds-pwm.c
> > +++ b/drivers/leds/leds-pwm.c
> > @@ -180,6 +180,11 @@ static int led_pwm_probe(struct platform_device *pdev)
> >                         led_dat->cdev.max_brightness = cur_led->max_brightness;
> >                         led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
> >
> > +                       if (led_dat->active_low)
> 
> Why .active_low needs to inverse PWM polarity? In
> of_pwm_xlate_with_flags(), it checked with PWM_POLARITY_INVERSED in
> args. Moreover in of_pwm_simple_xlate() and pxa_pwm_of_xlate(), we
> didn't inverse PWM polarity at all.
> 

Yeah, exactly, there is no issue when using device tree. What I'm trying
to fix here is th non-DT case where of_pwm_xlate_with_flags() is not
called.

> Add Thierry to review this.
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
