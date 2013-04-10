Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934947Ab3DJJud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:50:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42950 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3DJJub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:50:31 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-1f-516535e60597
Message-id: <516535E4.5060308@samsung.com>
Date: Wed, 10 Apr 2013 11:50:28 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, a.zummo@towertech.it,
        kgene.kim@samsung.com, thomas.ab@samsung.com, dianders@chromium.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH] rtc: rtc-s3c: use clk_prepare_enable and
 clk_disable_unprepare
References: <1365517660-9322-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1365517660-9322-1-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xq7rPTFMDDR5cZ7ZYcvEqu8XZZQfZ
	LNquHGS36F1wlc3i8q45bBYzzu9jstjf2cFo0bGM0eLYjCWMDpwesxsusnjsmXiSzePOtT1s
	Hn1bVjF6TJ/3k8nj8ya5ALYoLpuU1JzMstQifbsEroyTDZ9ZCm7xViz9e4O9gfEnVxcjJ4eE
	gIlEb8drJghbTOLCvfVsXYxcHEICSxklbnWsYIVwPjFKLH47lb2LkYODV0BL4mErN0gDi4Cq
	xOkbH1hBbDYBQ4neo32MILaoQIDE4iXn2EFsXgFBiR+T77GA2CIC2hLb504Cm8ks8IZR4nzT
	MrBmYYFQiX2/jzCD2EIC7hIX/u8Fa+AU8JDYcGcT2FBmAR2J/a3T2CBseYnNa94yT2AUmIVk
	xywkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERIDX3cwLj1mdYhRgINRiYd3
	gWFKoBBrYllxZe4hRgkOZiURXgut1EAh3pTEyqrUovz4otKc1OJDjEwcnFINjIoSOjbXzP7e
	0Zh3eXbJ8qIitcvvmM6yn3q5tJiniPn9hKVMkW5C908VMU5LzM2d9cZoza6nmlG7DvneNg+b
	kXP17jPbuM1qzbdXP+697rXKu7umq/nMk3PfdnnfC3quZrvveWDW15mlgtbcyu27Nk9W1Ljj
	L5ggGHDoZiAj2wPZ1R+kLTi2X1ViKc5INNRiLipOBADruhwEXwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 04:27 PM, Vivek Gautam wrote:
> From: Thomas Abraham <thomas.abraham@linaro.org>
> 
> Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
> calls as required by common clock framework.
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Thanks Vivek.

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
> 
> The v1 of this patch is pretty old, but the change needs to be merged to
> avoid getting those needless WARN_ON() dumps on console.
> 
> Changes from v1:
>  - Not using clk_disable_unprepare() at the end of s3c_rtc_probe(), since
>    this will unprepare the rtc clock which is again getting used in other
>    funtions later.
>  - Using clk_unprepare() at the remove() instead to fix things up.
> 
>  drivers/rtc/rtc-s3c.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
> index fb994e9..e3528c9 100644
> --- a/drivers/rtc/rtc-s3c.c
> +++ b/drivers/rtc/rtc-s3c.c
> @@ -430,6 +430,7 @@ static int s3c_rtc_remove(struct platform_device *dev)
>  
>  	s3c_rtc_setaie(&dev->dev, 0);
>  
> +	clk_unprepare(rtc_clk);
>  	rtc_clk = NULL;
>  
>  	return 0;
> @@ -498,7 +499,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> -	clk_enable(rtc_clk);
> +	clk_prepare_enable(rtc_clk);
>  
>  	/* check to see if everything is setup correctly */
>  
> @@ -578,7 +579,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
>  
>   err_nortc:
>  	s3c_rtc_enable(pdev, 0);
> -	clk_disable(rtc_clk);
> +	clk_disable_unprepare(rtc_clk);
>  
>  	return ret;
>  }

