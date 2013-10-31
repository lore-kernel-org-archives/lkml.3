Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab3JaK6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:58:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39224 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3JaK6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:58:52 -0400
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
Subject: RE: [PATCH V2 2/7] DRIVERS: IRQCHIP: CROSSBAR: Add support for
 Crossbar IP
Thread-Topic: [PATCH V2 2/7] DRIVERS: IRQCHIP: CROSSBAR: Add support for
 Crossbar IP
Thread-Index: AQHO1YBiICNK6tuSpUKo5P741bpUK5oM2NKAgAHKfns=
Date: Thu, 31 Oct 2013 10:57:47 +0000
Message-ID: <F934AE11CE617240AE4A874A49F629E4832579@DBDE04.ent.ti.com>
References: <1383145040-15852-1-git-send-email-r.sricharan@ti.com>
 <1383145040-15852-3-git-send-email-r.sricharan@ti.com>,<alpine.DEB.2.02.1310301615430.24686@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1310301615430.24686@ionos.tec.linutronix.de>
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
  Again sorry for top post. 

  I agree and will fix both of the comments below.

  Thanks for the reviews.

Regards,
 Sricharan
________________________________________
From: Thomas Gleixner [tglx@linutronix.de]
Sent: Wednesday, October 30, 2013 9:00 PM
To: R, Sricharan
Cc: linux-kernel@vger.kernel.org; devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-omap@vger.kernel.org; linus.walleij@linaro.org; linux@arm.linux.org.uk; tony@atomide.com; Nayak, Rajendra; marc.zyngier@arm.com; grant.likely@linaro.org; mark.rutland@arm.com; robherring2@gmail.com; Shilimkar, Santosh; Rob Herring
Subject: Re: [PATCH V2 2/7] DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP

On Wed, 30 Oct 2013, Sricharan R wrote:
> +static inline const u32 allocate_free_irq(int cb_no)

I understand the "static inline" part, but "const u32" is more than
fishy. What's wrong with "static inline int" ?

> +{
> +     int i;
> +
> +     for (i = 0; i < cb->int_max; i++) {
> +             if (cb->irq_map[i] == IRQ_FREE) {
> +                     cb->irq_map[i] = cb_no;
> +                     return i;
> +             }
> +     }
> +
> +     return -ENODEV;
> +}

> +static int crossbar_domain_xlate(struct irq_domain *d,
> +                              struct device_node *controller,
> +                              const u32 *intspec, unsigned int intsize,
> +                              unsigned long *out_hwirq,
> +                              unsigned int *out_type)
> +{
> +     unsigned long ret = 0;

Why do you need to initialize ret when you assign a value to it in the
next line?

Thanks,

        tglx