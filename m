Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3FRJKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:10:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:59489 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab3FRJKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:10:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,887,1363158000"; 
   d="scan'208";a="355262442"
Date: Tue, 18 Jun 2013 11:09:41 +0200
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
Message-ID: <20130618090941.GE7161@zurbaran>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
 <20130611090545.GC8164@e102568-lin.cambridge.arm.com>
 <20130613001311.GC4567@zurbaran>
 <1371116757.3307.13.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371116757.3307.13.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawell,

On Thu, Jun 13, 2013 at 10:45:57AM +0100, Pawel Moll wrote:
> On Thu, 2013-06-13 at 01:13 +0100, Samuel Ortiz wrote:
> > Now, about the driver itself, besides the really odd code design, the
> > static variables all over the place, the nasty init hacks and the
> > unneeded long function names, someone should refresh my memory and explain
> > to me why is this guy under mfd. I can see it somehow supports IP blocks
> > providing different functions, but the design is not sharing anything with
> > most of the rest of the mfd drivers.
> 
> I belive the vexpress-sysreg.c is a Multi Function Device by all means.
> It does so many things that only a water fountain is missing ;-)
> 
> If you feel strongly about it, I'm ready to split it into mfd_cells and
> move the gpio and leds code into separate drivers, however I'm not
> convinced that it's worth the effort.
Well, after seeing your last patch for ifdef'ing the GPIO and LED code,
I think it is worth the effort.

> Now, as to the vexpress-config.c... The first time I've posted the
> series, all parts lived in "driver/misc(/vexpress)", but (if I remember
> correctly) Arnd had some feelings about "misc" existence at all... I was
> thinking about a separate directory for random "system/platform/machine
> configuration" drivers, but the idea didn't get any traction.
drivers/misc would already have been a nicer option imo.

 
> > Not only that, but the whole vexpress-config code design is not the
> > nicest piece of code I've ever seen. And I'm usually not picky. e.g. the
> > whole vexpress-config ad-hoc API is awkward and I wonder if it could be
> > implemented as a bus instead.
> 
> Funny you mention this :-) Again, the first version actually was a
> vexpress-config bus. The feedback was - a whole bus_type is over the top
> (I'm simplifying the letter slightly but this was the spirit).
I think it would make sense to have it under drivers/bus/. It might be a
little over the top, but when I look at the current code I'd be really
happy to read an over-the-top bus driver instead. At least we'd know
straight away what youre trying to achieve with this code and it would
probably remove a fair chunk of the weird bridge API (the registering
and the function reference stuff).
Do you have a reference for the patch first version ?


> > FWIW I take the blame here for not reviewing the initial driver
> > submission that Arnd kindly sent to me...But now that I'm looking at it,
> > I think it really is on the edge of being staging material. Any thought
> > on that ?
> 
> I'm more than happy to improve it. The infrastructure (as in: the
> hardware) itself is slightly strange and the code pretty much reflects
> the situation. There is also a very good reason for some of the oddities
> like static bridges array etc - the infrastructure must be functional
> very early, long before slab is available (this also caused a lot of
> issues with the bus-based implementation, as the device model does
> kmalloc all over the place).
> 
> So to summarize - I'm open to any suggestions and ready to spend time on
> this stuff.
I'd say splitting the sysreg driver and leaving only the MFD bits in the
MFD driver would be a first step.
Also, re-considering the bus implementation for the config part would
also be interesting. I'd be interested in looking at your first version
of the patch.


> Regards and thanks for your time!
Thanks for your understanding.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
