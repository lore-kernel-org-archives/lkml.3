Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3IRNxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:53:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37199 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab3IRNxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:53:00 -0400
Message-ID: <5239B010.8080605@ti.com>
Date: Wed, 18 Sep 2013 19:22:16 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>
Subject: Re: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com> <1379000351-15672-2-git-send-email-r.sricharan@ti.com> <alpine.DEB.2.02.1309122201530.4089@ionos.tec.linutronix.de> <523228B5.5070507@ti.com> <alpine.DEB.2.02.1309122335440.4089@ionos.tec.linutronix.de> <5232457A.8080709@ti.com> <alpine.DEB.2.02.1309130138550.4089@ionos.tec.linutronix.de> <52326D6B.2010003@ti.com> <alpine.DEB.2.02.1309131142540.4089@ionos.tec.linutronix.de> <CACRpkdYzaoZUunoNDNirV5Bt-G6p-avFV8A=iznDKjK2biqwrw@mail.gmail.com>
In-Reply-To: <CACRpkdYzaoZUunoNDNirV5Bt-G6p-avFV8A=iznDKjK2biqwrw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tuesday 17 September 2013 05:56 PM, Linus Walleij wrote:
> On Fri, Sep 13, 2013 at 4:24 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> So why can't you make use of irq domains and have the whole routing
>> business implemented sanely?
>>
>> What's needed is in gic_init_bases():
>> irq
>>        if (of_property_read(node, "routable_irqs", &nr_routable_irqs) {
>>           irq_domain_add_legacy(nr_gic_irqs);
>>        } else {
>>           irq_domain_add_legacy(nr_per_cpu_irqs);
>>           irq_domain_add_linear(nr_routable_irqs);
>>        }
>>
>> Now that separate domain has an xlate function which grabs a free GIC
>> irq from a bitmap and returns the hardware irq number in the gic
>> space. The map/unmap callbacks take care of setting up / tearing down
>> the route in the crossbar.
> This is obviously the right approach, it's exactly what .map should do
> the only special thing here being that we have hardware to perform
> the mapping ... bah why didn't I realize this :-(
>
> Yours,
> Linus Walleij
Thanks for the suggestion.

So as i understand this, this implies using the GIC domain itself and
 add the support for dynamically routable irqs (like crossbar) with in the
GIC driver itself right ?

Regards,
 Sricharan
