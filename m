Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaCEC4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:56:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:57319 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbaCEC4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:56:34 -0500
Message-ID: <1393988191.5392.8.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] clocksource: avoid unnecessary overflow in
 cyclecounter_cyc2ns()
From: Mike Galbraith <bitbucket@online.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Cc: Salman Qazi" <sqazi@google.com>
Date: Wed, 05 Mar 2014 03:56:31 +0100
In-Reply-To: <CALAqxLVkDQO8nhFiX3avZ_dGyqH+uXCwLDzEMJbjp4i54Q9KaA@mail.gmail.com>
References: <1393911500.6415.18.camel@marge.simpson.net>
	 <CALAqxLUeb2GuPyULnHL+FHgbdanVxz2JsvD2O0bJWKyN=CJ3UQ@mail.gmail.com>
	 <1393917011.5419.12.camel@marge.simpson.net>
	 <CALAqxLVkDQO8nhFiX3avZ_dGyqH+uXCwLDzEMJbjp4i54Q9KaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:5Wb8AmBh1OzKqrGHJMHprfDLg/t4wYVrsnta8+rP4km
 ACksaWXvshFs9EKNB8aezrnJtIE1wZQibXZ8DocB9kR+Oi1X3w
 Mjhlc048x8uBYOs2S9X7VCdg8CfwXloh7g9mBGlnD+1p7PZgzq
 q1Zeq4PswJvbhUaI7FOcmU+Ab9otqqhbI0z8fAHLyWNPcHbwVn
 D9qwbrbrs4/PfaC/rnI9/WOi6GVl1VkWyhp1Dsg5A5YL2sxrt0
 xs/sfoL0LoiPHDxgenlSrl5zXY2+ncjVJFUoXb5sLiA2IJU9bH
 2Goy3MzRDNeIIuJyYCxhO6hhIIP9GPVxgyasTzgKaSLi2FHtie
 eosrW4C+pXjaaixdT9pw9hpL4iHXvBjjrvf+X6mTf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 08:58 +0800, John Stultz wrote: 
> On Tue, Mar 4, 2014 at 3:10 PM, Mike Galbraith <bitbucket@online.de> wrote:
> > On Tue, 2014-03-04 at 14:40 +0800, John Stultz wrote:
> >> On Tue, Mar 4, 2014 at 1:38 PM, Mike Galbraith <bitbucket@online.de> wrote:
> >> > (crap crap crap... M.A.I.N.T.A.I.N.E.R.S _dummy_)
> >> >
> >> > clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
> >> >
> >> > As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
> >> > cycles * mult >> shift is overflow prone. so give it the same treatment.
> >> >
> >> > Cc: Salman Qazi <sqazi@google.com>
> >> > Cc: John Stultz <john.stultz@linaro.org>,
> >> > Signed-off-by: Mike Galbraith <bitbucket@online.de>
> >>
> >> Thanks for sending this in!  Curious exactly how the issue was being
> >> triggered?
> >
> > Dunno that it is.  This is the result of me rummaging around, looking
> > for any excuse what-so-ever for a small and identical group of weird a$$
> > boxen running old 2.6.32 kernels (w. 208 day fix!) to manage to hop back
> > and forth in time by exactly 208 days.  Grep showed me that function, so
> > I scurried off and swiped the fix.
> 
> So.. this makes me a bit more hesitant to really queue this,
> particularly since the timecounter logic is supposed to periodically
> accumulate cycles so you don't run into these overflow issues (the
> earlier fix was for sched_clock which didn't do any accumulation).

Ok.

> So, if you're seeing time jump around, that's probably clocksource or
> timekeping related, and not tied to the cyclecounter code. Do you have
> any other info about these systems? What clocksource are they using,
> etc?

Not much, clocksource is TSC, with CPUs that should make it reliable.
They're interested now, so I'll be hearing more digging more.

-Mike

