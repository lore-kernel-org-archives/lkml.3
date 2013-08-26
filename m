Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3HZOFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:05:07 -0400
Received: from smtp2-1.goneo.de ([212.90.139.83]:58575 "EHLO smtp2-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab3HZOFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:05:05 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.739
From: Lars Poeschel <poeschel@lemonage.de>
To: Andreas Larsson <andreas@gaisler.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
Date: Mon, 26 Aug 2013 16:04:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, grant.likely@linaro.org,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mark.rutland@arm.com, ian.campbell@citrix.com, galak@codeaurora.org,
        pawel.moll@arm.com, tomasz.figa@gmail.com, swarren@wwwdotorg.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <201308261256.00870.poeschel@lemonage.de> <521B3C03.8080508@gaisler.com>
In-Reply-To: <521B3C03.8080508@gaisler.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308261604.55827.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 August 2013 at 13:29:07, Andreas Larsson wrote:
> On 2013-08-26 12:56, Lars Poeschel wrote:
> > Hi Andreas!
> > 
> > On Thursday 22 August 2013 at 15:16:18, Andreas Larsson wrote:
> >> On 2013-08-21 15:38, Lars Poeschel wrote:
> >>> +static void of_gpio_scan_irq_lines(const struct device_node *const
> >>> node, +				   struct device_node *const gcn,
> >>> +				   struct irq_domain *const irq_domain,
> >>> +				   const u32 intsize,
> >>> +				   const struct gpio_chip * const gc,
> >>> +				   bool request)
> >>> +{
> >>> +	struct device_node *child;
> >>> +	struct device_node *irq_parent;
> >>> +	const __be32 *intspec;
> >>> +	u32 intlen;
> >>> +	int ret;
> >>> +	int i;
> >>> +	irq_hw_number_t hwirq;
> >>> +	unsigned int type;
> >>> +
> >>> +	if (node == NULL)
> >>> +		return;
> >>> +
> >>> +	for_each_child_of_node(node, child) {
> >>> +		of_gpio_scan_irq_lines(child, gcn, irq_domain, intsize, gc,
> >>> +				       request);
> >>> +		/* Check if we have an IRQ parent, else continue */
> >>> +		irq_parent = of_irq_find_parent(child);
> >> 
> >> Hi!
> >> 
> >> This call to of_irq_find_parent breaks gpiolib-of for SPARC due to
> >> the fact that the function is undefined when !defined(CONFIG_OF_IRQ)
> >> && defined(CONFIG_OF).
> >> 
> >> Defining the empty of_irq_find_parent in include/linux/of_irq.h when
> >> !defined(CONFIG_OF_IRQ) instead of the current case when
> >> !defined(CONFIG_OF) would solve the immediate compilation problem.
> > 
> > Is this a bug and should be fixed ?
> 
> Well, at least as soon as anyone tries to use in a context that does not
> exclude SPARC it creates a bug, so I would say so. There is no reason
> for SPARC to fall between the chairs. This is the first case I am aware
> of that triggers this.

I also think this should be fixed.
Are you able to do a patch that fixes this and submit to the relevant 
people?

Regards,
Lars
