Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbaD3Ik3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:40:29 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:40419 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaD3Ik1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:40:27 -0400
Message-ID: <5360B6D9.7070409@elopez.com.ar>
Date: Wed, 30 Apr 2014 05:39:53 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?0JDQu9C10LrRgdCw0L3QtNGAINCR0LXRgNGB0LXQvdC10LI=?= 
	<bay@hackerdom.ru>
CC: linux-sunxi@googlegroups.com, mturquette@linaro.org,
        maxime.ripard@free-electrons.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sunxi: make gate clock getable by name
References: <fa26ae07-b4ee-4730-b626-9724a51e7122@googlegroups.com>
In-Reply-To: <fa26ae07-b4ee-4730-b626-9724a51e7122@googlegroups.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El 30/04/14 05:25, Александр Берсенев escribió:
> This patch enables to use devm_clk_get function to get gate clocks by name.
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
>
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 31584ee..3617681 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -1048,6 +1048,8 @@ static void __init sunxi_gates_clk_setup(struct
> device_node *node,
>       reg + 4 * (i/32), i % 32,
>       0, &clk_lock);
> WARN_ON(IS_ERR(clk_data->clks[i]));
> +if (!IS_ERR(clk_data->clks[i]))
> +clk_register_clkdev(clk_data->clks[i], clk_name, NULL);
> j++;
> }

What are you trying to achieve here? Do you want to use devm_clk_get on 
your driver? If so, you just need to list the clock your device needs on 
its device tree node, like for example

device: blah@0f0.... {
        ....
        clocks = <&gate 12>, <&clock>, <&whatever>;
        clock-names = "module", "ref", "sample";
}

And then you can pass "module", "ref" or "sample" to devm_clk_get to get 
the respective clock.

Cheers,

Emilio
