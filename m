Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3J3Tqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:46:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41275 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab3J3Tql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:46:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Haojian Zhuang <haojian.zhuang@linaro.org>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1382255335-8131-1-git-send-email-haojian.zhuang@linaro.org>
Cc: patches@linaro.org, Haojian Zhuang <haojian.zhuang@linaro.org>
References: <1382255335-8131-1-git-send-email-haojian.zhuang@linaro.org>
Message-ID: <20131030194603.11662.3399@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: mux: fix the return value of get_parent
Date: Wed, 30 Oct 2013 12:46:03 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Haojian Zhuang (2013-10-20 00:48:55)
> If there're no parents on the clock mux node, it should return 0, not an
> errnor code.
> 
> The orphan clock node is using get_parent() to get the index of its
> parents in__clk_init(). If the return value is negative, it'll be
> transformed to a u8 value (clk_mux_get_parent()). Then the orphan clock
> node tries to get its parent with the invalid index. It will only cause
> accessing memory beyond border.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>

Taken into clk-next.

Thanks!
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
> 1.8.1.2
