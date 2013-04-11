Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3DKJxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:53:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9166 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3DKJxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:53:36 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-57-5166881e0040
Message-id: <5166881D.6000808@samsung.com>
Date: Thu, 11 Apr 2013 11:53:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: wm8994: Add device ID data to WM8994 OF device IDs
References: <1365604763-13122-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1365604763-13122-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xa7pyHWmBBn+OKFn8m32KzeLA7Ies
	Fr0LrrJZXN41h81i+dv/bBanu1ktLq74wuTA7jHvZKDH+RkLGT1eTvzN5tG3ZRWjx+dNcgGs
	UVw2Kak5mWWpRfp2CVwZve8esBT0cFXM+D6DrYFxKkcXIyeHhICJRNO06+wQtpjEhXvr2boY
	uTiEBJYySmx7tpEJwvnEKNH9/RAzSBWvgJbE/HUvgKo4OFgEVCWmvXUFCbMJGEr0Hu1jBLFF
	BQIkFi85xw5RLijxY/I9FpByEaBlv+9XgoxkFrjDKNH+9QYrSI0wUP2X1x/AbCGBUIlv53+z
	gdicAmESPxfeBpvJLKAjsb91GhuELS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVTS5MLipPS
	c430ihNzi0vz0vWS83M3MUIC/OsOxqXHrA4xCnAwKvHwnmxIDRRiTSwrrsw9xCjBwawkwsu1
	EyjEm5JYWZValB9fVJqTWnyIkYmDU6qBsWWH7vG+b5e3Nm5ds7Lsyw32i+euPe3oSn99Ynol
	rzf74/951zY8WbPRatnrSqtbUTEv+WrSzfd/1X9x9b6M2PYXOn/mpTFq5bvpH+12XBVpWP41
	3nPLorV9j8o4u8NuiO+cKhoZ1/zx7z8WqWXHZnAcuSEpwh+zQe7Yq5ArRhIL2yo2pRlu/KvE
	UpyRaKjFXFScCADTzScRTgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 04:39 PM, Mark Brown wrote:
> We can actually read this back from the device but we use this when
> registered using standard I2C board data registration so make sure
> it's there for OF too.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Untested at present.

I have tested this with wm1811 codec, together with the second patch.
The device type was set correctly.

FWIW, Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

>  drivers/mfd/wm8994-core.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
> index cdea84e..3f8d591 100644
> --- a/drivers/mfd/wm8994-core.c
> +++ b/drivers/mfd/wm8994-core.c
> @@ -673,9 +673,9 @@ static void wm8994_device_exit(struct wm8994 *wm8994)
>  }
>  
>  static const struct of_device_id wm8994_of_match[] = {
> -	{ .compatible = "wlf,wm1811", },
> -	{ .compatible = "wlf,wm8994", },
> -	{ .compatible = "wlf,wm8958", },
> +	{ .compatible = "wlf,wm1811", .data = (void *)WM1811 },
> +	{ .compatible = "wlf,wm8994", .data = (void *)WM8994 },
> +	{ .compatible = "wlf,wm8958", .data = (void *)WM8958 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(of, wm8994_of_match);

Thanks,
Sylwester
