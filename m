Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3IRPIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:08:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45823 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab3IRPII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:08:08 -0400
Message-ID: <5239C19E.1090609@ti.com>
Date: Wed, 18 Sep 2013 11:07:10 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, <linus.walleij@linaro.org>
CC: Sricharan R <r.sricharan@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, <rnayak@ti.com>
Subject: Re: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com> <1379000351-15672-2-git-send-email-r.sricharan@ti.com> <alpine.DEB.2.02.1309122201530.4089@ionos.tec.linutronix.de> <523228B5.5070507@ti.com> <alpine.DEB.2.02.1309122335440.4089@ionos.tec.linutronix.de> <5232457A.8080709@ti.com> <alpine.DEB.2.02.1309130138550.4089@ionos.tec.linutronix.de> <52326D6B.2010003@ti.com> <alpine.DEB.2.02.1309131142540.4089@ionos.tec.linutronix.de> <52332772.5040203@ti.com>
In-Reply-To: <52332772.5040203@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Friday 13 September 2013 10:55 AM, Santosh Shilimkar wrote:
> On Friday 13 September 2013 10:24 AM, Thomas Gleixner wrote:

[...]

>> Before you dig into MSI, lets talk about irq domains first.
>>
>> GIC implements a legacy irq domain, i.e. a linear domain of all
>> possible GIC interrupts with a 1:1 mapping.
>>
>> So why can't you make use of irq domains and have the whole routing
>> business implemented sanely?
>>
>> What's needed is in gic_init_bases():
>>
>>        if (of_property_read(node, "routable_irqs", &nr_routable_irqs) {
>>        	  irq_domain_add_legacy(nr_gic_irqs);
>>        } else {
>>        	  irq_domain_add_legacy(nr_per_cpu_irqs);
>> 	  irq_domain_add_linear(nr_routable_irqs);
>>        }
>>
>> Now that separate domain has an xlate function which grabs a free GIC
>> irq from a bitmap and returns the hardware irq number in the gic
>> space. The map/unmap callbacks take care of setting up / tearing down
>> the route in the crossbar.
>>
>> Thoughts?
>>
> This sounds pretty good idea. We will explore above option.
> Thanks Thomas.
> 
After further looking into this, the irqdomain approach lets us
setup the map only once during the init. This is similar to
the earlier approach of cross-bar driver where at probe time
the router was setup.  The whole debate started with the fact
that we shouldn't fix the irq mapping at probe and should
dynamically change the mapping based on [request/free]_irq()
to be able to maximize the use of the IP.

Since we have agreed now to move ahead with irdomain, i thought
of mentioning it here.

Regards,
Santosh







