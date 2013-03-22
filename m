Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422669Ab3CVRVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:21:43 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38616 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636Ab3CVRVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:21:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Wei Yongjun <weiyj.lk@gmail.com>, Baohua.Song@csr.com
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAPgLHd82XEZEP4eDvmvPjdHHz6u40+16W1GZeCWWw6Cj3SAwCg@mail.gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <CAPgLHd82XEZEP4eDvmvPjdHHz6u40+16W1GZeCWWw6Cj3SAwCg@mail.gmail.com>
Message-ID: <20130322172137.834.44023@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: prima2: fix return value check in sirfsoc_of_clk_init()
Date: Fri, 22 Mar 2013 10:21:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Wei Yongjun (2013-03-11 08:55:18)
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function clk_get() returns ERR_PTR()
> not NULL. The NULL test in the return value check should
> be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/clk/clk-prima2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk-prima2.c b/drivers/clk/clk-prima2.c
> index f8e9d0c..b208665 100644
> --- a/drivers/clk/clk-prima2.c
> +++ b/drivers/clk/clk-prima2.c
> @@ -1113,7 +1113,7 @@ void __init sirfsoc_of_clk_init(void)
>  
>         for (i = pll1; i < maxclk; i++) {
>                 prima2_clks[i] = clk_register(NULL, prima2_clk_hw_array[i]);
> -               BUG_ON(!prima2_clks[i]);
> +               BUG_ON(IS_ERR(prima2_clks[i]);
>         }
>         clk_register_clkdev(prima2_clks[cpu], NULL, "cpu");
>         clk_register_clkdev(prima2_clks[io],  NULL, "io");

This patch failed to compile.  Fix is below and applied to clk-next.
Let me know if you have any issue with it:

Regards,
Mike



diff --git a/drivers/clk/clk-prima2.c b/drivers/clk/clk-prima2.c
index b208665..643ca65 100644
--- a/drivers/clk/clk-prima2.c
+++ b/drivers/clk/clk-prima2.c
@@ -1113,7 +1113,7 @@ void __init sirfsoc_of_clk_init(void)
 
 	for (i = pll1; i < maxclk; i++) {
 		prima2_clks[i] = clk_register(NULL, prima2_clk_hw_array[i]);
-		BUG_ON(IS_ERR(prima2_clks[i]);
+		BUG_ON(IS_ERR(prima2_clks[i]));
 	}
 	clk_register_clkdev(prima2_clks[cpu], NULL, "cpu");
 	clk_register_clkdev(prima2_clks[io],  NULL, "io");
