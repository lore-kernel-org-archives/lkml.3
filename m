Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbaKRWfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 17:35:44 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63244 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaKRWfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 17:35:42 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Zhen Lei <thunder.leizhen@huawei.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1415931040-9868-1-git-send-email-thunder.leizhen@huawei.com>
Cc: "Zefan Li" <lizefan@huawei.com>, "Xinwei Hu" <huxinwei@huawei.com>,
        "Tianhong Ding" <dingtianhong@huawei.com>,
        "Kefeng Wang" <wangkefeng.wang@huawei.com>,
        "Zhen Lei" <thunder.leizhen@huawei.com>
References: <1415931040-9868-1-git-send-email-thunder.leizhen@huawei.com>
Message-ID: <20141118223538.25314.21064@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 1/1] clk: delete a local variable's repeated assignment
Date: Tue, 18 Nov 2014 14:35:38 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Zhen Lei (2014-11-13 18:10:40)
> It's the same to the next statement, "ret = clk->parent". I think compiler will
> optimize it, it's just not looking well.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Applied.

Thanks,
Mike

> ---
>  drivers/clk/clk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 4896ae9..5307225 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1614,7 +1614,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
> 
>         if (clk->num_parents == 1) {
>                 if (IS_ERR_OR_NULL(clk->parent))
> -                       ret = clk->parent = __clk_lookup(clk->parent_names[0]);
> +                       clk->parent = __clk_lookup(clk->parent_names[0]);
>                 ret = clk->parent;
>                 goto out;
>         }
> --
> 1.8.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
