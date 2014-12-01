Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaLALXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:23:16 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41804 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaLALXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:23:15 -0500
Date: Mon, 1 Dec 2014 11:23:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: gic: Allow interrupt level to be set for PPIs.
Message-ID: <20141201112302.GC3836@n2100.arm.linux.org.uk>
References: <1417197340-27298-1-git-send-email-Liviu.Dudau@arm.com>
 <20141201104145.GY3836@n2100.arm.linux.org.uk>
 <20141201104612.GM828@e106497-lin.cambridge.arm.com>
 <20141201110358.GA3836@n2100.arm.linux.org.uk>
 <547C4ECD.20802@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C4ECD.20802@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:19:41AM +0000, Marc Zyngier wrote:
> Hi Russell,
> 
> On 01/12/14 11:03, Russell King - ARM Linux wrote:
> > If all you want to do is to bypass the following check, what's wrong
> > with actually doing that:
> > 
> > -	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
> > +	if (gicirq >= 32 && type != IRQ_TYPE_LEVEL_HIGH &&
> > +	    type != IRQ_TYPE_EDGE_RISING)
> > 		return -EINVAL;
> > 
> 
> I think that will require some additional changes to gic_configure_irq
> (in irq-gic-common.c).

I don't think so - gic_configure_irq() will treat it as a no-op as far
as trying to configure the IRQ settings.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
