Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3EVUay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:30:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3EVUaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:30:52 -0400
Date: Wed, 22 May 2013 22:30:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Felipe F. Tonello" <eu@felipetonello.com>
cc: linux-mmc@vger.kernel.org, ben-linux@fluff.org, cjb@laptop.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mmc: sdhci: Added set_power sdhci_ops handler.
In-Reply-To: <1369244832-23868-2-git-send-email-eu@felipetonello.com>
Message-ID: <Pine.LNX.4.64.1305222230050.19558@axis700.grange>
References: <1369244832-23868-1-git-send-email-eu@felipetonello.com>
 <1369244832-23868-2-git-send-email-eu@felipetonello.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:SzGX9OEkaIsWr6/kw9Fn8nj4qe0503AjOJb3YzDIU/b
 lsIVmqQGC/kgogXL2apGu7GnWQPNIvN9vWnCmQlgla9GlZI705
 DNZpCOxgTNcrydr6Ybm0zYlJ7e+pvQxa8NS3XcW88tM2xZBq4R
 1KwwjofbNs3/WApmHZKbqtVgiIlZ+WHZDly/v5DXMhqK0QPANl
 KNb45lShiEkCu2+atZdS9IqaGzaAFG0tihaPUONIFVjXOvYzeu
 S5B9xmQmU3DE4o+LTYwt9ZuSScfaiPWA0AT48KFHe1n5o10mS4
 ONmwWSWm7WDoCTDS/lg+91B1ZZPKQ0xbRYePcDZlYlmUmyH8jE
 FmZIZziXKvJxzIZNnCNJ/mz2mjP3gnjzluQNrkdicDnawn2J7a
 y25V2MQhxSY2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013, Felipe F. Tonello wrote:

> From: "Felipe F. Tonello" <eu@felipetonello.com>
> 
> This is useful for power managment purposes if a sdhci child host wants to
> turn off some other peripheral also.

Sorry, could you elaborate a bit? In what situations is it exactly useful? 
And why cannot the regulator API be used there?

Thanks
Guennadi

> 
> Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
> ---
>  drivers/mmc/host/sdhci.c | 8 ++++++++
>  drivers/mmc/host/sdhci.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 2ea429c..0a026c6 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1244,6 +1244,10 @@ static int sdhci_set_power(struct sdhci_host *host, unsigned short power)
>  	u8 pwr = 0;
>  
>  	if (power != (unsigned short)-1) {
> +
> +		if (host->ops->set_power)
> +			host->ops->set_power(host, true);
> +
>  		switch (1 << power) {
>  		case MMC_VDD_165_195:
>  			pwr = SDHCI_POWER_180;
> @@ -1259,6 +1263,10 @@ static int sdhci_set_power(struct sdhci_host *host, unsigned short power)
>  		default:
>  			BUG();
>  		}
> +	} else {
> +
> +		if (host->ops->set_power)
> +			host->ops->set_power(host, false);
>  	}
>  
>  	if (host->pwr == pwr)
> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> index 379e09d..293d56d 100644
> --- a/drivers/mmc/host/sdhci.h
> +++ b/drivers/mmc/host/sdhci.h
> @@ -294,6 +294,7 @@ struct sdhci_ops {
>  	void	(*platform_resume)(struct sdhci_host *host);
>  	void    (*adma_workaround)(struct sdhci_host *host, u32 intmask);
>  	void	(*platform_init)(struct sdhci_host *host);
> +	void	(*set_power)(struct sdhci_host *host, bool power);
>  };
>  
>  #ifdef CONFIG_MMC_SDHCI_IO_ACCESSORS
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
