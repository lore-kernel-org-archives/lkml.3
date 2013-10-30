Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3J3Trs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:47:48 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56049 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3J3Trq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:47:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Russ Dill <Russ.Dill@ti.com>, linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1382345990-20623-1-git-send-email-Russ.Dill@ti.com>
Cc: linux-kernel@vger.kernel.org, Russ Dill <Russ.Dill@ti.com>
References: <1382345990-20623-1-git-send-email-Russ.Dill@ti.com>
Message-ID: <20131030194722.11662.27225@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: mux: Return a sane value on error
Date: Wed, 30 Oct 2013 12:47:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Russ Dill (2013-10-21 01:59:50)
> The get_parent op is defined as returning u8, but clk-mux is
> returning negative values on error.  Code within drivers/clk/clk.c
> uses this return value as an index into an array which could
> cause an oops.
> 
> Signed-off-by: Russ Dill <Russ.Dill@ti.com>

Hi Russ,

Thanks for the fix. Haojian Zhuang sent an identical fix the day before
you so I took his in ;-)

Regards,
Mike

> ---
>  drivers/clk/clk-mux.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
> index 4f96ff3..cc06015 100644
> --- a/drivers/clk/clk-mux.c
> +++ b/drivers/clk/clk-mux.c
> @@ -51,7 +51,7 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
>                 for (i = 0; i < num_parents; i++)
>                         if (mux->table[i] == val)
>                                 return i;
> -               return -EINVAL;
> +               return 0;
>         }
>  
>         if (val && (mux->flags & CLK_MUX_INDEX_BIT))
> @@ -61,7 +61,7 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
>                 val--;
>  
>         if (val >= num_parents)
> -               return -EINVAL;
> +               return 0;
>  
>         return val;
>  }
> -- 
> 1.8.3.2
