Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3C0MZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:25:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39647 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3C0MZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:25:21 -0400
X-AuditID: cbfee68d-b7f786d000005188-a3-5152e52ea057
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Grant Grundler'" <grundler@chromium.org>,
        "'Chris Ball'" <cjb@laptop.org>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Will Newton'" <will.newton@gmail.com>,
        "'Bing Zhao'" <bzhao@marvell.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Ashok Nagarajan'" <asnagarajan@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1364338202-10311-1-git-send-email-grundler@chromium.org>
In-reply-to: <1364338202-10311-1-git-send-email-grundler@chromium.org>
Subject: RE: [PATCH] mmc: dw_mmc: rewrite CLKDIV computation
Date: Wed, 27 Mar 2013 21:25:18 +0900
Message-id: <000b01ce2ae6$249bfb90$6dd3f2b0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4qdFdTDaSpwt/5TjOmV8Vch3dsDgAKVP6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zA129p0GBBndWaltsXhdvMW/rUVaL
	7a83slmcXXaQzeLVkR9MFjd+tbFaXN41h83iyP9+RotT1z+zWSzcdIjNgctjdsNFFo+ds+6y
	exy6spbR48qJJlaPyQsvMnv0bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXxrl/u1kKNglXrH76
	iqmBsZe/i5GTQ0LARGLujv1MELaYxIV769m6GLk4hASWMUpcW/KUCabo7oNTYLaQwCJGiab1
	dRBFfxglVjyYxg6SYBPQkvj75g0ziC0i4C1xau1VJpAiZoGNTBLXGi4zdjFyAHW4SvSv4gSp
	4RRwk1h0ZCcLiC0sYCPxelozmM0ioCqxbc4yMJtXwFbi8d7fjBC2oMSPyffA4swCBhLvZ/Wx
	QtjyEpvXvGUGGS8hoC7x6K8uiCkiYCRxtUcaokJEYt+Ld4wg10gITOWQ6Dq9nAlilYDEt8mH
	WCBaZSU2HWCGeFdS4uCKGywTGCVmIVk8C8niWUgWz0KyYgEjyypG0dSC5ILipPQiQ73ixNzi
	0rx0veT83E2MkFjv3cF4+4D1IcZkoPUTmaVEk/OBqSKvJN7Q2MzIwtTE1NjI3NKMNGElcV61
	FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxTd0SEfHB/OMOT+cD8mxwGLj8uPFbo7tab
	qnO8xe0b887aS79Wm0X5qG9bLX6C24054OOLvZZe6WpNmdtrJwsxPbCdcPRN8c57rotSfD89
	mqp1Yx6/0ebT0im8OUsO2PLwNZ6JYO7YKLnohqZ5VZ9250WVni4vSb8up0fJ+RUcv2xL/547
	clGJpTgj0VCLuag4EQDUJqD/CwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAV29p0GBBhP/q1psXhdvMW/rUVaL
	7a83slmcXXaQzeLVkR9MFjd+tbFaXN41h83iyP9+RotT1z+zWSzcdIjNgctjdsNFFo+ds+6y
	exy6spbR48qJJlaPyQsvMnv0bVnF6PF5k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8
	qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0H1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMI6xoxz/3azFGwSrlj99BVTA2MvfxcjJ4eEgInE3QenmCBsMYkL99azgdhCAosY
	JZrW13UxcgHZfxglVjyYxg6SYBPQkvj75g0ziC0i4C1xau1VJpAiZoGNTBLXGi4zdjFyAHW4
	SvSv4gSp4RRwk1h0ZCcLiC0sYCPxelozmM0ioCqxbc4yMJtXwFbi8d7fjBC2oMSPyffA4swC
	BhLvZ/WxQtjyEpvXvGUGGS8hoC7x6K8uiCkiYCRxtUcaokJEYt+Ld4wTGIVmIRk0C8mgWUgG
	zULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCJ5Jr2DcVWDxSFGAQ5GJR5eh3+B
	gUKsiWXFlbmHGCU4mJVEeIMeBgUK8aYkVlalFuXHF5XmpBYfYkwG+nMis5Rocj4wyeWVxBsa
	m5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6OyV6moivfD64dWfkv+
	p12c9KdaZXdgh4sSm+Jpo2s+LeFSqdNqnKLWB39cy8lU/TPnH8/UnVHvZsmW5K/zmXX4GLdb
	25tkDp4XT06ycy+4vZ3HS0/i8YklCxJYp177bMtx4mn8sbizCxTZ6i9WLPx3OmPFp0nHa45d
	LFu5RWLdR9nky7sPbn6mxFKckWioxVxUnAgAqfN7wmgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 27, 2013, Grant Grundler wrote:
> Last year Seungwon Jeon (Samsung) fixed a bug in CLKDIV computation.
For easily identifying, it would be good to point the commit id and subject.
> But when debugging a related issue (http://crbug.com/221828) I found
It is not easy to catch up issue in your site. What problem is bothering you?
Could you describe the problem and conditions you have found?

Thanks,
Seungwon Jeon

> the code unreadable.  This rewrite simplifies the computation and
> explains each step.
> 
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> ---
> Tested on Samsung Series 3 Chromebook (exynos 5250 chipset) using
> ChromeOS 3.4 kernel (not 3.9-rc3 which this patch is based against).
> 
> I've written a test program to confirm this patch generates the
> same correct values and will share that separately.
> 
>  drivers/mmc/host/dw_mmc.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 9834221..6fdf55b 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -631,14 +631,22 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
> 
>  	if (slot->clock != host->current_speed || force_clkinit) {
>  		div = host->bus_hz / slot->clock;
> -		if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
> -			/*
> -			 * move the + 1 after the divide to prevent
> -			 * over-clocking the card.
> +		if (host->bus_hz > slot->clock) {
> +			/* don't overclock due to integer math losses */
> +			if ((div * slot->clock) < host->bus_hz)
> +				div++;
> +
> +			/* don't overclock due to resolution of HW */
> +			if (div & 1)
> +				div++;
> +
> +			/* See 6.2.3 CLKDIV in "Mobile Storage Host Databook"
> +			 * Look for dwc_mobile_storage_db.pdf from Synopsys.
> +			 * CLKDIV value 0 means divisor 1, val 1 -> 2, ...
>  			 */
> -			div += 1;
> -
> -		div = (host->bus_hz != slot->clock) ? DIV_ROUND_UP(div, 2) : 0;
> +			div /= 2;
> +		} else
> +			div = 0;        /* use bus_hz */
> 
>  		dev_info(&slot->mmc->class_dev,
>  			 "Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ"
> --
> 1.8.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

