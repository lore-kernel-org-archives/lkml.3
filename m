Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaEWWOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:14:12 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42838 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEWWOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:14:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Valentin Ilie <valentin.ilie@gmail.com>, pankaj.dev@st.com,
        gabriel.fernandez@st.com
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1398172554-22053-1-git-send-email-valentin.ilie@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Valentin Ilie" <valentin.ilie@gmail.com>
References: <1398172554-22053-1-git-send-email-valentin.ilie@gmail.com>
Message-ID: <20140523221359.23136.66960@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: st: Fix memory leak
Date: Fri, 23 May 2014 15:13:59 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Valentin Ilie (2014-04-22 06:15:54)
> When it fails to allocate div, gate should be free'd before return
> 
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>

Taken into clk-fixes.

Regards,
Mike

> ---
>  drivers/clk/st/clkgen-pll.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
> index bca0a0b..a886702 100644
> --- a/drivers/clk/st/clkgen-pll.c
> +++ b/drivers/clk/st/clkgen-pll.c
> @@ -521,8 +521,10 @@ static struct clk * __init clkgen_odf_register(const char *parent_name,
>         gate->lock = odf_lock;
>  
>         div = kzalloc(sizeof(*div), GFP_KERNEL);
> -       if (!div)
> +       if (!div) {
> +               kfree(gate);
>                 return ERR_PTR(-ENOMEM);
> +       }
>  
>         div->flags = CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO;
>         div->reg = reg + pll_data->odf[odf].offset;
> -- 
> 1.8.3.2
> 
