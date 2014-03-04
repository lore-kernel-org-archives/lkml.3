Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbaCDOhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:37:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39438 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188AbaCDOhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:37:52 -0500
Message-ID: <5315E522.9090606@ti.com>
Date: Tue, 4 Mar 2014 22:37:22 +0800
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Tony Lindgren <tony@atomide.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 5/5] drivers: bus: omap_l3: Change pr_crit() to dev_err()
 when IRQ request fails
References: <1393937293-6036-1-git-send-email-peter.ujfalusi@ti.com> <1393937293-6036-6-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1393937293-6036-6-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2014 08:48 PM, Peter Ujfalusi wrote:
> Use dev_err() which will going to print the driver's name as well and the
> KERN_ERR level is sufficient in this case (we also print via dev_err when
> there is an error with the mem resources)
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/bus/omap_l3_noc.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
> index 0eff48585ae3..972691a668a3 100644
> --- a/drivers/bus/omap_l3_noc.c
> +++ b/drivers/bus/omap_l3_noc.c
> @@ -158,8 +158,8 @@ static int omap4_l3_probe(struct platform_device *pdev)
>  	ret = devm_request_irq(&pdev->dev, l3->debug_irq, l3_interrupt_handler,
>  			       IRQF_DISABLED, "l3-dbg-irq", l3);
>  	if (ret) {
> -		pr_crit("L3: request_irq failed to register for 0x%x\n",
> -						l3->debug_irq);
> +		dev_err(&pdev->dev, "request_irq failed for %d\n",
> +			l3->debug_irq);
>  		return ret;
>  	}
>  
> @@ -167,8 +167,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
>  	ret = devm_request_irq(&pdev->dev, l3->app_irq, l3_interrupt_handler,
>  			       IRQF_DISABLED, "l3-app-irq", l3);
>  	if (ret)
> -		pr_crit("L3: request_irq failed to register for 0x%x\n",
> -						l3->app_irq);
> +		dev_err(&pdev->dev, "request_irq failed for %d\n", l3->app_irq);
>  
>  	return ret;
>  }
> 
So this one change in the log level. If I look at now, may be dev_err
is fine but the change is not same.

Apart from above comment, rest of the series looks fine to me.
Feel free to add my ack...

Regards,
Santosh
