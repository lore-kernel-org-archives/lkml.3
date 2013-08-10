Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030680Ab3HJQrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:47:53 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:24852
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966547Ab3HJQrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:47:51 -0400
X-IronPort-AV: E=Sophos;i="4.89,852,1367964000"; 
   d="scan'208";a="23674048"
Date: Sat, 10 Aug 2013 18:47:47 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
cc: t.sailer@alumni.ethz.ch, jreuter@yaina.de, jpr@f6fbb.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers:net:hamradio: Removing Depricated
 IRQF_DISABLED
In-Reply-To: <1376152738-14944-1-git-send-email-kumargauravgupta3@gmail.com>
Message-ID: <alpine.DEB.2.02.1308101847260.2076@localhost6.localdomain6>
References: <1376152738-14944-1-git-send-email-kumargauravgupta3@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it is in a | with something else, I think you can just remove it.

julia

On Sat, 10 Aug 2013, Kumar Gaurav wrote:

> Removed IRQF_DISABLED as it's deprecated and should be removed
> 
> Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
> ---
>  drivers/net/hamradio/baycom_ser_fdx.c |    2 +-
>  drivers/net/hamradio/baycom_ser_hdx.c |    2 +-
>  drivers/net/hamradio/scc.c            |    2 +-
>  drivers/net/hamradio/yam.c            |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
> index a974727..c114009 100644
> --- a/drivers/net/hamradio/baycom_ser_fdx.c
> +++ b/drivers/net/hamradio/baycom_ser_fdx.c
> @@ -445,7 +445,7 @@ static int ser12_open(struct net_device *dev)
>  	outb(0, FCR(dev->base_addr));  /* disable FIFOs */
>  	outb(0x0d, MCR(dev->base_addr));
>  	outb(0, IER(dev->base_addr));
> -	if (request_irq(dev->irq, ser12_interrupt, IRQF_DISABLED | IRQF_SHARED,
> +	if (request_irq(dev->irq, ser12_interrupt, IRQF_TRIGGER_NONE | IRQF_SHARED,
>  			"baycom_ser_fdx", dev)) {
>  		release_region(dev->base_addr, SER12_EXTENT);
>  		return -EBUSY;
> diff --git a/drivers/net/hamradio/baycom_ser_hdx.c b/drivers/net/hamradio/baycom_ser_hdx.c
> index e349d86..d91c1fd 100644
> --- a/drivers/net/hamradio/baycom_ser_hdx.c
> +++ b/drivers/net/hamradio/baycom_ser_hdx.c
> @@ -490,7 +490,7 @@ static int ser12_open(struct net_device *dev)
>  	outb(0, FCR(dev->base_addr));  /* disable FIFOs */
>  	outb(0x0d, MCR(dev->base_addr));
>  	outb(0, IER(dev->base_addr));
> -	if (request_irq(dev->irq, ser12_interrupt, IRQF_DISABLED | IRQF_SHARED,
> +	if (request_irq(dev->irq, ser12_interrupt, IRQF_TRIGGER_NONE | IRQF_SHARED,
>  			"baycom_ser12", dev)) {
>  		release_region(dev->base_addr, SER12_EXTENT);       
>  		return -EBUSY;
> diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
> index bc1d521..4bc6ee8 100644
> --- a/drivers/net/hamradio/scc.c
> +++ b/drivers/net/hamradio/scc.c
> @@ -1734,7 +1734,7 @@ static int scc_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  			if (!Ivec[hwcfg.irq].used && hwcfg.irq)
>  			{
>  				if (request_irq(hwcfg.irq, scc_isr,
> -						IRQF_DISABLED, "AX.25 SCC",
> +						0, "AX.25 SCC",
>  						(void *)(long) hwcfg.irq))
>  					printk(KERN_WARNING "z8530drv: warning, cannot get IRQ %d\n", hwcfg.irq);
>  				else
> diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
> index 0721e72..f947887 100644
> --- a/drivers/net/hamradio/yam.c
> +++ b/drivers/net/hamradio/yam.c
> @@ -888,7 +888,7 @@ static int yam_open(struct net_device *dev)
>  		goto out_release_base;
>  	}
>  	outb(0, IER(dev->base_addr));
> -	if (request_irq(dev->irq, yam_interrupt, IRQF_DISABLED | IRQF_SHARED, dev->name, dev)) {
> +	if (request_irq(dev->irq, yam_interrupt, IRQF_TRIGGER_NONE | IRQF_SHARED, dev->name, dev)) {
>  		printk(KERN_ERR "%s: irq %d busy\n", dev->name, dev->irq);
>  		ret = -EBUSY;
>  		goto out_release_base;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
