Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3KKLsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:48:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37864 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3KKLsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:48:45 -0500
Date: Mon, 11 Nov 2013 14:48:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Subject: Re: [patch] vlynq: fix another resource size off by 1 error
Message-ID: <20131111114827.GE5443@mwanda>
References: <20130823081949.GD31293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823081949.GD31293@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We still need to apply this fix.

regards,
dan carpenter

On Fri, Aug 23, 2013 at 11:19:49AM +0300, Dan Carpenter wrote:
> We fixed the call to request_mem_region() patch
> 3354f73 ('drivers/vlynq/vlynq.c: fix resource size off by 1 error').
> But we need to fix the call the release_mem_region() as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker stuff.
> 
> diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
> index 7b07135..c0227f9 100644
> --- a/drivers/vlynq/vlynq.c
> +++ b/drivers/vlynq/vlynq.c
> @@ -762,7 +762,8 @@ static int vlynq_remove(struct platform_device *pdev)
>  
>  	device_unregister(&dev->dev);
>  	iounmap(dev->local);
> -	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start);
> +	release_mem_region(dev->regs_start,
> +			   dev->regs_end - dev->regs_start + 1);
>  
>  	kfree(dev);
>  
