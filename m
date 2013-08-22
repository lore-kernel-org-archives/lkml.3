Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3HVAaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:30:04 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41261 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3HVAaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:30:02 -0400
Date: Thu, 22 Aug 2013 09:29:57 +0900
From: Simon Horman <horms@verge.net.au>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Magnus Damm'" <damm@igel.co.jp>,
        "'Paul Mundt'" <lethal@linux-sh.org>
Subject: Re: [PATCH 1/2] clocksource: sh_tmu: remove unnecessary
 platform_set_drvdata()
Message-ID: <20130822002957.GF6902@verge.net.au>
References: <001b01ce9e4f$d1c97950$755c6bf0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001b01ce9e4f$d1c97950$755c6bf0$%han@samsung.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:21:29PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

No objections for this and the following patch:

Acked-by: Simon Horman <horms+renesas@verge.net.au>

Daniel, let me know if you would prefer if I queued these up
and sent you a pull request or you would rather just pick
them up directly.

> ---
>  drivers/clocksource/sh_tmu.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
> index 78b8dae..54ab475 100644
> --- a/drivers/clocksource/sh_tmu.c
> +++ b/drivers/clocksource/sh_tmu.c
> @@ -509,7 +509,6 @@ static int sh_tmu_probe(struct platform_device *pdev)
>  	ret = sh_tmu_setup(p, pdev);
>  	if (ret) {
>  		kfree(p);
> -		platform_set_drvdata(pdev, NULL);
>  		pm_runtime_idle(&pdev->dev);
>  		return ret;
>  	}
> -- 
> 1.7.10.4
> 
> 
