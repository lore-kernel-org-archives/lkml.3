Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab3J2M7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:59:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:55913 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3J2M7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:59:51 -0400
Date: Tue, 29 Oct 2013 13:59:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vinayak Kale <vkale@apm.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] genirq: error reporting for non-percpu interrupt in
 request_percpu_irq()
In-Reply-To: <CAPrCYke1_RjUgH79vZW99pwdExo4BspCaVi7zL-8hapKb0=gwQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1310291358150.8257@ionos.tec.linutronix.de>
References: <1382090789-18177-1-git-send-email-vkale@apm.com> <CAPrCYke1_RjUgH79vZW99pwdExo4BspCaVi7zL-8hapKb0=gwQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Vinayak Kale wrote:

> Need for this patch is discussed in mail-thread [1].
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/204414.html
> 

I can't see anything which makes use of the separate error code in
that patch.

Thanks,

	tglx

> On Fri, Oct 18, 2013 at 3:36 PM, Vinayak Kale <vkale@apm.com> wrote:
> > Return a separate error code when a non-percpu interrupt is passed to
> > request_percpu_irq().
> >
> > Suggested-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Vinayak Kale <vkale@apm.com>
> > ---
> >  kernel/irq/manage.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > index 514bcfd..c2713ae 100644
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -1671,10 +1671,12 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
> >                 return -EINVAL;
> >
> >         desc = irq_to_desc(irq);
> > -       if (!desc || !irq_settings_can_request(desc) ||
> > -           !irq_settings_is_per_cpu_devid(desc))
> > +       if (!desc || !irq_settings_can_request(desc))
> >                 return -EINVAL;
> >
> > +       if (!irq_settings_is_per_cpu_devid(desc))
> > +               return -EPERM;
> > +
> >         action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
> >         if (!action)
> >                 return -ENOMEM;
> > --
> > 1.7.9.5
> >
> 
