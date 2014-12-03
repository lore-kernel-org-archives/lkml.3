Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaLCRak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:30:40 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:35208 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaLCRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:30:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Dec 2014 18:32:22 +0100
From: Stefan Agner <stefan@agner.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] irqchip: nvic: support routable irq domain ops
In-Reply-To: <4576226.8jDcZiCptE@wuerfel>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
 <1417565531-4507-5-git-send-email-stefan@agner.ch>
 <4576226.8jDcZiCptE@wuerfel>
Message-ID: <2586ebb42daf66877335adaad4b4d3e6@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Dec  3 18:29:37 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 547f488112811767866895
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-03 11:49, Arnd Bergmann wrote:
> On Wednesday 03 December 2014 01:12:03 Stefan Agner wrote:
>> +#ifdef CONFIG_ARM_NVIC
>> +extern const struct irq_domain_ops *nvic_routable_irq_domain_ops;
>> +static inline void __init register_routable_domain_ops
>> +                                       (const struct irq_domain_ops *ops)
>> +{
>> +               nvic_routable_irq_domain_ops = ops;
>> +}
>> +#endif /* CONFIG_ARM_NVIC */
>>
> 
> As you mentioned, this conflicts with the gic specific declaration.
> Why not remove the #ifdef here and rename the function to
> nvic_register_routable_domain_ops() ?
> 
> If that doesn't work, I guess we need something more generic
> and move the routable_irq_domain_ops to some common location.
> 

This would move the ifdef to the MSCM driver code. I thought of having a
generic function to call, no matter what base IRQ chip is used.

Anyway, as tglx suggested in patch 3/12, I will try to use the IRQ
domain hierarchy stuff...

--
Stefan


