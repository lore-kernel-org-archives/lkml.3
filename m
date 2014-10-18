Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaJRO0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:26:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52246 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaJROZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:25:49 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device
 =?iso-8859-1?Q?properties=0D?= support
To: Darren Hart <dvhart@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
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
In-Reply-To: <543E9605.6020502@linux.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
	<1413378271.2762.77.camel@infradead.org>
	<20141015131551.GC20034@leverpostej>
	<1413379736.2762.79.camel@infradead.org>
	<20141015134209.GD20034@leverpostej>
	<db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
	<543E88CF.5060504@linux.intel.com> <20141015151702.GG20034@leverpostej>
	<543E9605.6020502@linux.intel.com>
Date: Sat, 18 Oct 2014 10:35:49 +0200
Message-Id: <20141018083549.99F1AC408A6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 17:43:01 +0200
, Darren Hart <dvhart@linux.intel.com>
 wrote:
> 
> 
> On 10/15/14 17:17, Mark Rutland wrote:
> > On Wed, Oct 15, 2014 at 03:46:39PM +0100, Darren Hart wrote:
> 
> >> Mark, what would you propose we do differently to enable this driver to
> >> be firmware-type agnostic?
> > 
> > For this particular driver, all I'm asking for is that the
> > "used-by-rtas" property is not moved over from of_find_property to
> > device_get_property. It is irrelevant for all ACPI systems. Evidently my
> > comment was unclear; I apologise for that.
> 
> So my objection here is that by keeping the of_* terms in the driver we
> are required to include of, although it does safely convert to returning
> NULL if !CONFIG_OF I suppose.

This shouldn't be that controversial. There will be things that only make
sense for DT or only ACPI. Allowing the property to be processed when
the other interface is being used may tempt firmware authors to use the
property because it just happens to have a side effect that looks right
to them.

I don't see any problem with factoring out those bits into a function
that is only called (or built) when the associated firmware interface is
used. In these situations, the driver isn't 100% generic, so having
small per-firmware hooks is absolutely okay and not a burden to
maintain.

g.
