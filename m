Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaFPJOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:14:30 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43381 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbaFPJO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:14:29 -0400
Date: Mon, 16 Jun 2014 10:14:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: syscon: Use module_platform_driver()
Message-ID: <20140616091423.GJ14323@lee--X1>
References: <1402324454-15872-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402324454-15872-1-git-send-email-wangkefeng.wang@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014, Kefeng Wang wrote:

> Convert to module_platform_drive() to eliminate boilerplate code.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  drivers/mfd/syscon.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index ca15878..6c2c874 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -173,17 +173,7 @@ static struct platform_driver syscon_driver = {
>  	.id_table	= syscon_ids,
>  };
>  
> -static int __init syscon_init(void)
> -{
> -	return platform_driver_register(&syscon_driver);
> -}
> -postcore_initcall(syscon_init);
> -
> -static void __exit syscon_exit(void)
> -{
> -	platform_driver_unregister(&syscon_driver);
> -}
> -module_exit(syscon_exit);
> +module_platform_driver(syscon_driver)

You have changed the initialisation semantics of quite an important
driver here.  Initialising with postcore_initcall() is not so boiler
plate and swapping it out for a module_init() as you're doing with
this patch will probably break some systems.

>  MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
>  MODULE_DESCRIPTION("System Control driver");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
