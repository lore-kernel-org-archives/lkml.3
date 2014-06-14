Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaFNCLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 22:11:32 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:50645 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbaFNCLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 22:11:31 -0400
Message-ID: <539BAF40.4060800@elopez.com.ar>
Date: Fri, 13 Jun 2014 23:11:12 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick <xerofoify@gmail.com>
CC: mturquette@linaro.org, maxime.ripard@free-electrons.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Fixes two memory leaks in drivers/clk/sunxi/clk-sunxi.c
References: <1402710473-3295-1-git-send-email-nickkrause@sympatico.ca>
In-Reply-To: <1402710473-3295-1-git-send-email-nickkrause@sympatico.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El 13/06/14 22:47, Nick escribió:
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 4264834..07b45d1 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -41,9 +41,11 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
>   	const char *clk_name = node->name;
>   	u32 rate;
>
> -	if (of_property_read_u32(node, "clock-frequency", &rate))
> +	if (of_property_read_u32(node, "clock-frequency", &rate)) {
> +		kfree(fixed);
> +		kfree(gate);

Why are you trying to free these two, when they haven't been allocated yet?

>   		return;
> -
> +	}
>   	/* allocate fixed-rate and gate clock structs */
>   	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
>   	if (!fixed)
>

fixed is allocated here. gate follows suit after it.

Cheers,

Emilio

PS: For next time, please use a proper prefix on your patch subject 
("clk: sunxi: " in this case) as well as add a description to your patch 
and a signoff line.
