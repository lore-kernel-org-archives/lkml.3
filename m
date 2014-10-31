Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbaJaU7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:59:50 -0400
Received: from down.free-electrons.com ([37.187.137.238]:44999 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760065AbaJaU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:59:45 -0400
Date: Fri, 31 Oct 2014 21:59:43 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] watchdog: at91rm9200 remove mach/ header dependency
Message-ID: <20141031205943.GC11327@piout.net>
References: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1414788359-15759-2-git-send-email-alexandre.belloni@free-electrons.com>
 <1840711.B9Yu766vja@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1840711.B9Yu766vja@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/2014 at 21:53:03 +0100, Arnd Bergmann wrote :
> On Friday 31 October 2014 21:45:59 Alexandre Belloni wrote:
> > Remove the mach/ header dependency by including the necessary macros and taking
> > the appropriate resources from the system timer.
> > 
> > Also allow to compile both the at91rm920 and at91sam9 watchdog drivers at the
> > same time.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Please list me in the changelog as well, either in free-form or as
> Suggested-by.

Sure, I was thinking about putting your sob there too and forgot...

> >  
> > +static struct of_device_id at91rm9200_st_timer_ids[] = {
> > +	{ .compatible = "atmel,at91rm9200-st" },
> > +	{ /* sentinel */ }
> > +};
> > +
> >  static int at91wdt_probe(struct platform_device *pdev)
> >  {
> > +	struct resource *regs;
> > +	struct resource _regs;
> >  	int res;
> >  
> >  	if (at91wdt_miscdev.parent)
> >  		return -EBUSY;
> >  	at91wdt_miscdev.parent = &pdev->dev;
> >  
> > +	if (pdev->dev.of_node) {
> > +		struct device_node *np;
> > +
> > +		np = of_find_matching_node(NULL, at91rm9200_st_timer_ids);
> > +		if (!np)
> > +			return -ENXIO;
> > +		if (of_address_to_resource(np, 0, &_regs))
> > +			return -ENXIO;
> > +		regs = &_regs;
> > +	} else {
> > +		regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	}
> 
> What was wrong with my approach of binding the driver to the
> "atmel,at91rm9200-st" node?
> 

I would enable and start the watchdog on all the rm9200 based platform,
something that we probably don't want.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
