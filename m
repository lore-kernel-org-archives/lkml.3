Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3A3Lje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:39:34 -0500
Received: from londo.lunn.ch ([80.238.139.98]:41434 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab3A3Ljb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:39:31 -0500
Date: Wed, 30 Jan 2013 12:39:16 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power/reset: Remove newly introduced __dev* annotations
Message-ID: <20130130113916.GB20242@lunn.ch>
References: <1359545293-14721-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359545293-14721-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:28:13PM +0100, Thierry Reding wrote:
> __devinit, __devexit and __devexit_p have recently been removed and
> should no longer be used.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  drivers/power/reset/restart-poweroff.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/reset/restart-poweroff.c b/drivers/power/reset/restart-poweroff.c
> index b11b9e8..059cd15 100644
> --- a/drivers/power/reset/restart-poweroff.c
> +++ b/drivers/power/reset/restart-poweroff.c
> @@ -22,7 +22,7 @@ static void restart_poweroff_do_poweroff(void)
>  	arm_pm_restart('h', NULL);
>  }
>  
> -static int __devinit restart_poweroff_probe(struct platform_device *pdev)
> +static int restart_poweroff_probe(struct platform_device *pdev)
>  {
>  	/* If a pm_power_off function has already been added, leave it alone */
>  	if (pm_power_off != NULL) {
> @@ -35,7 +35,7 @@ static int __devinit restart_poweroff_probe(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static int __devexit restart_poweroff_remove(struct platform_device *pdev)
> +static int restart_poweroff_remove(struct platform_device *pdev)
>  {
>  	if (pm_power_off == &restart_poweroff_do_poweroff)
>  		pm_power_off = NULL;
> @@ -50,7 +50,7 @@ static const struct of_device_id of_restart_poweroff_match[] = {
>  
>  static struct platform_driver restart_poweroff_driver = {
>  	.probe = restart_poweroff_probe,
> -	.remove = __devexit_p(restart_poweroff_remove),
> +	.remove = restart_poweroff_remove,
>  	.driver = {
>  		.name = "poweroff-restart",
>  		.owner = THIS_MODULE,
> -- 
> 1.8.1.2
> 

Acked-by: Andrew Lunn <andrew@lunn.ch>

Thanks
	Andrew
