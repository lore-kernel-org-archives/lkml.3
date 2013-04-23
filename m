Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3DWLOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 07:14:53 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:59154 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3DWLOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 07:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <516BF4DA.6000204@gaisler.com>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
	<1363355140-28216-4-git-send-email-andreas@gaisler.com>
	<CACRpkdZ4AK=3PGQ-3+ffWsH9B-ywrDkMxnePWat1=P7WoqgJWA@mail.gmail.com>
	<516BF4DA.6000204@gaisler.com>
Date: Tue, 23 Apr 2013 13:14:51 +0200
Message-ID: <CACRpkdbXFBBetC9uh=AWVNV86oA1S2Ls1dNCMOj8iAur7V2E3w@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] gpio: grgpio: Add irq support
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 2:38 PM, Andreas Larson <andreas@gaisler.com> wrote:

> On 2013-04-10 21:25, Linus Walleij wrote:
>>> +int grgpio_irq_map(struct irq_domain *d, unsigned int virq,
(...)
>>> +       /* Request underlying irq if not already requested */
>>> +       lirq->virq = virq;
>>> +       uirq = &priv->uirqs[lirq->index];
>>> +       if (uirq->refcnt == 0) {
>>> +               ret = request_irq(uirq->uirq, grgpio_irq_handler, 0,
>>> +                                 dev_name(priv->dev), priv);
>>
>>
>> No, please request all present uirqs in probe() before creating the
>> irqdomain.
>
>
> The reason for doing it at irq_map and not in probe is that one
> typical hardware setup for this core is that it has irqs that are shared
> with pretty much all other cores in the system. Therefore, if this
> drivers requests all its irqs in the probe function, pretty much all the
> drivers for the other cores in the system that were not lucky enough to
> request their irq before this driver will fail their probes in such a
> hardware setup. This driver can not share irq:s so even if the other
> drivers can handle shared irqs they are out of luck if this driver is
> probed first.
>
> That is why only the irqs that are actually used should be requested and
> thus why the driver does it on demand instead of in the probe.

OK I buy that explanation...

Thanks,
Linus Walleij
