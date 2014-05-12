Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaELH4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:56:16 -0400
Received: from mx10.pku.edu.cn ([162.105.129.173]:42373 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752685AbaELH4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:56:15 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.331
Date: Mon, 12 May 2014 15:56:03 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, a zummo <a.zummo@towertech.it>,
        sangjung woo <sangjung.woo@samsung.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Message-ID: <1432126650.17164.1399881363279.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <536479EE.4090500@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_2/2]_driver?=
 =?utf-8?Q?s/rtc/rtc-puv3.c:_remo?=
 =?utf-8?Q?ve_"&dev->"_for_typo_issue_MIME-Version:_1.0?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> It is only a typo issue, the related commit:
> 
>   "1fbc4c4 drivers/rtc/rtc-puv3.c: use dev_dbg() instead of pr_debug()"
> 
> The related error (for unicore32 with allmodconfig):
> 
>     CC [M]  drivers/rtc/rtc-puv3.o
>   drivers/rtc/rtc-puv3.c: In function ‘puv3_rtc_setalarm’:
>   drivers/rtc/rtc-puv3.c:143: error: ‘struct device’ has no member named ‘dev’
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/rtc/rtc-puv3.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
> index c56310e..1cff2a2 100644
> --- a/drivers/rtc/rtc-puv3.c
> +++ b/drivers/rtc/rtc-puv3.c
> @@ -140,7 +140,7 @@ static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
>  	rtc_tm_to_time(tm, &rtcalarm_count);
>  	writel(rtcalarm_count, RTC_RTAR);
>  
> -	puv3_rtc_setaie(&dev->dev, alrm->enabled);
> +	puv3_rtc_setaie(dev, alrm->enabled);
>  
>  	if (alrm->enabled)
>  		enable_irq_wake(puv3_rtc_alarmno);
> -- 
> 1.9.2.459.g68773ac

