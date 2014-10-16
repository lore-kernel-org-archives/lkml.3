Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaJPIBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:01:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:22695 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaJPIB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:01:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="401119265"
Date: Thu, 16 Oct 2014 11:01:23 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, linus.walleij@linaro.org,
        gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] gpio/pinctrl: baytrail: move gpio driver from
 pinctrl to gpio directory
Message-ID: <20141016080123.GW2255@lahna.fi.intel.com>
References: <1413227857-555-1-git-send-email-david.a.cohen@linux.intel.com>
 <543CFC7F.2070607@linux.intel.com>
 <20141014174535.GA6516@psi-dev26.jf.intel.com>
 <20141015070812.GM2255@lahna.fi.intel.com>
 <20141015165542.GA4529@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015165542.GA4529@psi-dev26.jf.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 09:55:42AM -0700, David Cohen wrote:
> Hi Mika,
> 
> Thanks for your feedback. See below my reply.
> 
> On Wed, Oct 15, 2014 at 10:08:12AM +0300, Mika Westerberg wrote:
> > On Tue, Oct 14, 2014 at 10:45:35AM -0700, David Cohen wrote:
> > > Hi Mathias,
> > > 
> > > On Tue, Oct 14, 2014 at 01:35:43PM +0300, Mathias Nyman wrote:
> > > > On 13.10.2014 22:17, David Cohen wrote:
> > > > > Even though GPIO module on Intel Bay Trail is able to control pin
> > > > > functionality, it's unlikely Linux kernel driver will ever support it
> > > > > since BIOS should handle all pin muxing itself.
> > > > > 
> > > > > Currently this driver does not register any pinctrl interface and
> > > > > doesn't call any pinctrl interface. It just uses on internal functions
> > > > > the 'struct pinctrl_gpio_range', which is a weak justification to not be
> > > > > under gpio directory.
> > > > > 
> > > > 
> > > > This discussion was held when gpio-baytrail was first submitted.
> > > > These threads explain the gpio/pinctrl-baytrail history:
> > > > 
> > > > http://marc.info/?l=linux-kernel&m=136981432427668&w=2
> > > > http://marc.info/?l=linux-kernel&m=137113578604763&w=2
> > > > http://marc.info/?l=linux-kernel&m=137155497023054&w=2
> > > 
> > > Thanks for pointing that out.
> > > 
> > > > 
> > > > A proper pinctrl driver for baytrail is still not yet ruled out
> > > 
> > > Having it inside pinctrl directory is creating some confusion because
> > > ppl expect it to implement the actual pinctrl interface.
> > 
> > A typical pinctrl driver can implement both a pinctrl interface and a
> > GPIO interface. So it is not uncommon to look the GPIO drivers under
> > drivers/pinctrl/*.
> 
> Agreed :)
> But pinctrl-baytrail has no pinctrl interface, just gpio.

The hardware is capable of muxing pins etc. it just has not been
implemented because we currently don't have need for anything else.
I have seen that in some of our internal trees the driver is also muxing
alternate functions to the pins (using non-pinctrl interface). So maybe
it will get a full pinctrl support in the future.

We certainly don't want to move it from pinctrl to gpio and then back.

> > Furthermore the driver announces that it is a GPIO driver in its Kconfig
> > entry:
> > 
> > config PINCTRL_BAYTRAIL
> >         bool "Intel Baytrail GPIO pin control"
> > 
> > so I don't quite get why this would confuse people.
> 
> How come? You just wrote the inconsistence :)

Well, it says it is a "GPIO pin control" :-)

> We're enabling PINCTRL_BAYTRAIL to build a gpio only driver.
> 
> > 
> > We are also planning to add more Intel pinctrl (real) drivers in the
> > future. drivers/pinctrl/intel/* should be the place where people find
> > the pinctrl/GPIO drivers for newer Intel hardware.
> 
> I fully agree pinctrl/gpio drivers should stay under drivers/pinctrl.
> But we're talking about a gpio driver. IMHO we should at least mention
> in the driver it lacks pinctrl interface currently but it will come in
> future.

OK, why not.

> A side discussion would be why a distro would want to have the pinctrl
> interface on Bay Trail. I'd assume any driver being the consumer of it
> is likely to be wrong. When Linux boots, all pins' functions should be
> already set.

In an ideal world, yes. However, the reality has shown that BIOS/FW gets
these wrong and we need to work it around in the OS.

Also for devices like MinnowBoard MAX (which has Baytrail SoC), you
actually might want to mux some other function out of certain pins.
