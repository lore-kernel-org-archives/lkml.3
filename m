Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3CLCA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:00:28 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:65350 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3CLCA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:00:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd82XEZEP4eDvmvPjdHHz6u40+16W1GZeCWWw6Cj3SAwCg@mail.gmail.com>
References: <CAPgLHd82XEZEP4eDvmvPjdHHz6u40+16W1GZeCWWw6Cj3SAwCg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 12 Mar 2013 10:00:06 +0800
Message-ID: <CAGsJ_4ykNjO9rxB9_THY8Vb+Q7aYZiwDxjA=EWOOSumZmtHtnw@mail.gmail.com>
Subject: Re: [PATCH] clk: prima2: fix return value check in sirfsoc_of_clk_init()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mturquette@linaro.org, Baohua.Song@csr.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/11 Wei Yongjun <weiyj.lk@gmail.com>:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function clk_get() returns ERR_PTR()
> not NULL. The NULL test in the return value check should
> be replaced with IS_ERR().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked. Thanks!

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
>

-barry
