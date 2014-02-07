Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaBGMIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:08:55 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61332 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaBGMIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:08:52 -0500
MIME-Version: 1.0
In-Reply-To: <001201cf23dc$4c8cd8f0$e5a68ad0$%han@samsung.com>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com> <001201cf23dc$4c8cd8f0$e5a68ad0$%han@samsung.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 7 Feb 2014 20:08:31 +0800
X-Google-Sender-Auth: lPvkhEc8kEPCQAYcw1Y7GBjOV9U
Message-ID: <CAGsJ_4yYte6M13xwSnNGRiiHnnH19fZ57H=qCELaXQ9n0wrTRQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] rtc: rtc-sirfsoc: Remove unnecessary OOM messages
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Xianglong Du <Xianglong.Du@csr.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-07 16:12 GMT+08:00 Jingoo Han <jg1.han@samsung.com>:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---

Acked-by: Barry Song <Baohua.Song@csr.com>

>  drivers/rtc/rtc-sirfsoc.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/rtc/rtc-sirfsoc.c b/drivers/rtc/rtc-sirfsoc.c
> index 3eb3642..9e3cbce 100644
> --- a/drivers/rtc/rtc-sirfsoc.c
> +++ b/drivers/rtc/rtc-sirfsoc.c
> @@ -264,12 +264,8 @@ static int sirfsoc_rtc_probe(struct platform_device *pdev)
>
>         rtcdrv = devm_kzalloc(&pdev->dev,
>                 sizeof(struct sirfsoc_rtc_drv), GFP_KERNEL);
> -       if (rtcdrv == NULL) {
> -               dev_err(&pdev->dev,
> -                       "%s: can't alloc mem for drv struct\n",
> -                       pdev->name);
> +       if (rtcdrv == NULL)
>                 return -ENOMEM;
> -       }
>
>         err = of_property_read_u32(np, "reg", &rtcdrv->rtc_base);
>         if (err) {
> --
> 1.7.10.4
>
>
-barry
