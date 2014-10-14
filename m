Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaJNR7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:59:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:1047 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbaJNR7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:59:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,718,1406617200"; 
   d="scan'208";a="614405799"
Date: Tue, 14 Oct 2014 10:45:35 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [RFC/PATCH] gpio/pinctrl: baytrail: move gpio driver from
 pinctrl to gpio directory
Message-ID: <20141014174535.GA6516@psi-dev26.jf.intel.com>
References: <1413227857-555-1-git-send-email-david.a.cohen@linux.intel.com>
 <543CFC7F.2070607@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543CFC7F.2070607@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathias,

On Tue, Oct 14, 2014 at 01:35:43PM +0300, Mathias Nyman wrote:
> On 13.10.2014 22:17, David Cohen wrote:
> > Even though GPIO module on Intel Bay Trail is able to control pin
> > functionality, it's unlikely Linux kernel driver will ever support it
> > since BIOS should handle all pin muxing itself.
> > 
> > Currently this driver does not register any pinctrl interface and
> > doesn't call any pinctrl interface. It just uses on internal functions
> > the 'struct pinctrl_gpio_range', which is a weak justification to not be
> > under gpio directory.
> > 
> 
> This discussion was held when gpio-baytrail was first submitted.
> These threads explain the gpio/pinctrl-baytrail history:
> 
> http://marc.info/?l=linux-kernel&m=136981432427668&w=2
> http://marc.info/?l=linux-kernel&m=137113578604763&w=2
> http://marc.info/?l=linux-kernel&m=137155497023054&w=2

Thanks for pointing that out.

> 
> A proper pinctrl driver for baytrail is still not yet ruled out

Having it inside pinctrl directory is creating some confusion because
ppl expect it to implement the actual pinctrl interface.

Anyway, the threads above are over 1 year old. Perhaps it was making
sense during that time, but unless somebody is working on pinctrl
interface now, IMHO we're misplacing the driver for too long. It'd
better to move this driver to gpio directory and when/if pinctrl
interface is implemented, we move it back to current place.

Br, David

> 
> -Mathias 
> 
