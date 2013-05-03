Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab3ECK0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:26:39 -0400
Received: from smtp-out-053.synserver.de ([212.40.185.53]:1045 "EHLO
	smtp-out-053.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3ECK0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:26:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6035
Message-ID: <51838F2B.5020402@metafoo.de>
Date: Fri, 03 May 2013 12:19:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 03/42] rtc: rtc-ab3100: remove unnecessary platform_set_drvdata()
References: <001101ce47c6$9ca9e640$d5fdb2c0$@samsung.com>
In-Reply-To: <001101ce47c6$9ca9e640$d5fdb2c0$@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 08:22 AM, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-ab3100.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
> index 47a4f2c..572208d 100644
> --- a/drivers/rtc/rtc-ab3100.c
> +++ b/drivers/rtc/rtc-ab3100.c
> @@ -242,7 +242,6 @@ static int __init ab3100_rtc_probe(struct platform_device *pdev)
>  
>  static int __exit ab3100_rtc_remove(struct platform_device *pdev)
>  {
> -	platform_set_drvdata(pdev, NULL);
>  	return 0;
>  }

Since it's empty you can remove the function altogether.

Same comment for all the other patches in this series where the function
ends up being empty

