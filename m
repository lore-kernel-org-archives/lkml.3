Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaJOQz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:55:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:49121 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaJOQz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:55:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,725,1406617200"; 
   d="scan'208";a="605894477"
Date: Wed, 15 Oct 2014 09:55:42 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, linus.walleij@linaro.org,
        gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] gpio/pinctrl: baytrail: move gpio driver from
 pinctrl to gpio directory
Message-ID: <20141015165542.GA4529@psi-dev26.jf.intel.com>
References: <1413227857-555-1-git-send-email-david.a.cohen@linux.intel.com>
 <543CFC7F.2070607@linux.intel.com>
 <20141014174535.GA6516@psi-dev26.jf.intel.com>
 <20141015070812.GM2255@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015070812.GM2255@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

Thanks for your feedback. See below my reply.

On Wed, Oct 15, 2014 at 10:08:12AM +0300, Mika Westerberg wrote:
> On Tue, Oct 14, 2014 at 10:45:35AM -0700, David Cohen wrote:
> > Hi Mathias,
> > 
> > On Tue, Oct 14, 2014 at 01:35:43PM +0300, Mathias Nyman wrote:
> > > On 13.10.2014 22:17, David Cohen wrote:
> > > > Even though GPIO module on Intel Bay Trail is able to control pin
> > > > functionality, it's unlikely Linux kernel driver will ever support it
> > > > since BIOS should handle all pin muxing itself.
> > > > 
> > > > Currently this driver does not register any pinctrl interface and
> > > > doesn't call any pinctrl interface. It just uses on internal functions
> > > > the 'struct pinctrl_gpio_range', which is a weak justification to not be
> > > > under gpio directory.
> > > > 
> > > 
> > > This discussion was held when gpio-baytrail was first submitted.
> > > These threads explain the gpio/pinctrl-baytrail history:
> > > 
> > > http://marc.info/?l=linux-kernel&m=136981432427668&w=2
> > > http://marc.info/?l=linux-kernel&m=137113578604763&w=2
> > > http://marc.info/?l=linux-kernel&m=137155497023054&w=2
> > 
> > Thanks for pointing that out.
> > 
> > > 
> > > A proper pinctrl driver for baytrail is still not yet ruled out
> > 
> > Having it inside pinctrl directory is creating some confusion because
> > ppl expect it to implement the actual pinctrl interface.
> 
> A typical pinctrl driver can implement both a pinctrl interface and a
> GPIO interface. So it is not uncommon to look the GPIO drivers under
> drivers/pinctrl/*.

Agreed :)
But pinctrl-baytrail has no pinctrl interface, just gpio.

> 
> Furthermore the driver announces that it is a GPIO driver in its Kconfig
> entry:
> 
> config PINCTRL_BAYTRAIL
>         bool "Intel Baytrail GPIO pin control"
> 
> so I don't quite get why this would confuse people.

How come? You just wrote the inconsistence :)
We're enabling PINCTRL_BAYTRAIL to build a gpio only driver.

> 
> We are also planning to add more Intel pinctrl (real) drivers in the
> future. drivers/pinctrl/intel/* should be the place where people find
> the pinctrl/GPIO drivers for newer Intel hardware.

I fully agree pinctrl/gpio drivers should stay under drivers/pinctrl.
But we're talking about a gpio driver. IMHO we should at least mention
in the driver it lacks pinctrl interface currently but it will come in
future.

A side discussion would be why a distro would want to have the pinctrl
interface on Bay Trail. I'd assume any driver being the consumer of it
is likely to be wrong. When Linux boots, all pins' functions should be
already set.

> 
> > Anyway, the threads above are over 1 year old. Perhaps it was making
> > sense during that time, but unless somebody is working on pinctrl
> > interface now, IMHO we're misplacing the driver for too long. It'd
> > better to move this driver to gpio directory and when/if pinctrl
> > interface is implemented, we move it back to current place.
> 
> I disagree.
> 
> What happens when people and distros have CONFIG_PINCTRL_BAYTRAIL=y and
> now the symbol is changed to something else? For one, it will break the
> existing working configs.

Well, it would happen the same situation when CONFIG_PINCTRL_BAYTRAIL
was implemented for the first time. I don't think we should move/rename
is pinctrl interface is being implemented in short or middle term. But
my point is whether it will be implemented at all for the reasons I
mentioned above.

Anyway, I sent this patch as RFC due to I was expecting it to not be a
consensus. But guess the majority prefer to let it stay where it is.

Br, David
