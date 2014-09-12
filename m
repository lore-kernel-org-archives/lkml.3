Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaILWU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:20:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52030 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaILWUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:20:54 -0400
Date: Fri, 12 Sep 2014 18:20:52 -0400 (EDT)
Message-Id: <20140912.182052.1655150437302824636.davem@davemloft.net>
To: alexandre.belloni@free-electrons.com
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        voice.shen@atmel.com
Subject: Re: [PATCH] net/macb: Add hardware revision information during
 probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410447096-29980-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410447096-29980-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Sep 2014 15:20:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Date: Thu, 11 Sep 2014 16:51:36 +0200

> From: Bo Shen <voice.shen@atmel.com>
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/net/ethernet/cadence/macb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index ca5d7798b265..a3b35c146d9c 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -2241,6 +2241,7 @@ static int __init macb_probe(struct platform_device *pdev)
>  
>  	netif_carrier_off(dev);
>  
> +	netdev_info(dev, "Cadence rev 0x%08x\n", macb_readl(bp, MID));
>  	netdev_info(dev, "Cadence %s at 0x%08lx irq %d (%pM)\n",
>  		    macb_is_gem(bp) ? "GEM" : "MACB", dev->base_addr,
>  		    dev->irq, dev->dev_addr);

This is really sloppy.  The "Cadence %s at ..." is what announces the device,
therefore it's out of context to print out the device revision beforehand.

Why don't you just add it to the existing printout instead?
