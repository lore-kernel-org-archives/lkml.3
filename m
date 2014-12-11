Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476AbaLKR4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:56:35 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:38724 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbaLKR4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:56:34 -0500
MIME-Version: 1.0
In-Reply-To: <1418130803-27443-1-git-send-email-weiyj_lk@163.com>
References: <1418130803-27443-1-git-send-email-weiyj_lk@163.com>
Date: Thu, 11 Dec 2014 10:56:33 -0700
Message-ID: <CANLsYkyq-4pY9NEsL2dNgNv+FdEPxJ49c8GA_XPUuqpfFhZoag@mail.gmail.com>
Subject: Re: [PATCH -next] coresight-tpiu: use module_amba_driver to simplify
 the code
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: weiyj_lk@163.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 December 2014 at 06:13,  <weiyj_lk@163.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> module_amba_driver() makes the code simpler by eliminating
> boilerplate code.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/coresight/coresight-tpiu.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
>
> diff --git a/drivers/coresight/coresight-tpiu.c b/drivers/coresight/coresight-tpiu.c
> index ae10108..3b33af2 100644
> --- a/drivers/coresight/coresight-tpiu.c
> +++ b/drivers/coresight/coresight-tpiu.c
> @@ -201,17 +201,7 @@ static struct amba_driver tpiu_driver = {
>         .id_table       = tpiu_ids,
>  };
>
> -static int __init tpiu_init(void)
> -{
> -       return amba_driver_register(&tpiu_driver);
> -}
> -module_init(tpiu_init);
> -
> -static void __exit tpiu_exit(void)
> -{
> -       amba_driver_unregister(&tpiu_driver);
> -}
> -module_exit(tpiu_exit);
> +module_amba_driver(tpiu_driver);

This looks good - please merge your 4 patches in the same one.

>
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("CoreSight Trace Port Interface Unit driver");
>
