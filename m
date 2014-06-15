Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaFOBb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 21:31:56 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:54291 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaFOBbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 21:31:55 -0400
Message-ID: <539CF77C.4010500@elopez.com.ar>
Date: Sat, 14 Jun 2014 22:31:40 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick <xerofoify@gmail.com>
CC: mturquette@linaro.org, maxime.ripard@free-electrons.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHV2]Fixes memory leak in clk-sunxi.c
References: <1402794944-3357-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1402794944-3357-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El 14/06/14 22:15, Nick escribió:
> Signed-off-by: Nick <xerofoify@gmail.com>
> ---
>   drivers/clk/sunxi/clk-sunxi.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 6f4fc51..c2ce538 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -41,10 +41,10 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
>   	const char *clk_name = node->name;
>   	u32 rate;
>
> -	if (of_property_read_u32(node, "clock-frequency", &rate))
> +	if (of_property_read_u32(node, "clock-frequency", &rate)) {
>   		kree(gate);
>   		return;
> -
> +	}
>   	/* allocate fixed-rate and gate clock structs */
>   	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
>   	if (!fixed)
>

There is no memory leak there, and I think the message was pretty clear 
when I mentioned it[1] and then Sergei mentioned it[2] twice[3]. As for 
the bug report[4] you linked in a private email, it has been closed as 
resolved by the original reporter.

Cheers,

Emilio

[1] 
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/263631.html
[2] 
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/263677.html
[3] 
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/263683.html
[4] https://bugzilla.kernel.org/show_bug.cgi?id=59961
