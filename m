Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaFNTfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:35:37 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49827 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaFNTfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:35:36 -0400
Message-ID: <539CA40E.10800@cogentembedded.com>
Date: Sat, 14 Jun 2014 23:35:42 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nick <xerofoify@gmail.com>, emilio@elopez.com.ar
CC: maxime.ripard@free-electrons.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Frees gate after if statement in clk-sunxi.c
References: <1402769508-3821-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1402769508-3821-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2014 10:11 PM, Nick wrote:

> Signed-off-by: Nick <xerofoify@gmail.com>
> ---
>   drivers/clk/sunxi/clk-sunxi.c | 1 +
>   1 file changed, 1 insertion(+)

> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 4264834..6f4fc51 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -42,6 +42,7 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
>   	u32 rate;
>
>   	if (of_property_read_u32(node, "clock-frequency", &rate))
> +		kree(gate);

    'gate' is not allocated at this point either... at least not in Linus' tree.

>   		return;

    And you forgot {} around these 2 statements.

WBR, Sergei

