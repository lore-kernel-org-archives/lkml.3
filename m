Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaIJOPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:15:48 -0400
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:44443 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbaIJOPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:15:45 -0400
Date: Wed, 10 Sep 2014 09:15:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
cc: Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
In-Reply-To: <20140909003729.GA11706@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1409100914180.23942@gentwo.org>
References: <20140901230728.GM29327@sirena.org.uk> <1627064.QhxvejlWdk@amdc1032> <alpine.DEB.2.11.1409020857110.9201@gentwo.org> <alpine.DEB.2.11.1409020958530.9608@gentwo.org> <20140904171123.GD26364@mtj.dyndns.org> <20140909003729.GA11706@mtj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014, Tejun Heo wrote:

> On Fri, Sep 05, 2014 at 02:11:23AM +0900, Tejun Heo wrote:
> > On Tue, Sep 02, 2014 at 10:00:07AM -0500, Christoph Lameter wrote:
> > > Subject: irqchip: Properly fetch the per cpu offset
> > >
> > > The raw_cpu_read() conversion dropped the fetch of the offset
> > > from base->percpu_base in gic_get_percpu_base.
> > >
> > > Signed-off-by: Christoph Lameter <cl@linux.com>
> > >
> > > Index: linux/drivers/irqchip/irq-gic.c
> > > ===================================================================
> > > --- linux.orig/drivers/irqchip/irq-gic.c
> > > +++ linux/drivers/irqchip/irq-gic.c
> > > @@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
> > >  #ifdef CONFIG_GIC_NON_BANKED
> > >  static void __iomem *gic_get_percpu_base(union gic_base *base)
> > >  {
> > > -	return raw_cpu_read(base->percpu_base);
> > > +	return raw_cpu_read(*base->percpu_base);
> >
> > I suppose this should go through percpu/for-3.18-consistent-ops?  Can
> > we please cc irq folks and get acks?
>
> Christoph, please drive this forward.

CCing IRQ subsystem and IRQCHIP drivers maintainers.

