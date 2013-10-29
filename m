Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3J2NqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:46:14 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:59125 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab3J2NqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:46:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8oLgehkC-4LdRgiASnZGfk0u3ueVQw8f4J6g+3zeT5tQ@mail.gmail.com>
References: <CAPgLHd8oLgehkC-4LdRgiASnZGfk0u3ueVQw8f4J6g+3zeT5tQ@mail.gmail.com>
Date: Tue, 29 Oct 2013 19:16:12 +0530
X-Google-Sender-Auth: v5N6uL25_KiSE-CxVvW5YGzMnUg
Message-ID: <CAOh2x==aeT-DU+PoqzGRoe+RaL0K+sVFmSLKTqC_20BQ0QmtTw@mail.gmail.com>
Subject: Re: [PATCH] ARM: spear: fix return value check in spear_setup_of_timer()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Shiraz HASHIM <shiraz.hashim@st.com>,
        Russell King <linux@arm.linux.org.uk>, yongjun_wei@trendmicro.com.cn,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 7:34 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function clk_get_sys() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check
> should be replaced with IS_ERR().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  arch/arm/mach-spear/time.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-spear/time.c b/arch/arm/mach-spear/time.c
> index d449673..3263a34 100644
> --- a/arch/arm/mach-spear/time.c
> +++ b/arch/arm/mach-spear/time.c
> @@ -222,7 +222,7 @@ void __init spear_setup_of_timer(void)
>         }
>
>         gpt_clk = clk_get_sys("gpt0", NULL);
> -       if (!gpt_clk) {
> +       if (IS_ERR(gpt_clk)) {
>                 pr_err("%s:couldn't get clk for gpt\n", __func__);
>                 goto err_iomap;
>         }

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
