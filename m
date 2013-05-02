Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab3EBNay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:30:54 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:39015 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab3EBNax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:30:53 -0400
Message-ID: <51826A70.9050904@cogentembedded.com>
Date: Thu, 02 May 2013 17:30:24 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Laurent Navet <laurent.navet@gmail.com>
CC: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com, m-karicheri2@ti.com,
        mturquette@linaro.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mtd: nand: davinci: use devm_ioremap_resource()
References: <1367500934-28030-1-git-send-email-laurent.navet@gmail.com>
In-Reply-To: <1367500934-28030-1-git-send-email-laurent.navet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-05-2013 17:22, Laurent Navet wrote:

> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

> Found with coccicheck and this semantic patch:
>   scripts/coccinelle/api/devm_request_and_ioremap.cocci.

> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>   drivers/mtd/nand/davinci_nand.c |   13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)

> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index 94e17af..4a96e58 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -623,11 +623,14 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>   		goto err_nomem;
>   	}
>
> -	vaddr = devm_request_and_ioremap(&pdev->dev, res1);
> -	base = devm_request_and_ioremap(&pdev->dev, res2);
> -	if (!vaddr || !base) {
> -		dev_err(&pdev->dev, "ioremap failed\n");
> -		ret = -EADDRNOTAVAIL;
> +	vaddr = devm_ioremap_resource(&pdev->dev, res1);
> +	base = devm_ioremap_resource(&pdev->dev, res2);

    I'd rather put this line before its corresponding error check.

> +	if (IS_ERR(vaddr)) {
> +		ret = PTR_ERR(vaddr);
> +		goto err_ioremap;
> +	}
> +	if (IS_ERR(base)) {
> +		ret = PTR_ERR(base);
>   		goto err_ioremap;
>   	}

WBR, Sergei

