Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaJOPRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:17:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38029 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbaJOPRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:17:10 -0400
Date: Wed, 15 Oct 2014 16:17:02 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Darren Hart <dvhart@linux.intel.com>
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
        Bryan Wu <cooloney@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "dvhart@infradead.org" <dvhart@infradead.org>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties
 support
Message-ID: <20141015151702.GG20034@leverpostej>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <1413378271.2762.77.camel@infradead.org>
 <20141015131551.GC20034@leverpostej>
 <1413379736.2762.79.camel@infradead.org>
 <20141015134209.GD20034@leverpostej>
 <db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
 <543E88CF.5060504@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543E88CF.5060504@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 03:46:39PM +0100, Darren Hart wrote:
> 
> 
> On 10/15/14 16:08, David Woodhouse wrote:
> > 
> >> We have been checking for all DT platforms, and that's a bug for DT.
> >> Copying that bug to ACPI is inexcusable given we know it's a bug to do
> >> so.
> > 
> > We'll, perhaps it should be named 'used-by-firmware' and actually it's
> > just as valid under ACPI as it is on RTAS systems. All it does is stop the
> > OS from using the port.
> > 
> >> I understand that. However, where a binding doesn't make sense (as in
> >> this case), it shouldn't be enabled for ACPI as it provides a larger
> >> surface area for misuse, for no benefit.
> > 
> > These are *optional* properties. They were optional precisely *because*
> > they only make sense in some cases. I don't know that it makes sense to
> > take them away. The benefit we get is *consistency*. For example if
> > someone *does* use the property in question as 'used-by-firmware' and
> > expects the OS not to touch it, we don't want that to change behaviour
> > between ACPI and fdt boots.
> 
> My comment was going to be along the same lines. It is an optional
> parameter, which is what I would expect for a firmware-specific type of
> property.
> 
> I also don't agree that this is "copying that bug to ACPI". This line of
> code has no impact to ACPI. No ACPI implementation should add this,
> certainly not if it was actually tested as it would not run if it was
> present in the _DSD. So... what's the problem exactly? Or perhaps more
> specifically:
> 
> Mark, what would you propose we do differently to enable this driver to
> be firmware-type agnostic?

For this particular driver, all I'm asking for is that the
"used-by-rtas" property is not moved over from of_find_property to
device_get_property. It is irrelevant for all ACPI systems. Evidently my
comment was unclear; I apologise for that.

We have status = "disabled" as a less specific mechanism for telling the
OS to ignore a node in DT. I was under the impression that ACPI already
had a mechanism for marking devices to be ignored, but perhaps I am
mistaken.

The concerns I mentioned at the end of my original reply were of a more
general nature than this particular device description.

Thanks,
Mark.
