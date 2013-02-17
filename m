Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3BQPFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:05:55 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59811 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3BQPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:05:54 -0500
Subject: Re: Stupid user with user-space questions, matrix LED driving with
 user space code only.
From: anish kumar <anish198519851985@gmail.com>
To: jon@jonshouse.co.uk
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1361111844.14757.29.camel@jonspc>
References: <1361025476.4271.36.camel@jonspc>
	 <1361082134.16206.24.camel@anish-Inspiron-N5050>
	 <1361111844.14757.29.camel@jonspc>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Feb 2013 20:35:44 +0530
Message-ID: <1361113544.16206.30.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-17 at 14:37 +0000, Jonathan Andrews wrote:
> > > The dim pixel code is timing critical (but as I said only a tiny
> > > fraction of the total CPU usage). What I need to do is grab the CPU and
> > > prevent any context switch (IRQ or PREEMPT) for this period.
> > why you want to do this?
> Because I need an I/O pin to change state for a short accurately timed
> period. If the scheduler is activated during the generation of this
> pulse then the timing will be stretched, this stretching is seen as
> bright flash by the viewer of the LED display. 
You can do that in kernel.
> 
> >  
> > > I cant find a user space mechanism other than changing the kernel to
> > > disable preemtion ? No simple /proc switch to turn it on/off ? If not
> > > why - I cant be the only one who wants to toggle preemption off without
> > > swapping kernels ?
> > you can't disable pre-emption from user space.
> Part of why I asked this here.
> 
> Why not !
> 
> I would expect a "/proc/sys/kernel/sched_preemption" that I could toggle
> a 1 or 0 into to turn it on/off.  
Do it in kernel and that is why drivers exist in the kernel.
> 
> >From a user perspective it seems a bit crap to have to change the kernel
> if you have a workload that preemption is harmful to.  
> In the case of something like the Raspberry Pi changing the kernel if
> the distribution has not done the work for me sounds like real effort.
> The kernel is tied to binary obscurity from broadcom... To build I need
> a working cross compiler, toolchain, kernel sources, Pi specific patches
> then to get everything in the correct place on an SD card containing two
> filesystems.  Its possible but its not going to "just work" at my skill
> level....
AFAIK raspberry pi kernel is very easy to build and there are already
source code out there which you just need to clone and compile.This
includes all the necessary tools so...just try and fail before
deciding!!
> > > The other issue is that of IRQs, my dim pixels on the display seem to
> > > flash brighter from time to time, this I assume is partly preemption
> > > (maybe possibly) and partly IRQ handling (more likely) allowing context
> > > switches or just taking a while on slow hardware.
> > > 
> > > I need only a tiny fraction of the runtime to be hard real time, on
> > > intel in the past i've simply disabled IRQs briefly with some inline
> > > assembler. 
> > you shouldn't fiddle with irq's from user space but...
> > > The Raspberry Pi board would also probably survive this as the only
> > > active peripheral is ethenet, I suspect couple of missed IRQs would not
> > > matter as once IRQs are re-enabled the USB/ethernet hardware will likely
> > > have the data or it can be re-tried.  Does anyone have an example of a
> > > dirty hack along these lines they can share with me :-) 
> > 
> > > Do I have any simple mechanism available to disable (or defer) kernel
> > > IRQ handling briefly from user space code, I suspect not but no harm in
> > > asking ?
> > Use any sysfs to disable/enable the irq. This approach is very bad but
> > as you said you wanted a hack.
> Sounds interesting, can I have some more specific clues how. Device is
> not intel or PCI so I need to toggle something relevant to ARMs native
> interrupt system, do I still have anything I can toggle that is relevant
> in "Linux raspberrypi 3.6.11+ #375 PREEMPT" /sys ?
So try building the raspberry kernel.
> 
> Many thanks,
> Jon
> 
> 


