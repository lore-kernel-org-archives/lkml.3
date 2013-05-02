Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab3EBTfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:35:19 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:42995 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab3EBTfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:35:18 -0400
Date: Thu, 2 May 2013 13:35:10 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
Message-ID: <20130502193510.GA29522@obsidianresearch.com>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130502185322.GA29333@obsidianresearch.com>
 <5182B902.7040908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182B902.7040908@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:05:38PM +0200, Sebastian Hesselbarth wrote:

> >>+static struct of_device_id orion_irq_dt_ids[] __initconst = {
> >>+	{ .compatible = "marvell,orion-mpic", .data = orion_of_init },
> >>+	{ }
> >
> >Is there a strong reason to change the compatible string? Looks to me
> >like either the new driver or the old driver will bind depending on
> >what is in the machine description. No need for a new string?
> 
> The reason for a new compatible string is, that we will also need an
> secondary irq controller for bridge irqs. That could be called
> marvell,orion-spic. Dove is again a little bit different than the
> others and this will require timer and especially rtc not to share
> bridge irqs here. RTC irq is located in PMU regs on Dove instead of
> bridge regs.

As Arnd mentioned, I would keep the old name then..

The bridge controller can be called marvell,orion-intc-bridge, and if
Dove needs a pmu controller, marvell,dove-intc-pmu ?

> >.. which lets this go away, use the generic irqchip_init instead of
> >orion_init_irq.
> 
> Same as above.

I have kirkwood HW but I haven't had time to make newer kernels run on
it, otherwise I'd test it too :(

Jason
