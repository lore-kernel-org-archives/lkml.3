Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaCYVZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:25:23 -0400
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:59596 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751702AbaCYVZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:25:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:981:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3867:3873:4321:5007:7652:10004:10400:10848:11026:11473:11658:11914:12296:12438:12517:12519:12740:13019:13069:13161:13229:13311:13357:13848,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rifle48_687a782346353
X-Filterd-Recvd-Size: 2441
Message-ID: <1395782716.3010.31.camel@joe-AO722>
Subject: Re: [PATCH 7/7 v2] gpio: dwapb: use d->mask instead od BIT(bit)
From: Joe Perches <joe@perches.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexandre Courbot <gnurou@gmail.com>, atull@altera.com,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dinguyen@altera.com, delicious.quinoa@gmail.com
Date: Tue, 25 Mar 2014 14:25:16 -0700
In-Reply-To: <20140325211841.GA31253@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
	 <1395505004-22650-8-git-send-email-bigeasy@linutronix.de>
	 <CAAVeFu+WQCpo=LEZqdAhpMcO1PLqUzfcVKTafnwe=BiLGLjFZQ@mail.gmail.com>
	 <20140325211841.GA31253@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 22:18 +0100, Sebastian Andrzej Siewior wrote:
> d->mask contains exact the same information as BIT(bit) so we could save
> a few cycles here.

I think you actually lose a few cycles here as
the pointer has to be dereferenced for each use.

> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
[]
> @@ -171,24 +170,24 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
>  
>  	switch (type) {
>  	case IRQ_TYPE_EDGE_BOTH:
> -		level |= BIT(bit);
> -		dwapb_toggle_trigger(gpio, bit);
> +		level |= d->mask;
> +		dwapb_toggle_trigger(gpio, d->hwirq);
>  		break;
>  	case IRQ_TYPE_EDGE_RISING:
> -		level |= BIT(bit);
> -		polarity |= BIT(bit);
> +		level |= d->mask;
> +		polarity |= d->mask;
>  		break;
>  	case IRQ_TYPE_EDGE_FALLING:
> -		level |= BIT(bit);
> -		polarity &= ~BIT(bit);
> +		level |= d->mask;
> +		polarity &= ~d->mask;
>  		break;
>  	case IRQ_TYPE_LEVEL_HIGH:
> -		level &= ~BIT(bit);
> -		polarity |= BIT(bit);
> +		level &= ~d->mask;
> +		polarity |= d->mask;
>  		break;
>  	case IRQ_TYPE_LEVEL_LOW:
> -		level &= ~BIT(bit);
> -		polarity &= ~BIT(bit);
> +		level &= ~d->mask;
> +		polarity &= ~d->mask;
>  		break;
>  	}
>  



