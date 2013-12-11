Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab3LKJHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:07:01 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:41472 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3LKJGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:06:53 -0500
Date: Wed, 11 Dec 2013 09:06:45 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 11/15] mfd: menelaus: Start to use irqdomain
Message-ID: <20131211090645.GA16780@lee--X1>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-11-git-send-email-balbi@ti.com>
 <20131210092050.GT12675@lee--X1>
 <20131210163430.GG22750@saruman.home>
 <20131210183749.GC2390@lee--X1>
 <20131210184653.GN13171@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131210184653.GN13171@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Tony Lindgren wrote:

> * Lee Jones <lee.jones@linaro.org> [131210 10:39]:
> > > > > Introduce an irq_chip and irq_domain for menelaus driver. Following
> > > > > patches will convert uses to traditional request_threaded_irq().
> > > > > 
> > > > > While at that, some better error handling had to be added, so we could
> > > > > free irq descs we allocated.
> > > > > 
> > > > > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > > ---
> > > > >  drivers/mfd/menelaus.c | 127 ++++++++++++++++++++++++++++++++++++++++++++++---
> > > > 
> > > > <snip>
> > > > 
> > > > > +	irq_domain_add_legacy(node, MENELAUS_NR_IRQS, irq_base, 0,
> > > > > +			&irq_domain_simple_ops, m);
> > > > 
> > > > When will this driver become DT compliant?
> > > 
> > > when OMAP2 becomes DT-compliant. It still boots with legacy board-file +
> > > platform_data.
> > 
> > Really? Tony, are there any plans to DT the platform?
> 
> Yeah and what Felipe is doing here is an important step towards that.
> We'll be booting omap2 in DT only mode with v3.14

Okay, sounds good. Thanks for the clarification.

> but we still need
> to rely on some pdata quirks at least for the MMC because Menelaus
> does not provide the needed regulator phandles for the .dts files for
> the driver to use.

I'll take your word for it. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
