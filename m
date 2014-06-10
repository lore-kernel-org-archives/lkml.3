Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaFJXsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:48:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51795 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaFJXsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:48:30 -0400
Date: Tue, 10 Jun 2014 16:48:26 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Jason Cooper <jason@lakedaemon.net>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [RFC] irqchip: gic: always mask interrupts during suspend
Message-ID: <20140610234826.GK3599@ld-irv-0074>
References: <1402442098-21093-1-git-send-email-computersforpeace@gmail.com>
 <alpine.DEB.2.10.1406110129270.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406110129270.5170@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 01:34:39AM +0200, Thomas Gleixner wrote:
> On Tue, 10 Jun 2014, Brian Norris wrote:
> > Other random thought: it seems like any irqchip driver which does lazy IRQ
> > masking ought to use IRQCHIP_MASK_ON_SUSPEND. So maybe the IRQ core should just
> > do something like:
> > 
> > 	if (!chip->irq_disable)
> > 		chip->flags |= IRQCHIP_MASK_ON_SUSPEND;
> 
> No. Lazy irq disable and the suspend logic are different beasts.

OK, fair enough. Drop that random thought then. It's not in the patch
content anyway.

> That's up to the platform to decide this. Just for the record: there
> is a world outside of ARM...

OK. But GIC is ARM-specific, so we can still constrain this patch and
related topics to the world of ARM.

> But that brings me to a different question:
> 
>     Why are you not putting that customization into the device tree
>     instead of trying to add this to some random arch/arm/mach-foo
>     files?

I'm not adding customization to arch/arm/mach-foo files. I'm trying to
remove it.

This property could be added to device tree, if there was really a valid
use case for a GIC which leaves its interrupts unmasked for suspend. My
question in this patch is essentially: does such a use case exist?

Brian
