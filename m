Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaEIHGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:06:53 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:43253 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaEIHGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:06:52 -0400
MIME-Version: 1.0
In-Reply-To: <1399560433-1402630-2-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560433-1402630-2-git-send-email-arnd@arndb.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 9 May 2014 12:36:20 +0530
Message-ID: <CA+V-a8vt5=MB8SipxRKc99hLaXt8m=3UmSBLRCX20M0c1jcJLA@mail.gmail.com>
Subject: Re: [PATCH] mdio_bus: fix devm_mdiobus_alloc_size export
To: Arnd Bergmann <arnd@arndb.de>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 8:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> commit 6d48f44b7b2 "mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free"
> introduced a new function devm_mdiobus_alloc_size() but added an export
> for a different function devm_mdiobus_alloc(), which was obviously
> a simple mistake that leads to  build error whenever this function is
> used from a loadable module:
>
> ERROR: "devm_mdiobus_alloc_size" [drivers/net/ethernet/ti/davinci_mdio.ko] undefined!
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad

> ---
>  drivers/net/phy/mdio_bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 68a9a38..a628496 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -117,7 +117,7 @@ struct mii_bus *devm_mdiobus_alloc_size(struct device *dev, int sizeof_priv)
>
>         return bus;
>  }
> -EXPORT_SYMBOL_GPL(devm_mdiobus_alloc);
> +EXPORT_SYMBOL_GPL(devm_mdiobus_alloc_size);
>
>  /**
>   * devm_mdiobus_free - Resource-managed mdiobus_free()
> --
> 1.8.3.2
>
