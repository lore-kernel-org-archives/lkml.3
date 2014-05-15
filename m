Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaEOIsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:48:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:7457 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbaEOIsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:48:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="512037289"
Message-ID: <1400143685.2273.31.camel@rzhang1-toshiba>
Subject: Re: [PATCH] thermal: rcar: Use pm_runtime_put() i.s.o.
 pm_runtime_put_sync()
From: Zhang Rui <rui.zhang@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Date: Thu, 15 May 2014 16:48:05 +0800
In-Reply-To: <1397494975-22489-1-git-send-email-geert@linux-m68k.org>
References: <1397494975-22489-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 一, 2014-04-14 at 19:02 +0200, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> There's no need for this to be synchronous
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

applied.

thanks,
rui
> ---
>  drivers/thermal/rcar_thermal.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
> index 5a37940b02c9..a8ed0e0265ae 100644
> --- a/drivers/thermal/rcar_thermal.c
> +++ b/drivers/thermal/rcar_thermal.c
> @@ -470,7 +470,7 @@ error_unregister:
>  			rcar_thermal_irq_disable(priv);
>  	}
>  
> -	pm_runtime_put_sync(dev);
> +	pm_runtime_put(dev);
>  	pm_runtime_disable(dev);
>  
>  	return ret;
> @@ -488,7 +488,7 @@ static int rcar_thermal_remove(struct platform_device *pdev)
>  			rcar_thermal_irq_disable(priv);
>  	}
>  
> -	pm_runtime_put_sync(dev);
> +	pm_runtime_put(dev);
>  	pm_runtime_disable(dev);
>  
>  	return 0;


