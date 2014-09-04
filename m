Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaIDRLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:11:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62198 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaIDRLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:11:30 -0400
Date: Fri, 5 Sep 2014 02:11:23 +0900
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
Message-ID: <20140904171123.GD26364@mtj.dyndns.org>
References: <20140901230728.GM29327@sirena.org.uk>
 <1627064.QhxvejlWdk@amdc1032>
 <alpine.DEB.2.11.1409020857110.9201@gentwo.org>
 <alpine.DEB.2.11.1409020958530.9608@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409020958530.9608@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 10:00:07AM -0500, Christoph Lameter wrote:
> Subject: irqchip: Properly fetch the per cpu offset
> 
> The raw_cpu_read() conversion dropped the fetch of the offset
> from base->percpu_base in gic_get_percpu_base.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/drivers/irqchip/irq-gic.c
> ===================================================================
> --- linux.orig/drivers/irqchip/irq-gic.c
> +++ linux/drivers/irqchip/irq-gic.c
> @@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
>  #ifdef CONFIG_GIC_NON_BANKED
>  static void __iomem *gic_get_percpu_base(union gic_base *base)
>  {
> -	return raw_cpu_read(base->percpu_base);
> +	return raw_cpu_read(*base->percpu_base);

I suppose this should go through percpu/for-3.18-consistent-ops?  Can
we please cc irq folks and get acks?

Thanks.

-- 
tejun
