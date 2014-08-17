Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaHQOLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 10:11:17 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60306 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaHQOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 10:11:14 -0400
Date: Sun, 17 Aug 2014 07:11:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Al Stone <al.stone@linaro.org>, Olof Johansson <olof@lixom.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>,
        Robert Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Mark Brown <broonie@linaro.org>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] Add ACPI _DSD and unified device properties
 support
Message-ID: <20140817141106.GA20345@core.coreip.homeip.net>
References: <1408172039-32513-1-git-send-email-mika.westerberg@linux.intel.com>
 <D014CE66.A19F5%dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D014CE66.A19F5%dvhart@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 09:06:05AM -0700, Darren Hart wrote:
> On 8/15/14, 23:53, "Mika Westerberg" <mika.westerberg@linux.intel.com>
> wrote:
> 
> >The recent publication of the ACPI 5.1 specification [1] adds a reserved
> >name
> >for Device Specific Data (_DSD, Section 6.2.5). This mechanism allows for
> >passing arbitrary hardware description data to the OS. The exact format
> >of the
> >_DSD data is specific to the UUID paired with it [2].
> >
> >An ACPI Device Properties UUID has been defined [3] to provide a format
> >compatible with existing device tree schemas. The purpose for this was to
> >allow
> >for the reuse of the existing schemas and encourage the development of
> >firmware
> >agnostic device drivers.
> >
> >This series accomplishes the following (as well as some other
> >dependencies):
> >
> > * Add _DSD support to the ACPI core
> >   This simply reads the UUID and the accompanying Package
> >
> > * Add ACPI Device Properties _DSD format support
> >   This understands the hierarchical key:value pair structure
> >   defined by the Device Properties UUID
> >
> > * Add a unified device properties API with ACPI and OF backends
> >   This provides for the firmware agnostic device properties
> >   Interface to be used by drivers
> >
> > * Provides 2 example drivers that were previously Device Tree aware that
> >   can now be used with either Device Tree or ACPI Device Properties. The
> >   both drivers use an arbitrary _HID.
> >
> >This has been tested on Minnowboard with relevant parts of the modified
> >DSDT at the end of this email.
> 
> 
> This eliminates the need for the board files that were the subject of my
> "How not to write x86 platform drivers" talk at ELC-E last year. With
> These ACPI core changes and the small changes to the two example drivers,
> the Minnowboard can now use the GPIO buttons and LEDs through these
> drivers by adding the ASL fragment below to the DSDT.

>From the drivers perspective I am less than impressed with the need to
reshuffle all the drivers to support ACPI with the new API. I thought the plan
was to try and keep OF API and try to translate as much as possible to it?

The same goes for bringing arbitrary HIDs into the drivers. Can we have HID->OF
naming hidden in ACPI (define a new property like "dt-name",  "of_compat" or
whatever) and have ACPI core map one to another.

Thanks.

-- 
Dmitry
