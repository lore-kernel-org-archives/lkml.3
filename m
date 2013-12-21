Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3LUHs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 02:48:29 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54372 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3LUHs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 02:48:28 -0500
Date: Sat, 21 Dec 2013 15:49:10 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: broonie@kernel.org, b20788@freescale.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/2] regulator: anatop-regulator: Remove unneeded check
Message-ID: <20131221074900.GA6849@S2101-09.ap.freescale.net>
References: <1387546930-32513-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387546930-32513-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 11:42:09AM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> At the 'anatop_probe_end' error path, the variable 'ret' is known to be
> non-zero, so there is no need to check it.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/regulator/anatop-regulator.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
> index c734d09..0a3597b 100644
> --- a/drivers/regulator/anatop-regulator.c
> +++ b/drivers/regulator/anatop-regulator.c
> @@ -211,8 +211,7 @@ static int anatop_regulator_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, rdev);
>  
>  anatop_probe_end:
> -	if (ret)
> -		kfree(sreg->name);
> +	kfree(sreg->name);

NAK

With the change, a successful probe will end up with calling this
kfree() as well.

Shawn

>  
>  	return ret;
>  }
> -- 
> 1.8.1.2
> 
