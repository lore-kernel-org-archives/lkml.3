Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab3F0Rg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:36:56 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:33146 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3F0Rgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:36:55 -0400
Date: Thu, 27 Jun 2013 20:36:43 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] clocksource: sun4i: Add clocksource and sched clock
 drivers
Message-ID: <20130627173643.GQ4824@tarshish>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
 <20130627060234.GD4824@tarshish>
 <20130627093558.GB8437@lukather>
 <20130627094649.GM4824@tarshish>
 <20130627172144.GD4319@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627172144.GD4319@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Thu, Jun 27, 2013 at 07:21:44PM +0200, Maxime Ripard wrote:
> On Thu, Jun 27, 2013 at 12:46:49PM +0300, Baruch Siach wrote:
> > On Thu, Jun 27, 2013 at 11:35:58AM +0200, Maxime Ripard wrote:
> > > On Thu, Jun 27, 2013 at 09:02:34AM +0300, Baruch Siach wrote:
> > > > On Wed, Jun 26, 2013 at 11:16:55PM +0200, Maxime Ripard wrote:
> > > > > +static u32 sun4i_timer_sched_read(void)
> > > > 
> > > > You commit message mentions "64 bits free running counter", but this one only 
> > > > returns 32 bit.
> > > 
> > > Yeah, the callback setup by setup_sched_clock is supposed to be
> > > returning a u32, and clocksource_mmio_init only accepts up to 32 bits as
> > > well, so I'm only using the lower 32bits of this 64 bits counter.
> > > 
> > > I'll amend the commit log to state this.
> > 
> > But using 64 bit counter for sched_clock is much easier that using 32 bit one. 
> 
> Easier in what aspect? Both API looks similar.

You can just implement your own simple sched_clock() that just returns the 
current value of this 64 bit counter, and do away with all the tricky code in 
kernel/time/sched_clock.c (in tip.git) that is needed to make the 32 -> 64 
extension safe. This is not compatible with multi-platform kernel, though.

> > You can either wait for the rest of Stephen's patch set 
> > (http://thread.gmane.org/gmane.linux.ports.arm.msm/4092) before adding 64 
> > bit, or you can just make the trivial change to the now generic 
> > sched_clock code.
> 
> I'll wait for the Stephen's patches to be merged then, and add support
> for 64bits counters to clocksource_mmio_init.

Sound reasonable.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
