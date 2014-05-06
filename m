Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654AbaEFJ3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:29:52 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:54730 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934490AbaEFJ3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <1398172554-22053-1-git-send-email-valentin.ilie@gmail.com>
References: <1398172554-22053-1-git-send-email-valentin.ilie@gmail.com>
From: Valentin Ilie <valentin.ilie@gmail.com>
Date: Tue, 6 May 2014 12:29:29 +0300
X-Google-Sender-Auth: 3mpxA-YjjwTYIj-2zmSfnnFHbPc
Message-ID: <CAHuBVBZbLbAuVp3bwnWO45=9=irS8krPKiS905eC0K1Bgs4S9g@mail.gmail.com>
Subject: Re: [PATCH] clk: st: Fix memory leak
To: Mike Turquette <mturquette@linaro.org>, pankaj.dev@st.com,
        gabriel.fernandez@st.com
Cc: linux-kernel@vger.kernel.org, Valentin Ilie <valentin.ilie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2014 16:15, Valentin Ilie <valentin.ilie@gmail.com> wrote:
> When it fails to allocate div, gate should be free'd before return
>
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
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

Can someone look into this?

-- 
Valentin Ilie
