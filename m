Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaAOJgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:36:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36648 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAOJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:36:42 -0500
Message-ID: <1389778591.6715.0.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH] misc: sram: cleanup the code
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Jan 2014 10:36:31 +0100
In-Reply-To: <1389755795-17584-1-git-send-email-Li.Xiubo@freescale.com>
References: <1389755795-17584-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 15.01.2014, 11:16 +0800 schrieb Xiubo Li:
> Since the devm_gen_pool_create() is used, so the gen_pool_destroy()
> here is redundant.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/misc/sram.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
> index afe66571..e3e421d 100644
> --- a/drivers/misc/sram.c
> +++ b/drivers/misc/sram.c
> @@ -87,8 +87,6 @@ static int sram_remove(struct platform_device *pdev)
>  	if (gen_pool_avail(sram->pool) < gen_pool_size(sram->pool))
>  		dev_dbg(&pdev->dev, "removed while SRAM allocated\n");
>  
> -	gen_pool_destroy(sram->pool);
> -
>  	if (sram->clk)
>  		clk_disable_unprepare(sram->clk);
>  

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

