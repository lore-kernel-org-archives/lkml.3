Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaIIAhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:37:36 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47881 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaIIAhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:37:34 -0400
Date: Tue, 9 Sep 2014 09:37:29 +0900
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
Message-ID: <20140909003729.GA11706@mtj.dyndns.org>
References: <20140901230728.GM29327@sirena.org.uk>
 <1627064.QhxvejlWdk@amdc1032>
 <alpine.DEB.2.11.1409020857110.9201@gentwo.org>
 <alpine.DEB.2.11.1409020958530.9608@gentwo.org>
 <20140904171123.GD26364@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904171123.GD26364@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 02:11:23AM +0900, Tejun Heo wrote:
> On Tue, Sep 02, 2014 at 10:00:07AM -0500, Christoph Lameter wrote:
> > Subject: irqchip: Properly fetch the per cpu offset
> > 
> > The raw_cpu_read() conversion dropped the fetch of the offset
> > from base->percpu_base in gic_get_percpu_base.
> > 
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> > 
> > Index: linux/drivers/irqchip/irq-gic.c
> > ===================================================================
> > --- linux.orig/drivers/irqchip/irq-gic.c
> > +++ linux/drivers/irqchip/irq-gic.c
> > @@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
> >  #ifdef CONFIG_GIC_NON_BANKED
> >  static void __iomem *gic_get_percpu_base(union gic_base *base)
> >  {
> > -	return raw_cpu_read(base->percpu_base);
> > +	return raw_cpu_read(*base->percpu_base);
> 
> I suppose this should go through percpu/for-3.18-consistent-ops?  Can
> we please cc irq folks and get acks?

Christoph, please drive this forward.

Thanks.

-- 
tejun
