Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3EVEua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 00:50:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61751 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3EVEuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 00:50:25 -0400
Message-ID: <519C4E4D.1060101@huawei.com>
Date: Wed, 22 May 2013 12:49:17 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <vinod.koul@intel.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Libo Chen <libo.chen@huawei.com>, <agust@denx.de>, <phdm@macqel.be>,
        <benh@kernel.crashing.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] bestcomm: no need to free when kzalloc fail
References: <1367743104-3448-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1367743104-3448-1-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ping...

On 2013/5/5 16:38, chenlibo.3@gmail.com wrote:
> From: Libo Chen <libo.chen@huawei.com>
> 
> There is no need to free bcom_eng if kzalloc fail
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/dma/bestcomm/bestcomm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/bestcomm/bestcomm.c b/drivers/dma/bestcomm/bestcomm.c
> index a8c2e29..300ee2d 100644
> --- a/drivers/dma/bestcomm/bestcomm.c
> +++ b/drivers/dma/bestcomm/bestcomm.c
> @@ -400,7 +400,7 @@ static int mpc52xx_bcom_probe(struct platform_device *op)
>  		printk(KERN_ERR DRIVER_NAME ": "
>  			"Can't allocate state structure\n");
>  		rv = -ENOMEM;
> -		goto error_sramclean;
> +		goto error_kzalloc;
>  	}
>  
>  	/* Save the node */
> @@ -449,6 +449,7 @@ error_release:
>  	release_mem_region(res_bcom.start, sizeof(struct mpc52xx_sdma));
>  error_sramclean:
>  	kfree(bcom_eng);
> +error_kzalloc:
>  	bcom_sram_cleanup();
>  error_ofput:
>  	of_node_put(op->dev.of_node);
> 


