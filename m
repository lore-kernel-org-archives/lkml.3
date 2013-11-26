Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3KZXud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:50:33 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:37802 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3KZXuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:50:32 -0500
Date: Tue, 26 Nov 2013 15:50:26 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: dwmw2@infradead.org, wfp5p@virginia.edu, artem.bityutskiy@linux.intel.com,
        jg1.han@samsung.com, yongjun_wei@trendmicro.com.cn,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Alchemy: add missing platform_set_drvdata() in
 au1550nd_probe()
Message-ID: <20131126235026.GN9468@ld-irv-0074.broadcom.com>
References: <CAPgLHd-qf8Zj0gWgJh3_WMZOAx5-H6aABrVFqRsAw=XkOfDdmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-qf8Zj0gWgJh3_WMZOAx5-H6aABrVFqRsAw=XkOfDdmw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 02:18:29PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add missing platform_set_drvdata() in au1550nd_probe(), otherwise
> calling platform_get_drvdata() in remove returns NULL.

An alternative solution: just allocate ctx with devm_kzalloc(). Then you
don't have to kfree() it at all.

I don't mind one solution over the other too much. Let me know which
you'd prefer.

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mtd/nand/au1550nd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
> index ae8dd7c..909b673 100644
> --- a/drivers/mtd/nand/au1550nd.c
> +++ b/drivers/mtd/nand/au1550nd.c
> @@ -480,6 +480,8 @@ static int au1550nd_probe(struct platform_device *pdev)
>  
>  	mtd_device_register(&ctx->info, pd->parts, pd->num_parts);
>  
> +	platform_set_drvdata(pdev, ctx);
> +

Personally, I'd choose to call platform_set_drvdata() earlier in the
probe routine (e.g., immediately after its allocation), in case we end
up calling platform_get_drvdata() from some sub-routine in the future.

>  	return 0;
>  
>  out3:
> 

Brian
