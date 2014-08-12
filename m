Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaHLPZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:25:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:12260 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbaHLPZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:25:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,849,1400050800"; 
   d="scan'208";a="583797622"
Date: Tue, 12 Aug 2014 18:24:25 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC] ACPI: Add GPIO-signaled event simulator.
Message-ID: <20140812152310.GZ1657@lahna.fi.intel.com>
References: <1406217076-17150-1-git-send-email-tomasz.nowicki@linaro.org>
 <CACRpkdZmKJmaTRBpDrzd7+EhPuFeScr6jEHC8+0z6-4knjFqkA@mail.gmail.com>
 <20140812100111.GV1657@lahna.fi.intel.com>
 <CAAVeFuJiGcx3LgNoVLEa6kZPzBBdX1z2aSkAPNGs7G6nV+tF3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuJiGcx3LgNoVLEa6kZPzBBdX1z2aSkAPNGs7G6nV+tF3Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 07:15:41AM -0700, Alexandre Courbot wrote:
> On Tue, Aug 12, 2014 at 3:01 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Fri, Aug 08, 2014 at 02:36:02PM +0200, Linus Walleij wrote:
> >> On Thu, Jul 24, 2014 at 5:51 PM, Tomasz Nowicki
> >> <tomasz.nowicki@linaro.org> wrote:
> >>
> >> > GPIO signaled events is quite new thing in Linux kernel.
> >> > AFAIK, there are not many board which can take advantage of it.
> >> > However, GPIO events are very useful feature during work on ACPI
> >> > subsystems.
> >>
> >> Overall this seems like a pretty nice debug feature.
> >>
> >> > This commit emulates GPIO h/w behaviour and consists on read/write
> >> > operation to debugfs file. GPIO device instance is still required in DSDT
> >> > table along with _AEI resources and event methods.
> >> >
> >> > Reading from file provides pin to GPIO device map e.g. :
> >> > $ cat /sys/kernel/debug/acpi/gpio_event
> >> > GPIO device name: /__SB.GPI0
> >> > Available GPIO pin map:
> >> > /__SB.GPI0 <-> pin 0x100
> >> >
> >> > Based on that, user can trigger method corresponding to device pin number:
> >> > $ echo "/__SB.GPI0 0x100" > /sys/kernel/debug/acpi/gpio_event
> >>
> >> I need input from Rafael and Mika as to whether this is a
> >> good interface.
> >
> > Maybe it would make sense to move this into drivers/gpio/gpiolib-acpi.c
> > and hide it behind some Kconfig entry?
> 
> I actually like that this feature is contained in its own file - it
> makes it easier to Kconfig-isolate and keeps the base ACPI code short
> and readable. We spent some effort decoupling the sysfs and legacy
> interfaces from the main gpiolib source file, let's keep that policy
> going. ;)

Well, OK but then it needs to make some functions available through the
private gpiolib.h so that the gpiolib-acpi.c is able to call them. Of
course it depends on whether the idea of exporting debugfs entries from
acpi_gpiochip_request_interrupt() instead is going to be implemented.
