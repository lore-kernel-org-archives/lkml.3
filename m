Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab3EXO7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:59:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61779 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3EXO7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:59:10 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 24 May 2013 07:59:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 4/5] watchdog: riowd: use platform_{get,set}_drvdata()
Message-ID: <20130524145927.GE6085@roeck-us.net>
References: <003701ce57a2$864a0740$92de15c0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003701ce57a2$864a0740$92de15c0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 07:44:38PM +0900, Jingoo Han wrote:
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/riowd.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
> index 0040451..4f99f12 100644
> --- a/drivers/watchdog/riowd.c
> +++ b/drivers/watchdog/riowd.c
> @@ -206,7 +206,7 @@ static int riowd_probe(struct platform_device *op)
>  	pr_info("Hardware watchdog [%i minutes], regs at %p\n",
>  		riowd_timeout, p->regs);
>  
> -	dev_set_drvdata(&op->dev, p);
> +	platform_set_drvdata(op, p);
>  	return 0;
>  
>  out_iounmap:
> @@ -222,7 +222,7 @@ out:
>  
>  static int riowd_remove(struct platform_device *op)
>  {
> -	struct riowd *p = dev_get_drvdata(&op->dev);
> +	struct riowd *p = platform_get_drvdata(op);
>  
>  	misc_deregister(&riowd_miscdev);
>  	of_iounmap(&op->resource[0], p->regs, 2);
> -- 
> 1.7.10.4
> 
> 
> 
