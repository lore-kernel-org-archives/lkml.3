Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaIJPFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:05:06 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21829 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751471AbaIJPFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:05:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+u4dOAbNMZPD1yLORmgJa6Y4O6vy0Y9TU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8BA2E5DD707
Date: Wed, 10 Sep 2014 11:04:47 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
Message-ID: <20140910150447.GV30828@titan.lakedaemon.net>
References: <20140901230728.GM29327@sirena.org.uk>
 <1627064.QhxvejlWdk@amdc1032>
 <alpine.DEB.2.11.1409020857110.9201@gentwo.org>
 <alpine.DEB.2.11.1409020958530.9608@gentwo.org>
 <20140904171123.GD26364@mtj.dyndns.org>
 <20140909003729.GA11706@mtj.dyndns.org>
 <alpine.DEB.2.11.1409100914180.23942@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409100914180.23942@gentwo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Wed, Sep 10, 2014 at 09:15:30AM -0500, Christoph Lameter wrote:
> On Tue, 9 Sep 2014, Tejun Heo wrote:
> > On Fri, Sep 05, 2014 at 02:11:23AM +0900, Tejun Heo wrote:
> > > On Tue, Sep 02, 2014 at 10:00:07AM -0500, Christoph Lameter wrote:
> > > > Subject: irqchip: Properly fetch the per cpu offset
> > > >
> > > > The raw_cpu_read() conversion dropped the fetch of the offset
> > > > from base->percpu_base in gic_get_percpu_base.
> > > >
> > > > Signed-off-by: Christoph Lameter <cl@linux.com>
> > > >
> > > > Index: linux/drivers/irqchip/irq-gic.c
> > > > ===================================================================
> > > > --- linux.orig/drivers/irqchip/irq-gic.c
> > > > +++ linux/drivers/irqchip/irq-gic.c
> > > > @@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
> > > >  #ifdef CONFIG_GIC_NON_BANKED
> > > >  static void __iomem *gic_get_percpu_base(union gic_base *base)
> > > >  {
> > > > -	return raw_cpu_read(base->percpu_base);
> > > > +	return raw_cpu_read(*base->percpu_base);
> > >
> > > I suppose this should go through percpu/for-3.18-consistent-ops?  Can
> > > we please cc irq folks and get acks?
> >
> > Christoph, please drive this forward.
> 
> CCing IRQ subsystem and IRQCHIP drivers maintainers.

Thanks Chris.  I'm a bit behind on irqchip stuff, so I may have missed
something here...  Did we get Cc'd on the original patch that caused the
regression?  I'm fairly certain I haven't seen it to Ack it.

It wouldn't be an issue worth mentioning if it were a vendor-specific
driver, however, the gic is used by damn near every major ARM SoC.
Tejun (I think) was kind enough to post the links to the email
thread for the original patch, so I'll try to get to this soon-ish.

thx,

Jason.
