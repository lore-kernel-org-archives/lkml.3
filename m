Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaFJXeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:34:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:55983 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaFJXes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:34:48 -0400
Date: Wed, 11 Jun 2014 01:34:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Norris <computersforpeace@gmail.com>
cc: Florian Fainelli <f.fainelli@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Jason Cooper <jason@lakedaemon.net>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [RFC] irqchip: gic: always mask interrupts during suspend
In-Reply-To: <1402442098-21093-1-git-send-email-computersforpeace@gmail.com>
Message-ID: <alpine.DEB.2.10.1406110129270.5170@nanos>
References: <1402442098-21093-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Brian Norris wrote:
> Other random thought: it seems like any irqchip driver which does lazy IRQ
> masking ought to use IRQCHIP_MASK_ON_SUSPEND. So maybe the IRQ core should just
> do something like:
> 
> 	if (!chip->irq_disable)
> 		chip->flags |= IRQCHIP_MASK_ON_SUSPEND;

No. Lazy irq disable and the suspend logic are different beasts.

That's up to the platform to decide this. Just for the record: there
is a world outside of ARM...

But that brings me to a different question:

    Why are you not putting that customization into the device tree
    instead of trying to add this to some random arch/arm/mach-foo
    files?

Thanks,

	tglx
