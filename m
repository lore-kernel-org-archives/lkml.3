Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaKLNev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:34:51 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59332 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752556AbaKLNeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:34:50 -0500
Date: Wed, 12 Nov 2014 14:34:45 +0100
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: davem@davemloft.net, antoine.tenart@free-electrons.com, arnd@arndb.de,
        sebastian.hesselbarth@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: pxa168_eth: move SET_NETDEV_DEV a bit earlier
Message-ID: <20141112133445.GC18559@kwain>
References: <1415790527-6494-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415790527-6494-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

On Wed, Nov 12, 2014 at 07:08:47PM +0800, Jisheng Zhang wrote:
> This is to ensure the net_device's dev.parent is set before we used it
> in dma_zalloc_coherent() from init_hash_table().

Applies on top of net-next.

> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

FWIW,

Acked-by: Antoine Tenart <antoine.tenart@free-electrons.com>

> ---
>  drivers/net/ethernet/marvell/pxa168_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
> index 21ddece..38f7cee 100644
> --- a/drivers/net/ethernet/marvell/pxa168_eth.c
> +++ b/drivers/net/ethernet/marvell/pxa168_eth.c
> @@ -1540,8 +1540,8 @@ static int pxa168_eth_probe(struct platform_device *pdev)
>  	if (err)
>  		goto err_free_mdio;
>  
> -	pxa168_init_hw(pep);
>  	SET_NETDEV_DEV(dev, &pdev->dev);
> +	pxa168_init_hw(pep);
>  	err = register_netdev(dev);
>  	if (err)
>  		goto err_mdiobus;
> -- 
> 2.1.3
> 

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
