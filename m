Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaFSLY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:24:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42593 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220AbaFSLY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:24:57 -0400
Message-ID: <53A2C898.4090607@ti.com>
Date: Thu, 19 Jun 2014 14:25:12 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, J Keerthy <j-keerthy@ti.com>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] CLK: TI: APLL: not allocating enough data
References: <20140616093233.GA9446@mwanda>
In-Reply-To: <20140616093233.GA9446@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 12:32 PM, Dan Carpenter wrote:
> There is a cut and paste bug here which will lead to memory corruption
> because we don't allocate enough data.
>
> Fixes: 4d008589e271 ('CLK: TI: APLL: add support for omap2 aplls')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, queued for 3.16-rc fixes.

-Tero

>
> diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
> index 5428c9c..18dbaf12 100644
> --- a/drivers/clk/ti/apll.c
> +++ b/drivers/clk/ti/apll.c
> @@ -338,7 +338,7 @@ static void __init of_omap2_apll_setup(struct device_node *node)
>   	const char *parent_name;
>   	u32 val;
>
> -	ad = kzalloc(sizeof(*clk_hw), GFP_KERNEL);
> +	ad = kzalloc(sizeof(*ad), GFP_KERNEL);
>   	clk_hw = kzalloc(sizeof(*clk_hw), GFP_KERNEL);
>   	init = kzalloc(sizeof(*init), GFP_KERNEL);
>
>

