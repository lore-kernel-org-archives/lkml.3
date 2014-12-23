Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbaLWW7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 17:59:39 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37327 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaLWW7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 17:59:37 -0500
Message-ID: <5499F3D4.6040302@cogentembedded.com>
Date: Wed, 24 Dec 2014 01:59:32 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: mturquette@linaro.org, linux-kernel@vger.kernel.org
CC: linux-sh@vger.kernel.org, vksavl@gmail.com
Subject: Re: [PATCH] clk-rcar-gen2: RCAN clock support
References: <201407310023.43605.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201407310023.43605.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/31/2014 12:23 AM, Sergei Shtylyov wrote:

> Add RCAN clock support to the R-Car generation 2 CPG driver. This clock gets
> derived from the USB_EXTAL clock by dividing it by 6. The layout of RCANCKCR
> register is close to those of the clocks supported by the 'clk-div6'  driver
> but has no divider field, and so can't be supported by that driver...

> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

> ---
> The patch is against the 'clk-next' branch of Mike Turquette's 'linux.git' repo.
>
>   drivers/clk/shmobile/clk-rcar-gen2.c |   99 +++++++++++++++++++++++++++++++++++
>   1 file changed, 99 insertions(+)

> Index: linux/drivers/clk/shmobile/clk-rcar-gen2.c
> ===================================================================
> --- linux.orig/drivers/clk/shmobile/clk-rcar-gen2.c
> +++ linux/drivers/clk/shmobile/clk-rcar-gen2.c
[...]
> +static struct clk * __init cpg_rcan_clk_register(struct rcar_gen2_cpg *cpg,
> +						 struct device_node *np)
> +{
> +	static const char *parent_name;

    No need for this *static*...

> +	struct clk_init_data init;
> +	struct cpg_rcan_clk *rcanclk;
> +	struct clk *clk;
> +
> +	rcanclk = kzalloc(sizeof(*rcanclk), GFP_KERNEL);
> +	if (!rcanclk)
> +		return ERR_PTR(-ENOMEM);
> +
> +	parent_name = of_clk_get_parent_name(np, 1);
> +
> +	init.name = "rcan";
> +	init.ops = &cpg_rcan_clk_ops;
> +	init.parent_names = &parent_name;
> +	init.num_parents = 1;

    Ugh, forgot to clear the 'init.flags', so that it has some random value...

WBR, Sergei

