Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab3CMIbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:31:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22647 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3CMIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:31:42 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-d7-5140396d24ea
Message-id: <51403973.9080601@samsung.com>
Date: Wed, 13 Mar 2013 17:31:47 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 1/3] dw_mmc: Don't loop when handling an interrupt
References: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
In-reply-to: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zLd1cS4dAg8nTRC22v97IZnHjVxur
	xeVdc9gsjvzvZ7T4fHs7q8WH+xeZHdg8enaeYfQ4dGUto0ffllWMHp83yQWwRHHZpKTmZJal
	FunbJXBlvLn+hLXgDF/Fp1UPmBsYt3J3MXJySAiYSHztnswIYYtJXLi3nq2LkYtDSGAZo8S8
	739YYIp6N1xgB7GFBKYzSjxdBFX0klFi/o1jzCAJXgEtiWVt3UwgNouAqsS5IyfBbDYBHYnt
	346D2aICYRIrp19hgagXlPgx+R6QzcEhImAgMavDACTMLLCKUWJHdw6ILSzgJtE6YS0zxF4v
	ifdPd4DZnALeEm3NU9gg6nUk9rdOg7LlJTavecsMcpuEwC52iTefjrBC3CMg8W3yIbBdEgKy
	EpsOMEP8JSlxcMUNlgmMYrOQXDQLydhZSMYuYGRexSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7
	iRESYf07GO8esD7EmAy0ciKzlGhyPjBC80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8s
	Sc1OTS1ILYovKs1JLT7EyMTBKdXA6KpvNGVZ9MeQqFC9jJPFjBKtN6/MSbhs58hd4xG62Y/V
	2+fpNEtbKUexQP3TBw3PP3dbeeC65UqRd1dMXm9oFxF6yfZ/0pUVG2Q12/6VHt5+ccLOM5Kv
	DvBU3f9a9uCBj72mhWf8olAb18VX7US/eulxO51ZPHlHuEbAaQMn6cbQuxICH6/xKLEUZyQa
	ajEXFScCAIMsAxDGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd1cS4dAg009/BbbX29ks7jxq43V
	4vKuOWwWR/73M1p8vr2d1eLD/YvMDmwePTvPMHocurKW0aNvyypGj8+b5AJYohoYbTJSE1NS
	ixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAtisplCXmlAKFAhKL
	i5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM95cf8JacIav4tOqB8wNjFu5uxg5OSQETCR6
	N1xgh7DFJC7cW88GYgsJTGeUeLoIyOYCsl8ySsy/cYwZJMEroCWxrK2bCcRmEVCVOHfkJJjN
	JqAjsf3bcTBbVCBMYuX0KywQ9YISPybfA7I5OEQEDCRmdRiAhJkFVjFK7OjOAbGFBdwkWies
	ZYbY6yXx/ukOMJtTwFuirXkKG0S9jsT+1mlQtrzE5jVvmScwCsxCsmEWkrJZSMoWMDKvYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiO32fSOxhXNVgcYhTgYFTi4ZVIsw8UYk0sK67MPcQo
	wcGsJMLbdgkoxJuSWFmVWpQfX1Sak1p8iDEZGAATmaVEk/OBqSWvJN7Q2MTMyNLIzNjE3NiY
	NGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhjb901P/sS7yjfRb/NC5zpx1f9PJggz/Dfx
	9WEqfqvZ/T71ZOqWvjl6dZ0PxXZapucsXXD21M7tPWlyjmk6fGaebv6hzy7NT5l+WvBPeuSe
	oxrcU1aKSX+/cI/V6MqpaT/vvXMwcsw3YF4ht+5g56ni/V7i99czPrghqnJo15JS7vxpwXl9
	K9yUWIozEg21mIuKEwF8T5kAIwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 03/12/2013 07:53 PM, Markos Chandras wrote:
> There is no reason to loop when handling an interrupt. The "if" clauses
> will handle all of them sequentially. This also eliminates the extra loop
> we used to take with no pending interrupts and we ended up breaking out
> of the while loop.
> 
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Chris Ball <cjb@laptop.org>
> ---
> The patch is based on Chris Ball's mmc-next branch
> 
>  drivers/mmc/host/dw_mmc.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 60063cc..78c7251 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1563,11 +1563,11 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  {
>  	struct dw_mci *host = dev_id;
>  	u32 pending;
> -	unsigned int pass_count = 0;
>  	int i;
>  
> -	do {
> -		pending = mci_readl(host, MINTSTS); /* read-only mask reg */
> +	pending = mci_readl(host, MINTSTS); /* read-only mask reg */
> +
> +	if (pending) {
>  
>  		/*
>  		 * DTO fix - version 2.10a and below, and only if internal DMA
> @@ -1579,9 +1579,6 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  				pending |= SDMMC_INT_DATA_OVER;
>  		}
>  
> -		if (!pending)
> -			break;
> -
>  		if (pending & DW_MCI_CMD_ERROR_FLAGS) {
>  			mci_writel(host, RINTSTS, DW_MCI_CMD_ERROR_FLAGS);
>  			host->cmd_status = pending;
> @@ -1642,7 +1639,7 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  			}
>  		}
>  
> -	} while (pass_count++ < 5);
> +	}
>  
>  #ifdef CONFIG_MMC_DW_IDMAC
>  	/* Handle DMA interrupts */
> 

