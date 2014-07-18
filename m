Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbaGRITF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:19:05 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58663 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760481AbaGRIS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:18:59 -0400
Date: Fri, 18 Jul 2014 09:18:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/24] mfd: max77686: Remove unneeded OOM error message
Message-ID: <20140718081852.GQ30888@lee--X1>
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
 <1404505467-26526-8-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404505467-26526-8-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2014, Javier Martinez Canillas wrote:

> There is no need to print out-of-memory errors since this is already
> done by the memory management subsystem which even calls dump_stack().
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/mfd/max77686.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied now, thanks.

> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 87fe52e..8650832 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c
> @@ -107,10 +107,8 @@ static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
>  	struct max77686_platform_data *pd;
>  
>  	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> -	if (!pd) {
> -		dev_err(dev, "could not allocate memory for pdata\n");
> +	if (!pd)
>  		return NULL;
> -	}
>  
>  	dev->platform_data = pd;
>  	return pd;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
