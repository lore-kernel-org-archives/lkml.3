Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaELHxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:53:24 -0400
Received: from mx10.pku.edu.cn ([162.105.129.173]:48444 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751385AbaELHxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:53:22 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.327
Date: Mon, 12 May 2014 15:53:10 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, a zummo <a.zummo@towertech.it>,
        sangjung woo <sangjung.woo@samsung.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Message-ID: <782248460.17099.1399881190362.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <536479AD.9040104@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_1/2]_driver?=
 =?utf-8?Q?s/rtc/rtc-puv3.c:_use_d?=
 =?utf-8?Q?ev=5Fdbg()_instead_of_dev=5Fdebug()_for_typo_issue?=
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
> The related error (unicore32 with allmodconfig):
> 
>     CC [M]  drivers/rtc/rtc-puv3.o
>   drivers/rtc/rtc-puv3.c: In function ‘puv3_rtc_setpie’:
>   drivers/rtc/rtc-puv3.c:74: error: implicit declaration of function ‘dev_debug’
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/rtc/rtc-puv3.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
> index 1ecfe3b..c56310e 100644
> --- a/drivers/rtc/rtc-puv3.c
> +++ b/drivers/rtc/rtc-puv3.c
> @@ -71,7 +71,7 @@ static int puv3_rtc_setpie(struct device *dev, int enabled)
>  {
>  	unsigned int tmp;
>  
> -	dev_debug(dev, "%s: pie=%d\n", __func__, enabled);
> +	dev_dbg(dev, "%s: pie=%d\n", __func__, enabled);
>  
>  	spin_lock_irq(&puv3_rtc_pie_lock);
>  	tmp = readl(RTC_RTSR) & ~RTC_RTSR_HZE;
> -- 
> 1.9.2.459.g68773ac

