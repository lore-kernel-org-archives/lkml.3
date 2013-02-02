Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3BBMSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 07:18:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33682 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab3BBMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 07:18:17 -0500
Date: Sat, 2 Feb 2013 12:17:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sergei Shtylyov <sshtylyov@mvista.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
	arm/common
Message-ID: <20130202121738.GZ2637@n2100.arm.linux.org.uk>
References: <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk> <510C58DF.3010103@mvista.com> <20130202004455.GX2637@n2100.arm.linux.org.uk> <510C7554.3060800@mvista.com> <20130202101851.GY2637@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202101851.GY2637@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 10:18:51AM +0000, Russell King - ARM Linux wrote:
> On Sat, Feb 02, 2013 at 06:09:24AM +0400, Sergei Shtylyov wrote:
> > Hello.
> >
> > On 02-02-2013 4:44, Russell King - ARM Linux wrote:
> >
> >>>>> On Fri, Feb 01, 2013 at 11:49:11PM +0300, Sergei Shtylyov wrote:
> >>>>>>> good point, do you wanna send some patches ?
> >
> >>>>>>      I have already sent them countless times and even stuck CPPI 4.1 support (in
> >>>>>> arch/arm/common/cppi41.c) in Russell's patch system. TI requested to remove the
> >>>>>> patch. :-(
> >
> >>>>> sticking into arch/arm/common/ wasn't a nice move. But then again, so
> >>>>> wasn't asking for the patch to be removed :-s
> >
> >>>> Err, patches don't get removed, they get moved to 'discarded'.
> >
> >>>     Any chance to bring it back to life? :-)
> >>>     Although... drivers/usb/musb/cppi41.c would need to be somewhat
> >>> reworked for at least AM35x and I don't have time. But that may change,
> >>> of course.
> >
> >> Right, I've just looked back at the various meeting minutes from December
> >> 2010 when the CPPI stuff was discussed.  Yes, I archive these things and
> >> all email discussions for referencing in cases like this.
> >
> >    Thanks.
> >
> >> Unfortunately, they do not contain any useful information other than the
> >> topic having been brought up.  At that point, the CPPI stuff was in
> >> mach-davinci, and I had suggested moving it into drivers/dma.
> >
> >    I don't remember that, probably was out of the loop again.

Here you go - this goes back even _further_ - November 2009 - on the
mailing list.  The entire thread:

http://lists.arm.linux.org.uk/lurker/thread/20091102.105759.a54cf3f5.en.html

And selected emails from it:

http://lists.arm.linux.org.uk/lurker/message/20091102.103706.38c029b5.en.html
On Mon, Nov 02, 2009 at 10:37:06AM +0000, I wrote:
| On Mon, Nov 02, 2009 at 04:27:59PM +0530, Gupta, Ajay Kumar wrote:
| > Another option is to create arch/arm/ti-common to place all TI platform's
| > common software, such as CPPI4.1 used both in DA8xx and AM3517.
| 
| No thanks.  I really don't see why we should allow TI to have yet more
| directories scattered throughout the tree that are out of place with
| existing conventions.
| 
| And what is this CPPI thing anyway?
| 
| http://acronyms.thefreedictionary.com/CPPI
| 
| "Communications Port Programming Interface" seems to be about the best
| applicable one from that list!
| 
| If it's a USB DMA device (from the patches I can find, that seems to be
| the case) then why can't it live in drivers/usb or drivers/dma ?

And again:

http://lists.arm.linux.org.uk/lurker/message/20091102.115458.61cde450.en.html
On Mon, Nov 02, 2009 at 11:54:58AM +0000, I wrote:
| On Mon, Nov 02, 2009 at 04:27:59PM +0530, Gupta, Ajay Kumar wrote:
| > CPPI4.1 DMA engine can be used either by USB or by Ethernet interface though
| > currently only USB is using it but in future even Ethernet devices may use it.
| 
| drivers/dma does seem to be the right place for this.

http://lists.arm.linux.org.uk/lurker/message/20091102.110217.adec3ca7.en.html
Even Felipe Balbi said so:
| you might want to provide support for it via drivers/dma and for the
| musb stuff, you just add the wrappers musb uses. See how tusb6010_omap.c
| uses OMAP's system dma which is also used by any other driver which
| requests a dma channel.

And it seems that _YOU_ did get the message - see your quoted text in:
http://lists.arm.linux.org.uk/lurker/message/20091230.132240.ecd56b3d.en.html
> We're currently having it there but the matter is it should be shred
> between different platforms, so arch/arm/common/ seems like the right
> place (which Russell didn't like, suggesting ill suited for that
> drivers/dma/ instead).

See - you acknowledge here that I don't like it.  So you _KNOW_ my views
on it in December 2009, contary to what you're saying in this thread.

Yet, you persisted with putting it in arch/arm/common:

http://lists.arm.linux.org.uk/lurker/message/20100515.181453.472c7c10.en.html
| Changes since the previous version:
| - moved everything from arch/arm/mach-davinci/ to arch/arm/common/;
| - s/CONFIG_CPPI41/CONFIG_TI_CPPI41/, made that option invisible;
| - added #include <linux/slab.h> for kzalloc();
| - switched alloc_queue() and cppi41_queue_free() to using bit operations;
| - replaced 'static' linking_ram[] by local variable in cppi41_queue_mgr_init();
| - fixed pr_debug() in cppi41_dma_ctrlr_init() to print the real queue manager #.

So, see, I had already objected to it being in arch/arm well before
you stuck your patch into the patch system.  And somehow you think
that ignoring my previous comments and doing it anyway will result in
progress?

So, let's recap.  The timeline behind this is:

+ 2 Nov 2009: Question asked about putting it in arch/arm/ti-common
  + I responded saying a clear no to that, suggesting other locations
    all of which were outside arch/arm.
  + I responded again saying an hour or two later saying the same thing.
  + Felipe Balbi agreed with drivers/dma.
+ 15 May 2010: v5 posted with it in arch/arm/common
+ 06 Aug 2010: put into patch system sa 6305/1
+ 06 Dec 2010: TI meeting.
  + Pre-meeting notes show that my views on this are known:
    + I'll quote this from it: "Russell suggested to move the driver at
      drivers/dma/".
    + Raises concern that DMA engine API may not fit.
  + I respond to that concern as work has been done on the DMA engine API
    to improve the slave mode support recently as a result of Linus Walleij's
    work on AMBA PL08x DMA support.
    (I would _not_ have done so if I had changed my view about it being
     under drivers/dma/).
+ 07 Dec 2010: emails talking about moving MUSB over to DMA engine API
  so that MUSB should not care about its DMA backend (that being CPPI
  or some other one.)
  + Email with "Let's see if I can get it all done by 2.6.39."
+ 08 Dec 2010: patch 6305/1 discarded from the patch system as there now
  seems to be concensus on the issue.
+ 03 Jan 2011: you ask me why it was discarded
  http://lists.arm.linux.org.uk/lurker/thread/20110103.160610.8cbe8e7d.en.html
  + I respond "It may have been that it's inventing its own API rather
    than using something like the DMA engine API."
  + Ajay said: "This issue was discussed recently at TI and proposal was
    to place it to drivers/dma folder. Moreover, even Felipe also seems
    to move other musb DMAs (Inventra, CPPI3.0, TUSB) to drivers/dma."

Oh, and then we come to this interesting email from Felipe to you, in
response to your reluctance to put it in drivers/dma.
| Do I really have to spell it out ? Really ?
| 
| You don't need to physically move the part of the code to drivers/dma,
| but it has to use the API. The mentor DMA is internal to MUSB.
| tusb6010_omap.c isn't.
| 
| Where it makes sense to move the code under drivers/dma, it will be
| done, where it doesn't, it won't be done, but it will use the same API.
| That's all.
| 
| The end goal is just to drop all these ad-hoc "APIs" for accessing DMA
| on musb code.

See the common theme here?  I don't like it under arch/arm.  I've been
pretty _consistent_ in suggesting drivers/dma/ all through that...
Others have said it.  People even acknowledge that's what I've been
saying, people who were not in the original discussion.

What I think is this: it is _YOU_ who don't want to hear that message,
so _YOU_ are intentionally ignoring it, and _YOU_ are looking for
someone to blame for it.  You've decided I'm to blame because _YOU_
aren't listening.

The reason there hasn't been any progress on this is _NOT_ down to me.
I've provided my feedback, and promptly been ignored.  Others have told
you the same thing, and promptly been ignored.  Sorry, this is not my
problem.  This is entirely YOUR problem, one of your own making.

But whatever.  We are NOT going to put CPPI under arch/arm.  Not now that
during the last merge window Linus complained to Arnd about the amount of
code coming through for arch/arm _AGAIN_.  Not after last time Linus
complained about TI OMAP which prompted the creation of arm-soc.  AND THAT
IS *FINAL*.  CPPI DMA SUPPORT IS *NOT* GOING UNDER ARCH/ARM.  PERIOD.  NOT
GOING TO HAPPEN.

Is this clear enough yet, or how many more years of emails do you need
yet more emails to get this message through?
