Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaLCK2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:28:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61069 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbaLCK2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:28:47 -0500
Date: Wed, 3 Dec 2014 10:27:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stefan Agner <stefan@agner.ch>
Cc: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "arnd@arndb.de" <arnd@arndb.de>, "sre@kernel.org" <sre@kernel.org>,
        "fkan@apm.com" <fkan@apm.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] power: reset: adjust priority of simple syscon
 reboot driver
Message-ID: <20141203102722.GB21310@leverpostej>
References: <1417540320-2385-1-git-send-email-stefan@agner.ch>
 <1417540320-2385-2-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417540320-2385-2-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 05:11:58PM +0000, Stefan Agner wrote:
> Currently, all restart handler use the priority 128, including
> watchdogs. Probably most SoC have a watchdog, and some of them
> register it also as a restart handler. But if a SoC specifies
> a dedicated reboot capability using this syscon driver, this is
> usually the preferred reboot method. Hence, raise the priority
> of this driver to 192.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

This looks good to me.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> ---
>  drivers/power/reset/syscon-reboot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
> index 815b901..c4049f4 100644
> --- a/drivers/power/reset/syscon-reboot.c
> +++ b/drivers/power/reset/syscon-reboot.c
> @@ -68,7 +68,7 @@ static int syscon_reboot_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  
>  	ctx->restart_handler.notifier_call = syscon_restart_handle;
> -	ctx->restart_handler.priority = 128;
> +	ctx->restart_handler.priority = 192;
>  	err = register_restart_handler(&ctx->restart_handler);
>  	if (err)
>  		dev_err(dev, "can't register restart notifier (err=%d)\n", err);
> -- 
> 2.1.3
> 
> 
