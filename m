Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaJANuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:50:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41871 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaJANuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:50:22 -0400
Message-ID: <542C0698.5030704@ti.com>
Date: Wed, 1 Oct 2014 09:50:16 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>, <nm@ti.com>,
        <peter.ujfalusi@ti.com>, <tony@atomide.com>, <afzal@ti.com>,
        <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RESEND] drivers: bus: omap_l3: remove deprecated IRQF_DISABLED
References: <1395130217-17828-1-git-send-email-michael.opdenacker@free-electrons.com> <1412158507-7229-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1412158507-7229-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 06:15 AM, Michael Opdenacker wrote:
> This patch removes the use of the IRQF_DISABLED flag
> from drivers/bus/omap_l3_*
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
Should be ok I guess.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

>  drivers/bus/omap_l3_noc.c | 4 ++--
>  drivers/bus/omap_l3_smx.c | 6 ++----
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
> index 531ae591783b..547a0fdba583 100644
> --- a/drivers/bus/omap_l3_noc.c
> +++ b/drivers/bus/omap_l3_noc.c
> @@ -280,7 +280,7 @@ static int omap_l3_probe(struct platform_device *pdev)
>  	 */
>  	l3->debug_irq = platform_get_irq(pdev, 0);
>  	ret = devm_request_irq(l3->dev, l3->debug_irq, l3_interrupt_handler,
> -			       IRQF_DISABLED, "l3-dbg-irq", l3);
> +			       0, "l3-dbg-irq", l3);
>  	if (ret) {
>  		dev_err(l3->dev, "request_irq failed for %d\n",
>  			l3->debug_irq);
> @@ -289,7 +289,7 @@ static int omap_l3_probe(struct platform_device *pdev)
>  
>  	l3->app_irq = platform_get_irq(pdev, 1);
>  	ret = devm_request_irq(l3->dev, l3->app_irq, l3_interrupt_handler,
> -			       IRQF_DISABLED, "l3-app-irq", l3);
> +			       0, "l3-app-irq", l3);
>  	if (ret)
>  		dev_err(l3->dev, "request_irq failed for %d\n", l3->app_irq);
>  
> diff --git a/drivers/bus/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
> index acc216491b8a..769d64c0b0fe 100644
> --- a/drivers/bus/omap_l3_smx.c
> +++ b/drivers/bus/omap_l3_smx.c
> @@ -238,8 +238,7 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
>  
>  	l3->debug_irq = platform_get_irq(pdev, 0);
>  	ret = request_irq(l3->debug_irq, omap3_l3_app_irq,
> -		IRQF_DISABLED | IRQF_TRIGGER_RISING,
> -		"l3-debug-irq", l3);
> +		IRQF_TRIGGER_RISING, "l3-debug-irq", l3);
>  	if (ret) {
>  		dev_err(&pdev->dev, "couldn't request debug irq\n");
>  		goto err1;
> @@ -247,8 +246,7 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
>  
>  	l3->app_irq = platform_get_irq(pdev, 1);
>  	ret = request_irq(l3->app_irq, omap3_l3_app_irq,
> -		IRQF_DISABLED | IRQF_TRIGGER_RISING,
> -		"l3-app-irq", l3);
> +		IRQF_TRIGGER_RISING, "l3-app-irq", l3);
>  	if (ret) {
>  		dev_err(&pdev->dev, "couldn't request app irq\n");
>  		goto err2;
> 

