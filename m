Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaKDQVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:21:11 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57742 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaKDQVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:21:06 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/1] of/fdt: simplify early_init_dt_verify
To: Zhen Lei <thunder.leizhen@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
In-Reply-To: <1414497065-9808-1-git-send-email-thunder.leizhen@huawei.com>
References: <1414497065-9808-1-git-send-email-thunder.leizhen@huawei.com>
Date: Tue, 04 Nov 2014 16:20:54 +0000
Message-Id: <20141104162054.4CC9BC423D0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 19:51:05 +0800
, Zhen Lei <thunder.leizhen@huawei.com>
 wrote:
> put off initial_boot_params = params; until all checks finished. If any check
> failed, initial_boot_params is equal NULL, base upon bss segment initial value.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Interesting. I received exactly the same patch from Bjorn Helgaas. Were
the two of you working together, or is this merely a coincedence?

g.

> ---
>  drivers/of/fdt.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index d1ffca8..325c638 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -994,14 +994,12 @@ bool __init early_init_dt_verify(void *params)
>  	if (!params)
>  		return false;
> 
> -	/* Setup flat device-tree pointer */
> -	initial_boot_params = params;
> -
>  	/* check device tree validity */
> -	if (fdt_check_header(params)) {
> -		initial_boot_params = NULL;
> +	if (fdt_check_header(params))
>  		return false;
> -	}
> +
> +	/* Setup flat device-tree pointer */
> +	initial_boot_params = params;
> 
>  	return true;
>  }
> --
> 1.8.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

