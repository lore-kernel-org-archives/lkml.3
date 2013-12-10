Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3LJSrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:47:12 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35147 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751700Ab3LJSrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:47:10 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.236.217
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX194f6UCdgnWC14ffXcHPGIw
Date: Tue, 10 Dec 2013 10:46:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 11/15] mfd: menelaus: Start to use irqdomain
Message-ID: <20131210184653.GN13171@atomide.com>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-11-git-send-email-balbi@ti.com>
 <20131210092050.GT12675@lee--X1>
 <20131210163430.GG22750@saruman.home>
 <20131210183749.GC2390@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210183749.GC2390@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lee Jones <lee.jones@linaro.org> [131210 10:39]:
> > > > Introduce an irq_chip and irq_domain for menelaus driver. Following
> > > > patches will convert uses to traditional request_threaded_irq().
> > > > 
> > > > While at that, some better error handling had to be added, so we could
> > > > free irq descs we allocated.
> > > > 
> > > > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > ---
> > > >  drivers/mfd/menelaus.c | 127 ++++++++++++++++++++++++++++++++++++++++++++++---
> > > 
> > > <snip>
> > > 
> > > > +	irq_domain_add_legacy(node, MENELAUS_NR_IRQS, irq_base, 0,
> > > > +			&irq_domain_simple_ops, m);
> > > 
> > > When will this driver become DT compliant?
> > 
> > when OMAP2 becomes DT-compliant. It still boots with legacy board-file +
> > platform_data.
> 
> Really? Tony, are there any plans to DT the platform?

Yeah and what Felipe is doing here is an important step towards that.
We'll be booting omap2 in DT only mode with v3.14, but we still need
to rely on some pdata quirks at least for the MMC because Menelaus
does not provide the needed regulator phandles for the .dts files for
the driver to use.

Regards,

Tony
