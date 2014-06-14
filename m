Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaFNRWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 13:22:38 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:35296 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaFNRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 13:22:36 -0400
Message-ID: <539C84E2.6060209@cogentembedded.com>
Date: Sat, 14 Jun 2014 21:22:42 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nick <xerofoify@gmail.com>, emilio@elopez.com.ar
CC: maxime.ripard@free-electrons.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Fixes two memory leaks in drivers/clk/sunxi/clk-sunxi.c
References: <1402710473-3295-1-git-send-email-nickkrause@sympatico.ca>
In-Reply-To: <1402710473-3295-1-git-send-email-nickkrause@sympatico.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/14/2014 05:47 AM, Nick wrote:

   Please sign off on your patches, they can't applied otherwise.

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

    Eh, we only allocate 'fixed' after this point, no?

> +		kfree(gate);
>   		return;
> -
> +	}
>   	/* allocate fixed-rate and gate clock structs */
>   	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
>   	if (!fixed)

WBR, Sergei

