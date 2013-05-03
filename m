Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab3ECG6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:58:36 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:37526 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933419Ab3ECG6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:58:35 -0400
Date: Fri, 3 May 2013 12:27:45 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 04/42] rtc: rtc-ab8500: remove unnecessary
 platform_set_drvdata()
Message-ID: <20130503065743.GA24864@bnru09>
References: <001201ce47c6$daecece0$90c6c6a0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <001201ce47c6$daecece0$90c6c6a0$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 08:24:24 +0200, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-ab8500.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
> index 63cfa31..c5b62d4 100644
> --- a/drivers/rtc/rtc-ab8500.c
> +++ b/drivers/rtc/rtc-ab8500.c
> @@ -451,8 +451,6 @@ static int ab8500_rtc_remove(struct platform_device *pdev)
>  {
>  	ab8500_sysfs_rtc_unregister(&pdev->dev);
>  
> -	platform_set_drvdata(pdev, NULL);
> -
>  	return 0;
>  }
Ok, thanks. Hope you have taken care for the ab3100 too...

Acked-by:srinidhi kasagar <srinidhi.kasagar@stericsson.com>

regards/srinidhi 
