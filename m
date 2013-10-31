Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab3JaKu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:50:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35040 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3JaKuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:50:55 -0400
From: "R, Sricharan" <r.sricharan@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: RE: [PATCH V2 1/7] DRIVERS: IRQCHIP: IRQ-GIC: Add support for
 routable irqs
Thread-Topic: [PATCH V2 1/7] DRIVERS: IRQCHIP: IRQ-GIC: Add support for
 routable irqs
Thread-Index: AQHO1YBeK9csZBvNNUy7v4Hdvop8gJoM1J4AgAHMhRs=
Date: Thu, 31 Oct 2013 10:50:04 +0000
Message-ID: <F934AE11CE617240AE4A874A49F629E4832564@DBDE04.ent.ti.com>
References: <1383145040-15852-1-git-send-email-r.sricharan@ti.com>
 <1383145040-15852-2-git-send-email-r.sricharan@ti.com>,<alpine.DEB.2.02.1310301608380.24686@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1310301608380.24686@ionos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
  Sorry for top posting. My mailer is not allowing me any formatting.

  I agree with both of your comments below.
  I will post V3 for this.

Regards,
 Sricharan

________________________________________
From: Thomas Gleixner [tglx@linutronix.de]
Sent: Wednesday, October 30, 2013 8:45 PM
To: R, Sricharan
Cc: linux-kernel@vger.kernel.org; devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-omap@vger.kernel.org; linus.walleij@linaro.org; linux@arm.linux.org.uk; tony@atomide.com; Nayak, Rajendra; marc.zyngier@arm.com; grant.likely@linaro.org; mark.rutland@arm.com; robherring2@gmail.com; Shilimkar, Santosh; Rob Herring
Subject: Re: [PATCH V2 1/7] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs

On Wed, 30 Oct 2013, Sricharan R wrote:
> @@ -700,11 +709,22 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
>       *out_hwirq = intspec[1] + 16;
>
>       /* For SPIs, we need to add 16 more to get the GIC irq ID number */
> -     if (!intspec[0])
> +     if (!intspec[0]) {
>               *out_hwirq += 16;

Minor nit. This should be in the default implementation. The crossbar
implementation will fill out_hwirq in its own way and is not
interested in the +16 operation at all.

> +             ret = gic_routable_irq_domain_ops->xlate(d, controller,
> +                                                      intspec,
> +                                                      intsize,
> +                                                      out_hwirq,
> +                                                      out_type);
> +

> +             gic->domain = irq_domain_add_legacy(node, gic_irqs, irq_base,
> +                                     hwirq_base, &gic_irq_domain_ops, gic);
> +     } else {
> +             if (WARN_ON(!gic_routable_irq_domain_ops))
> +                     return;

This warning is pointless, because you have default ops now.

> +
> +             gic->domain = irq_domain_add_linear(node, nr_routable_irqs,
> +                                                 &gic_irq_domain_ops,
> +                                                 gic);
>       }

Thanks,

        tglx