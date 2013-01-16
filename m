Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab3APMph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:45:37 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42902 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3APMpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:45:35 -0500
Date: Wed, 16 Jan 2013 12:45:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/4] pinctrl: add abx500 pinctrl driver core
Message-ID: <20130116124528.GD20091@gmail.com>
References: <1358242984-5160-1-git-send-email-linus.walleij@stericsson.com>
 <50F5A1B7.20504@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50F5A1B7.20504@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int abx500_gpio_irq_init(struct abx500_pinctrl *pct)
> ...
> > +#ifdef CONFIG_ARM
> > +		set_irq_flags(irq, IRQF_VALID);
> > +#else
> > +		irq_set_noprobe(irq);
> > +#endif
> 
> I assume that ifdef is always set one particular way?
> 
> > +static void abx500_gpio_irq_remove(struct abx500_pinctrl *pct)
> ...
> > +#ifdef CONFIG_ARM
> > +		set_irq_flags(irq, 0);
> > +#endif
> 
> Same there.

You can safely ignore anything to do with IRQs in this patch-set, as
I have a follow-up one (originally written for the old gpio-ab8500
driver - which this is the successor to), which pulls it all out and
applies to the ab8500-core driver instead.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
