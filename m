Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaFMH7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:59:09 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57028 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979AbaFMH7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:59:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ADhLY7X6hd0R+Q1cq3wr6
Date: Fri, 13 Jun 2014 00:58:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        kyungmin.park@samsung.com, pekon@ti.com,
        ezequiel.garcia@free-electrons.com, javier@dowhile0.org,
        nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/36] mtd: nand: omap: Move IRQ handling from GPMC to
 NAND driver
Message-ID: <20140613075856.GQ17845@atomide.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
 <1402477001-31132-6-git-send-email-rogerq@ti.com>
 <20140613071820.GI17845@atomide.com>
 <539AAA8C.2070709@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539AAA8C.2070709@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140613 00:40]:
> On 06/13/2014 10:18 AM, Tony Lindgren wrote:
> > * Roger Quadros <rogerq@ti.com> [140611 01:58]:
> >> Since the Interrupt Events are used only by the NAND driver,
> >> there is no point in managing the Interrupt registers
> >> in the GPMC driver and complicating it with irqchip modeling.
> >>
> >> Let's manage the interrupt registers directly in the NAND driver
> >> and get rid of irqchip model from GPMC driver.
> >>
> >> Get rid of IRQ commands and unused commands from gpmc_configure() in
> >> the GPMC driver.
> > 
> > This seems like a step backward to me. The GPMC interrupt enable
> > register can do edge detection on the wait pins, how is that
> > limited to NAND?
> 
> OK. But wait pin edge detection was not yet being used and I couldn't
> think of how it would ever be used. Any ideas?

Maybe to wake-up the system on bus activity or something? 

> > Further, let's not start mixing GPMC hardware module register
> > access with the NAND driver register access. They can be clocked
> > separately. And bugs in the NAND driver can cause issues in other
> > GPMC using drivers.
> 
> I understood that NAND controller is integrated into the GPMC module and they are clocked
> the same. Not sure why the hardware designers would keep the registers so closely knit.

Yeah. Maybe regmap could provide some abstraction to the the
NAND registers.
 
> FYI. memory/ti-amif.c and mtd/nand/davinci_nand.c share the AMIF register space in the
> same way. I thought it'd be nice to be consistent across TI drivers.

Probably they did not yet learn the problems caused by it :)

Regards,

Tony
