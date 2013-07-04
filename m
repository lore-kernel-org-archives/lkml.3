Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3GDP36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 11:29:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3GDP35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 11:29:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Axel Lin <axel.lin@ingics.com>
Subject: Re: irqchip: sirfsoc: Question about SIRFSOC_NUM_IRQS setting
Date: Thu, 4 Jul 2013 17:29:43 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Barry Song <Baohua.Song@csr.com>, Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org
References: <1372948320.4838.6.camel@phoenix>
In-Reply-To: <1372948320.4838.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307041729.44045.arnd@arndb.de>
X-Provags-ID: V02:K0:bCo+9zaP57EYpflCcl8g0XH/Yk/yrUvAVvgp2k24zRv
 sJ7XqhdyDbDnphdkKNsroEu/JcvH7A+Q7JWVzwmTH+kGygbnri
 RoesXHgbRmoks/kZZ8Eg5dD39flPINjljm7J0jaea/Gy4wCV35
 cVU2wvUhmaTwXlhp111UYoovSbUGh4AE8fG5tTY7V7y+TkiFjf
 XZEJg0T0knGIMcTWIA9ITeNqYfnma0RKnMHp2VpN5nRA3uyDcT
 lR4Fh2xWxkMvzZ+Tu7RPQOkSlnT8+49+qnDawRKwaOOnLTaGf/
 ee9rcQ4tMR29SkQPS7EkWVRz7ByzviT5zWW+qXpd8icP+jBvmM
 WUbLXAa5jseyPzWNHtao=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 July 2013, Axel Lin wrote:
> irq_setup_generic_chip() setup max. 32 interrupts starting from gc->irq_base.
> 
> sirfsoc_irq_init()
>   -> sirfsoc_alloc_gc()
>     -> irq_setup_generic_chip()
> 
> In sirfsoc_irq_init(), current code calls
> sirfsoc_alloc_gc(base + 4, 32, SIRFSOC_NUM_IRQS - 32); //Note, SIRFSOC_NUM_IRQS is 128
> 
> So I'm wondering if SIRFSOC_NUM_IRQS setting is correct or not.

I think this is a result of the sirf marco platform getting added. Note
also the comment in

        /* using legacy because irqchip_generic does not work with linear */
        sirfsoc_irqdomain = irq_domain_add_legacy(np, SIRFSOC_NUM_IRQS, 0, 0,
                                 &irq_domain_simple_ops, base);


With linux-3.11 this is no longer true: the generic irqchip now does
work with the linear domain, and the code can be simplified by
using irq_alloc_domain_generic_chips(), which also gets rid
of the SIRFSOC_NUM_IRQS constant.

	Arnd
