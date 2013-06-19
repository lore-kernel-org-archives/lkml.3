Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409Ab3FSJaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:30:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:30191 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933820Ab3FSJaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:30:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="257131604"
Date: Wed, 19 Jun 2013 11:30:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v3 0/2] drivers: mfd: Versatile Express SPC support
Message-ID: <20130619093014.GX7161@zurbaran>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
 <20130611090545.GC8164@e102568-lin.cambridge.arm.com>
 <20130613001311.GC4567@zurbaran>
 <1371116757.3307.13.camel@hornet>
 <20130618090941.GE7161@zurbaran>
 <1371547782.16725.11.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371547782.16725.11.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On Tue, Jun 18, 2013 at 10:29:42AM +0100, Pawel Moll wrote:
> On Tue, 2013-06-18 at 10:09 +0100, Samuel Ortiz wrote:
> > Hi Pawell,
> 
> Double l in the wrong place ;-)
Apologies...

 
> > > If you feel strongly about it, I'm ready to split it into mfd_cells and
> > > move the gpio and leds code into separate drivers, however I'm not
> > > convinced that it's worth the effort.
> > Well, after seeing your last patch for ifdef'ing the GPIO and LED code,
> > I think it is worth the effort.
> 
> Good point. But as this - obviously - won't happen on time for 3.11, I
> hope you would be kind enough to take the #ifdef patch in for now.
I see that you guys are willing to improve this stuff, so I can take it,
yes.


> > > Now, as to the vexpress-config.c... The first time I've posted the
> > > series, all parts lived in "driver/misc(/vexpress)", but (if I remember
> > > correctly) Arnd had some feelings about "misc" existence at all... I was
> > > thinking about a separate directory for random "system/platform/machine
> > > configuration" drivers, but the idea didn't get any traction.
> > drivers/misc would already have been a nicer option imo.
> 
> Ok. Quite conveniently Arnd is the driver/misc maintainer so I'll get
> first-hand feedback on this.
> 
> > > > Not only that, but the whole vexpress-config code design is not the
> > > > nicest piece of code I've ever seen. And I'm usually not picky. e.g. the
> > > > whole vexpress-config ad-hoc API is awkward and I wonder if it could be
> > > > implemented as a bus instead.
> > > 
> > > Funny you mention this :-) Again, the first version actually was a
> > > vexpress-config bus. The feedback was - a whole bus_type is over the top
> > > (I'm simplifying the letter slightly but this was the spirit).
> > I think it would make sense to have it under drivers/bus/. It might be a
> > little over the top, but when I look at the current code I'd be really
> > happy to read an over-the-top bus driver instead. At least we'd know
> > straight away what youre trying to achieve with this code and it would
> > probably remove a fair chunk of the weird bridge API (the registering
> > and the function reference stuff).
> > Do you have a reference for the patch first version ?
> 
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/185014/focus=185019


 
> > > So to summarize - I'm open to any suggestions and ready to spend time on
> > > this stuff.
> > I'd say splitting the sysreg driver and leaving only the MFD bits in the
> > MFD driver would be a first step.
> > Also, re-considering the bus implementation for the config part would
> > also be interesting. 
> 
> Ok, so what I'll do:
> 
> 1. Split vexpress-sysreg into
> * gpio driver
> * leds driver
> * the rest (still in mfd though)
Sounds good to me.


> 2. Move the vexpress-sysreg "platform management" functions into misc
> (unless we get any better place for it)
This is for Arnd and Greg to decide I suppose.


> 3. Move vexpress-config into drivers/bus as it is (however I see no one
> in MAINTAINERS for this directory)
ISTR that Arnd originally created that directory, so he may help here.
Arnd also had some concerns about implementing this code as a bus,
mostly about it not being a discoverable bus. IMHO that's a valid
concern, and this is why you ended up putting it under MFD which can be
seen as some sort of platform devices bus. But I still believe the bus
API would make this code look cleaner and easier to maintain.

> 4. *Try* to use more of the standard bus (aka bus_type) infrastructure,
> however this will be the trickiest part of this all - as I've mentioned
> the code must be functional before SLAB is up...
> 
> You shall see some patches before 3.11-rc1.
Ok, we'll have plenty of time to have it ready for the 3.12 merge window
then.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
