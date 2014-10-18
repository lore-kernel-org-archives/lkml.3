Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaJROZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:25:58 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60594 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaJROZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:25:48 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device
 =?iso-8859-1?Q?properties=0D?= support
To: David Woodhouse <dwmw2@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "dvhart@infradead.org" <dvhart@infradead.org>
In-Reply-To: <1413471356.2762.81.camel@infradead.org>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
	<1413378271.2762.77.camel@infradead.org>
	<20141015131551.GC20034@leverpostej>
	<1413379736.2762.79.camel@infradead.org>
	<20141015134209.GD20034@leverpostej>
	<db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
	<543E88CF.5060504@linux.intel.com> <20141015151702.GG20034@leverpostej>
	<543E9605.6020502@linux.intel.com>
	<1413471356.2762.81.camel@infradead.org>
Date: Sat, 18 Oct 2014 10:37:56 +0200
Message-Id: <20141018083756.1691FC40954@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 16:55:56 +0200
, David Woodhouse <dwmw2@infradead.org>
 wrote:
> On Wed, 2014-10-15 at 17:43 +0200, Darren Hart wrote:
> > 
> > So my objection here is that by keeping the of_* terms in the driver we
> > are required to include of, although it does safely convert to returning
> > NULL if !CONFIG_OF I suppose.
> 
> New version removes everything but the of_match_id bits which we need to
> match ACPI devices too. Perhaps they ought to be renamed, but I'm not
> sure it's worth it.
> 
> This also removes the call to platform_get_resource(IORESOURCE_MEM) and
> fall back to platform_get_resource(IORESOURCE_IO) as discussed IRL with
> Rafael. I'm not sure it's much of an improvement, mind you :)
> 
> Still untested. I think it's OK to switch to platform_get_irq() and then
> drop the irq_dispose_mapping() call, right? The platform_device takes
> care of all of that for us?

Well, the irq management code is all messed up, but what you are doing
is indeed okay. Unfortunately for platform devices we can never free an
IRQ once we've claimed it. That's a completely separate problem and you
don't need to worry about it for this patch.

g.

