Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934906AbaEaAIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:08:37 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57924 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934638AbaEaAIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:08:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
User-Agent: alot/0.3.5
To: Colin King <colin.king@canonical.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
References: <1397325554-1439-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1397325554-1439-1-git-send-email-colin.king@canonical.com>
Message-ID: <20140531000831.10062.52682@quantum>
Subject: Re: [PATCH] clk: versatile: free icst on error return
Date: Fri, 30 May 2014 17:08:31 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Colin King (2014-04-12 10:59:14)
> From: Colin Ian King <colin.king@canonical.com>
> 
> commit a183da63 introduced a new error return path that does
> not kfree icst if the kmemdup of desc->params fails.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to clk-next.

Thanks,
Mike

> ---
>  drivers/clk/versatile/clk-icst.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
> index a820b0c..eb3a1e4 100644
> --- a/drivers/clk/versatile/clk-icst.c
> +++ b/drivers/clk/versatile/clk-icst.c
> @@ -140,6 +140,7 @@ struct clk *icst_clk_register(struct device *dev,
>  
>         pclone = kmemdup(desc->params, sizeof(*pclone), GFP_KERNEL);
>         if (!pclone) {
> +               kfree(icst);
>                 pr_err("could not clone ICST params\n");
>                 return ERR_PTR(-ENOMEM);
>         }
> -- 
> 1.9.1
> 
