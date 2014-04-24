Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbaDXPRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:17:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44893 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaDXPRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:17:45 -0400
Message-ID: <53592B12.8090700@ti.com>
Date: Thu, 24 Apr 2014 20:47:38 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] mmc: host: omap_hsmmc: introduce new accessor functions
References: <1395878690-9650-1-git-send-email-balbi@ti.com> <1395878690-9650-4-git-send-email-balbi@ti.com>
In-Reply-To: <1395878690-9650-4-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2014 05:34 AM, Felipe Balbi wrote:
> we introduce new accessors which provide for register
> access with and without offsets.
>
> This is just to make sure newer versions of the IP
> can access the new registers prepended at the beginning
> of the address space.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>   drivers/mmc/host/omap_hsmmc.c | 36 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 36 insertions(+)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index d46f768..e596c6a 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -211,6 +211,42 @@ struct omap_hsmmc_host {
>   	struct	omap_mmc_platform_data	*pdata;
>   };
>
> +static inline int _omap_hsmmc_read(struct omap_hsmmc_host *host,
> +		u32 reg, bool offset)
> +{
> +	return readl(host->base + reg + (offset ? host->reg_offset : 0));
> +}
> +
> +static inline void _omap_hsmmc_write(struct omap_hsmmc_host *host,
> +		u32 reg, u32 val, bool offset)
> +{
> +	writel(val, host->base + reg + (offset ? host->reg_offset : 0));
> +}
> +
> +static inline int omap_hsmmc_read_offset(struct omap_hsmmc_host *host,

I think you can rename this function as just omap_hsmmc_read
(removing _offset suffix)

> +		u32 reg)
> +{
> +	return _omap_hsmmc_read(host, reg, true);
> +}
> +
> +static inline void omap_hsmmc_write_offset(struct omap_hsmmc_host *host,

and this one as omap_hsmmc_write since this version of read/write is most often
used, the one with no_offset might be used less often.


