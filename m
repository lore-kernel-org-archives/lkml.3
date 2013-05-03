Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762569Ab3ECH1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 03:27:13 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:58678 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383Ab3ECH1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 03:27:12 -0400
Message-ID: <518366D3.4070009@prisktech.co.nz>
Date: Fri, 03 May 2013 19:27:15 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 38/42] rtc: rtc-vt8500: remove unnecessary platform_set_drvdata()
References: <003401ce47c8$cf834140$6e89c3c0$@samsung.com>
In-Reply-To: <003401ce47c8$cf834140$6e89c3c0$@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/13 18:38, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>   drivers/rtc/rtc-vt8500.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
> index d89efee..c2d6331 100644
> --- a/drivers/rtc/rtc-vt8500.c
> +++ b/drivers/rtc/rtc-vt8500.c
> @@ -282,8 +282,6 @@ static int vt8500_rtc_remove(struct platform_device *pdev)
>   	/* Disable alarm matching */
>   	writel(0, vt8500_rtc->regbase + VT8500_RTC_IS);
>   
> -	platform_set_drvdata(pdev, NULL);
> -
>   	return 0;
>   }
>   
Acked-by: Tony Prisk <linux@prisktech.co.nz>
