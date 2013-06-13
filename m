Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab3FMJqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:46:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57299 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab3FMJqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:46:01 -0400
Message-ID: <1371116757.3307.13.camel@hornet>
Subject: Re: [RFC PATCH v3 0/2] drivers: mfd: Versatile Express SPC support
From: Pawel Moll <pawel.moll@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>
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
Date: Thu, 13 Jun 2013 10:45:57 +0100
In-Reply-To: <20130613001311.GC4567@zurbaran>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
	 <20130611090545.GC8164@e102568-lin.cambridge.arm.com>
	 <20130613001311.GC4567@zurbaran>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jun 2013 09:45:58.0603 (UTC) FILETIME=[CEAA51B0:01CE681A]
X-MC-Unique: 113061310455802801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 01:13 +0100, Samuel Ortiz wrote:
> Now, about the driver itself, besides the really odd code design, the
> static variables all over the place, the nasty init hacks and the
> unneeded long function names, someone should refresh my memory and explain
> to me why is this guy under mfd. I can see it somehow supports IP blocks
> providing different functions, but the design is not sharing anything with
> most of the rest of the mfd drivers.

I belive the vexpress-sysreg.c is a Multi Function Device by all means.
It does so many things that only a water fountain is missing ;-)

If you feel strongly about it, I'm ready to split it into mfd_cells and
move the gpio and leds code into separate drivers, however I'm not
convinced that it's worth the effort.

Now, as to the vexpress-config.c... The first time I've posted the
series, all parts lived in "driver/misc(/vexpress)", but (if I remember
correctly) Arnd had some feelings about "misc" existence at all... I was
thinking about a separate directory for random "system/platform/machine
configuration" drivers, but the idea didn't get any traction.

> Not only that, but the whole vexpress-config code design is not the
> nicest piece of code I've ever seen. And I'm usually not picky. e.g. the
> whole vexpress-config ad-hoc API is awkward and I wonder if it could be
> implemented as a bus instead.

Funny you mention this :-) Again, the first version actually was a
vexpress-config bus. The feedback was - a whole bus_type is over the top
(I'm simplifying the letter slightly but this was the spirit).

> FWIW I take the blame here for not reviewing the initial driver
> submission that Arnd kindly sent to me...But now that I'm looking at it,
> I think it really is on the edge of being staging material. Any thought
> on that ?

I'm more than happy to improve it. The infrastructure (as in: the
hardware) itself is slightly strange and the code pretty much reflects
the situation. There is also a very good reason for some of the oddities
like static bridges array etc - the infrastructure must be functional
very early, long before slab is available (this also caused a lot of
issues with the bus-based implementation, as the device model does
kmalloc all over the place).

So to summarize - I'm open to any suggestions and ready to spend time on
this stuff.

Regards and thanks for your time!

Pawel


