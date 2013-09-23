Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3IWMij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:38:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40548 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3IWMii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:38:38 -0400
Date: Mon, 23 Sep 2013 15:38:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] pinctrl: pinctrl-adi2: Remove nested lock+irqsave that
 resue flags.
Message-ID: <20130923123822.GG6247@mwanda>
References: <1379928588-12627-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379928588-12627-1-git-send-email-sonic.adi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 05:29:48PM +0800, Sonic Zhang wrote:
> @@ -323,12 +323,12 @@ static unsigned int adi_gpio_irq_startup(struct irq_data *d)
>  	struct gpio_pint_regs *regs = port->pint->regs;
                                      ^^^^^^^^^^^^^^^^
Dereference.

>  
>  	if (!port) {
            ^^^^^
Too late to check here.

> -		dev_err(port->dev, "GPIO IRQ %d :Not exist\n", d->irq);
> +		pr_err("GPIO IRQ %d :Not exist\n", d->irq);
>  		return -ENODEV;
>  	}

regards,
dan carpenter
> 
