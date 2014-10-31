Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbaJaOEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:04:25 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:50130 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571AbaJaOEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:04:22 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414764218.2406.76.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 31 Oct 2014 15:03:38 +0100
In-Reply-To: <20141030233906.6647d005@alan.etchedpixels.co.uk>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	 <1413914978.30379.14.camel@hadess.net>
	 <CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
	 <1414419579.30379.49.camel@hadess.net>
	 <CALAqxLXyaL55JuDuHAcWX0PEdem-jpVxK0rbJaNrBbBJ3rQY5Q@mail.gmail.com>
	 <20141028225740.2cd0ea5f@alan.etchedpixels.co.uk>
	 <1414680060.2406.51.camel@hadess.net>
	 <20141030233906.6647d005@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-30 at 23:39 +0000, One Thousand Gnomes wrote:
> > > You'd have to solve it in the firmware.
> > 
> > Not if the kernel can tell us that the event occurred and when.
> 
> Which it can only do if the firmware told the kernel meaningfully !
> 
> > And I think I have one of those devices, an Intel Baytrail tablet.
> > 
> > > - Suspend/Resume on such machines are a Linux fake to keep legacy code
> > >   happy
> > 
> > Do you have a link to how this is implemented currently?
> 
> You ask for suspend and we put all the devices into lowest power state if
> they are not already there then sit on our backsides issuing mwaits
> asking for C7 state on BYT (C10 I think on HSW).
> 
> If you box is ever passive enough you can even randomly enter this state
> in the idle loop. You generally won't do this on current devices because
> you won't have suitable panels and most desktop OS's are far too noisy on
> wakeups. There's nothing preventing you having half your processors in
> deep idle.
> 
> That's where it is all heading though. Suspend will eventually go away.
> 
> > [1]: Reason for wake-up for each wake-up-able device, along with a
> > timestamp.
> 
> We may not know and the answer in many cases will be extremely device
> specific.

Which is why I'm interested in the device drivers providing that
information.

> It's a reasonable ask but answers even if available are likely
> to be things like "because GPE36" and GPE36 will just be some connection
> to something that could be anything from a lid switch to a light sensor
> or even a smart wifi chip deciding it wants the CPU to help out because
> you are out of range of the base station. We may not even know what it
> relates to.

But the device or platform driver would know that, presumably.

> A non suspend system will exit deep idle type status because they got
> an IRQ or perhaps some DMA needed the cache coherency. That doesn't mean
> they've got the foggiest which IRQ kicked them out if idle, just that hey
> I'm awake and there are four pending interrupts. That of course is
> assuming it even noticed it entered a deep idle state - you don't want to
> wake an idle CPU to tell it that its more idle than it was before.

Sure, the CPU might not be the best example of a device for which we
need to track the wakeup reason. The device drivers however...

