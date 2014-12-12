Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316AbaLLEbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 23:31:53 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61241 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933985AbaLLEbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 23:31:51 -0500
Message-ID: <548AE034.7070700@gmail.com>
Date: Fri, 12 Dec 2014 04:31:48 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: phy: export fixed_phy_register()
References: <1418357006-2450-1-git-send-email-msalter@redhat.com>
In-Reply-To: <1418357006-2450-1-git-send-email-msalter@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/12/2014 20:03, Mark Salter a écrit :
> When building the bcmgenet driver as module, I get:
> 
> ERROR: "fixed_phy_register" [drivers/net/ethernet/broadcom/genet/genet.ko] undefined!
> 
> commit b0ba512e225d72 ("net: bcmgenet: enable driver to work without device
> tree") which added a call to fixed_phy_register. But fixed_phy_register
> needs to be exported if used from a module.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

I will have to rework the GENET/SYSTEMPORT/SF2 dependencies anyway, thanks!

> ---
>  drivers/net/phy/fixed.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/fixed.c b/drivers/net/phy/fixed.c
> index 47872caa..3ad0e6e 100644
> --- a/drivers/net/phy/fixed.c
> +++ b/drivers/net/phy/fixed.c
> @@ -274,6 +274,7 @@ struct phy_device *fixed_phy_register(unsigned int irq,
>  
>  	return phy;
>  }
> +EXPORT_SYMBOL_GPL(fixed_phy_register);
>  
>  static int __init fixed_mdio_bus_init(void)
>  {
> 
