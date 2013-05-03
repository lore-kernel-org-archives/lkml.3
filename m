Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab3ECP51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:57:27 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:50339 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab3ECP5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:57:24 -0400
Message-ID: <56767.128.237.228.195.1367598629.squirrel@mprc.pku.edu.cn>
In-Reply-To: <003601ce47c8$f9aa1e30$ecfe5a90$@samsung.com>
References: <003601ce47c8$f9aa1e30$ecfe5a90$@samsung.com>
Date: Sat, 4 May 2013 00:30:29 +0800 (CST)
Subject: Re: [PATCH 40/42] rtc: rtc-puv3: remove unnecessary 
     platform_set_drvdata()
From: "Xuetao Guan" <gxt@mprc.pku.edu.cn>
To: "Jingoo Han" <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "Jingoo Han" <jg1.han@samsung.com>,
        "'Guan Xuetao'" <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Thanks.

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

> ---
>  drivers/rtc/rtc-puv3.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
> index 72f4371..402732c 100644
> --- a/drivers/rtc/rtc-puv3.c
> +++ b/drivers/rtc/rtc-puv3.c
> @@ -224,7 +224,6 @@ static int puv3_rtc_remove(struct platform_device
> *dev)
>  {
>  	struct rtc_device *rtc = platform_get_drvdata(dev);
>
> -	platform_set_drvdata(dev, NULL);
>  	rtc_device_unregister(rtc);
>
>  	puv3_rtc_setpie(&dev->dev, 0);
> --
> 1.7.2.5
>
>

