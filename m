Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3KFIrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:47:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42468 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3KFIrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:47:49 -0500
Date: Wed, 6 Nov 2013 09:47:43 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Message-ID: <20131106084743.GV14892@pengutronix.de>
References: <1383724365-15196-1-git-send-email-duanj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383724365-15196-1-git-send-email-duanj.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:52:45PM +0800, Duan Jiong wrote:
> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.
> 
> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

> ---
>  arch/arm/mach-imx/mx31moboard-smartbot.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mx31moboard-smartbot.c b/arch/arm/mach-imx/mx31moboard-smartbot.c
> index 04ae45d..af6550e 100644
> --- a/arch/arm/mach-imx/mx31moboard-smartbot.c
> +++ b/arch/arm/mach-imx/mx31moboard-smartbot.c
> @@ -141,10 +141,7 @@ static int __init smartbot_otg_host_init(void)
>  		return -ENODEV;
>  
>  	pdev = imx31_add_mxc_ehci_otg(&otg_host_pdata);
> -	if (IS_ERR(pdev))
> -		return PTR_ERR(pdev);
> -
> -	return 0;
> +	return PTR_ERR_OR_ZERO(pdev);
>  }
>  #else
>  static inline int smartbot_otg_host_init(void) { return 0; }
> -- 
> 1.8.3.1
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
