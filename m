Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaBGIEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:04:22 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:34634 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaBGIEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:04:21 -0500
Date: Fri, 7 Feb 2014 09:04:16 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 01/10] rtc: rtc-at32ap700x: Remove unnecessary OOM
 messages
Message-ID: <20140207080416.GB18935@samfundet.no>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
 <000a01cf23da$e2b2e010$a818a030$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01cf23da$e2b2e010$a818a030$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 07 Feb 2014 17:02:02 +0900 or thereabout, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.

Thanks for cleaning up.

> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  drivers/rtc/rtc-at32ap700x.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
> index 3161ab5..aee3387 100644
> --- a/drivers/rtc/rtc-at32ap700x.c
> +++ b/drivers/rtc/rtc-at32ap700x.c
> @@ -204,10 +204,8 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
>  
>  	rtc = devm_kzalloc(&pdev->dev, sizeof(struct rtc_at32ap700x),
>  			   GFP_KERNEL);
> -	if (!rtc) {
> -		dev_dbg(&pdev->dev, "out of memory\n");
> +	if (!rtc)
>  		return -ENOMEM;
> -	}
>  
>  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!regs) {
-- 
mvh
Hans-Christian Egtvedt
