Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3FZFcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:32:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:29266 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab3FZFcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="260240100"
Message-ID: <1372224736.8177.63.camel@envy.home>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
From: Darren Hart <dvhart@linux.intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Olof Johansson <olof@lixom.net>, "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr@intel.com" <peter.p.waskiewicz.jr@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.intel.com>,
        "danders@circuitco.com" <danders@circuitco.com>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Date: Tue, 25 Jun 2013 22:32:16 -0700
In-Reply-To: <1372222365.9179.4.camel@x230>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
	 <20130626040026.GA23621@quad.lixom.net>
	 <1372221808.8177.52.camel@envy.home> <1372222365.9179.4.camel@x230>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 04:52 +0000, Matthew Garrett wrote:
> On Tue, 2013-06-25 at 21:43 -0700, Darren Hart wrote:
> 
> > 1) I need time, possibly a couple of months, to get proper ACPI support
> > for these drivers into the firmware. Then I can rewrite these as ACPI
> > drivers as is proper for an x86 board. I've already started down this
> > path.
> 
> A couple of months pushes you back one kernel release. It's not a huge
> deal. I think I side with Olof here - the kernel developers have pushed
> back against hardcoded and NIHed ARM device descriptors, and given that
> we have a perfectly reasonable standard in the X86 world (ie, ACPI), I'm
> not enthusiastic about merging something that's (a) going to be
> superseded in the near future and (b) may end up serving as an example
> to others who think this is ok.


My biggest concern is fragmentation after the boards start to ship. I
recognize this comes under the "lack of planning on your part doesn't
constitute an emergency on my part" heading (although it really wasn't
a lack of planning). Now that this is out here and people can see where
it's going, if we choose to nack these and wait for a better
implementation, that alone may accomplish the same goal.


> Do these boards currently boot any other OSes?


Currently the linux-yocto_3.8 standard/minnow Linux kernel is the only
thing known to boot on it. This is what will ship with the device.


> > See what happens when core kernel people are allowed to write driver
> > code? How does this relate to converting this over to an ACPI device
> > driver? I guess I would replace the above with
> > MODULE_DEVICE_TABLE(acpi, ...) ? If I do the above.... is this still an
> > evil board-file? What makes the acpi method of discover superior to
> > setting up linux-hotplug via dmi?
> 
> MODULE_DEVICE_TABLE is invisible to the running driver, it just exports
> metadata that udev will use to decide whether to load the driver. If a
> driver is intended to deal with a specific board, DMI makes sense. If
> it's intended to deal with a specific ACPI device (ie, something with a
> _HID that defines the programming model), ACPI makes sense.

What are you referring to with "programming model" here?

The three drivers in question:
minnowboard.c
minnowboard-gpio.c
minnowboard-keys.c

are all board-specific. They map GPIO to their fixed functions and
provide an API for board-specific queries (minnowboard.c), they provide
example uses (minnowboard-gpio and minnowboard-keys) which aid in
experimentation and the development of new drivers.

Which of these make sense as ACPI devices in your opinion?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

