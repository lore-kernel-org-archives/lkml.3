Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaLALoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:44:38 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56137 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaLALog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:44:36 -0500
Date: Mon, 1 Dec 2014 11:44:32 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: gic: Allow interrupt level to be set for PPIs.
Message-ID: <20141201114432.GP828@e106497-lin.cambridge.arm.com>
References: <1417197340-27298-1-git-send-email-Liviu.Dudau@arm.com>
 <20141201104145.GY3836@n2100.arm.linux.org.uk>
 <20141201104612.GM828@e106497-lin.cambridge.arm.com>
 <20141201110358.GA3836@n2100.arm.linux.org.uk>
 <547C4ECD.20802@arm.com>
 <20141201112302.GC3836@n2100.arm.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <20141201112302.GC3836@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 01 Dec 2014 11:44:33.0888 (UTC) FILETIME=[2D1EA600:01D00D5C]
X-MC-Unique: 114120111443401701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:23:02AM +0000, Russell King - ARM Linux wrote:
> On Mon, Dec 01, 2014 at 11:19:41AM +0000, Marc Zyngier wrote:
> > Hi Russell,
> > 
> > On 01/12/14 11:03, Russell King - ARM Linux wrote:
> > > If all you want to do is to bypass the following check, what's wrong
> > > with actually doing that:
> > > 
> > > -	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
> > > +	if (gicirq >= 32 && type != IRQ_TYPE_LEVEL_HIGH &&
> > > +	    type != IRQ_TYPE_EDGE_RISING)
> > > 		return -EINVAL;
> > > 
> > 
> > I think that will require some additional changes to gic_configure_irq
> > (in irq-gic-common.c).
> 
> I don't think so - gic_configure_irq() will treat it as a no-op as far
> as trying to configure the IRQ settings.

Doesn't that assume then that reset value is correct for the type that
we are trying to program the PPIs?

This is all very academic, as I don't have any real example of a GIC doing
this, but ...

 - if the PPI is set at reset value to be level triggered
 - and we want to set PPIx to be level LOW triggered

with your proposed patch the change will not happen, right?

Best regards,
Liviu

> 
> -- 
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

