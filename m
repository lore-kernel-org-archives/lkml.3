Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3IQM0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:26:25 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54296 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3IQM0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:26:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1309131142540.4089@ionos.tec.linutronix.de>
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com>
	<1379000351-15672-2-git-send-email-r.sricharan@ti.com>
	<alpine.DEB.2.02.1309122201530.4089@ionos.tec.linutronix.de>
	<523228B5.5070507@ti.com>
	<alpine.DEB.2.02.1309122335440.4089@ionos.tec.linutronix.de>
	<5232457A.8080709@ti.com>
	<alpine.DEB.2.02.1309130138550.4089@ionos.tec.linutronix.de>
	<52326D6B.2010003@ti.com>
	<alpine.DEB.2.02.1309131142540.4089@ionos.tec.linutronix.de>
Date: Tue, 17 Sep 2013 14:26:22 +0200
Message-ID: <CACRpkdYzaoZUunoNDNirV5Bt-G6p-avFV8A=iznDKjK2biqwrw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 4:24 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

> So why can't you make use of irq domains and have the whole routing
> business implemented sanely?
>
> What's needed is in gic_init_bases():
>
>        if (of_property_read(node, "routable_irqs", &nr_routable_irqs) {
>           irq_domain_add_legacy(nr_gic_irqs);
>        } else {
>           irq_domain_add_legacy(nr_per_cpu_irqs);
>           irq_domain_add_linear(nr_routable_irqs);
>        }
>
> Now that separate domain has an xlate function which grabs a free GIC
> irq from a bitmap and returns the hardware irq number in the gic
> space. The map/unmap callbacks take care of setting up / tearing down
> the route in the crossbar.

This is obviously the right approach, it's exactly what .map should do
the only special thing here being that we have hardware to perform
the mapping ... bah why didn't I realize this :-(

Yours,
Linus Walleij
