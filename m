Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaBGKHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:07:15 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39378 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaBGKHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:07:09 -0500
MIME-Version: 1.0
In-Reply-To: <001601cf23dc$bd8b3d30$38a1b790$%han@samsung.com>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
	<001601cf23dc$bd8b3d30$38a1b790$%han@samsung.com>
Date: Fri, 7 Feb 2014 15:37:09 +0530
Message-ID: <CAKohpo=3BR4hA9HVOuhJs+FZNVeatXkmNkS43C_cLxL2Z9KQ9Q@mail.gmail.com>
Subject: Re: [PATCH 10/10] rtc: rtc-spear: Remove unnecessary OOM messages
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Rajeev kumar <rajeev-dlh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 February 2014 13:45, Jingoo Han <jg1.han@samsung.com> wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-spear.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
> index c492cf0..d2cdb98 100644
> --- a/drivers/rtc/rtc-spear.c
> +++ b/drivers/rtc/rtc-spear.c
> @@ -365,10 +365,8 @@ static int spear_rtc_probe(struct platform_device *pdev)
>         }
>
>         config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
> -       if (!config) {
> -               dev_err(&pdev->dev, "out of memory\n");
> +       if (!config)
>                 return -ENOMEM;
> -       }
>
>         /* alarm irqs */
>         irq = platform_get_irq(pdev, 0);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
