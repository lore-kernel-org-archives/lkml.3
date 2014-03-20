Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbaCTIkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:40:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48231 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaCTIkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:40:18 -0400
Message-ID: <532AA946.5000002@ti.com>
Date: Thu, 20 Mar 2014 14:09:34 +0530
From: Archit Taneja <archit@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l: ti-vpe: fix devm_ioremap_resource() return value
 checking
References: <2203316.gzhRfbGDkb@amdc1032>
In-Reply-To: <2203316.gzhRfbGDkb@amdc1032>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.145.166]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 18 March 2014 04:11 PM, Bartlomiej Zolnierkiewicz wrote:
> devm_ioremap_resource() returns a pointer to the remapped memory or
> an ERR_PTR() encoded error code on failure.  Fix the checks inside
> csc_create() and sc_create() accordingly.
>
> Cc: Archit Taneja <archit@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> Compile tested only.

Thanks for the patch.

It looks like this wasn't patch created using git-format-patch. I can 
convert it if needed.

Tested-by: Archit Taneja<archit@ti.com>

Thanks,
Archit

>
>   drivers/media/platform/ti-vpe/csc.c |    4 ++--
>   drivers/media/platform/ti-vpe/sc.c  |    4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
>
> Index: b/drivers/media/platform/ti-vpe/csc.c
> ===================================================================
> --- a/drivers/media/platform/ti-vpe/csc.c	2014-03-14 16:45:25.848724010 +0100
> +++ b/drivers/media/platform/ti-vpe/csc.c	2014-03-18 11:01:36.595182833 +0100
> @@ -187,9 +187,9 @@ struct csc_data *csc_create(struct platf
>   	}
>
>   	csc->base = devm_ioremap_resource(&pdev->dev, csc->res);
> -	if (!csc->base) {
> +	if (IS_ERR(csc->base)) {
>   		dev_err(&pdev->dev, "failed to ioremap\n");
> -		return ERR_PTR(-ENOMEM);
> +		return csc->base;
>   	}
>
>   	return csc;
> Index: b/drivers/media/platform/ti-vpe/sc.c
> ===================================================================
> --- a/drivers/media/platform/ti-vpe/sc.c	2014-03-14 16:45:25.848724010 +0100
> +++ b/drivers/media/platform/ti-vpe/sc.c	2014-03-18 11:02:09.555182273 +0100
> @@ -302,9 +302,9 @@ struct sc_data *sc_create(struct platfor
>   	}
>
>   	sc->base = devm_ioremap_resource(&pdev->dev, sc->res);
> -	if (!sc->base) {
> +	if (IS_ERR(sc->base)) {
>   		dev_err(&pdev->dev, "failed to ioremap\n");
> -		return ERR_PTR(-ENOMEM);
> +		return sc->base;
>   	}
>
>   	return sc;
>

