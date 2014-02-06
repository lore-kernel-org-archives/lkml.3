Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbaBFJPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:15:25 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:56752 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaBFJPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:15:21 -0500
X-Auth-Info: BGutzzvfoN0YJRbQi5bT2O7jyC7+nPq+z/20P5wUsdo=
Message-ID: <52F352A4.7090500@denx.de>
Date: Thu, 06 Feb 2014 10:15:16 +0100
From: Stefano Babic <sbabic@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "'Stefano Babic'" <sbabic@denx.de>,
        "'Anatolij Gustschin'" <agust@denx.de>
Subject: Re: [PATCH 06/12] backlight: ili922x: Remove unnecessary OOM messages
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com> <000701cf2314$78459d60$68d0d820$%han@samsung.com>
In-Reply-To: <000701cf2314$78459d60$68d0d820$%han@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On 06/02/2014 09:21, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/ili922x.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
> index 73464e4..ea67fe1 100644
> --- a/drivers/video/backlight/ili922x.c
> +++ b/drivers/video/backlight/ili922x.c
> @@ -482,10 +482,8 @@ static int ili922x_probe(struct spi_device *spi)
>  	u16 reg = 0;
>  
>  	ili = devm_kzalloc(&spi->dev, sizeof(*ili), GFP_KERNEL);
> -	if (!ili) {
> -		dev_err(&spi->dev, "cannot alloc priv data\n");
> +	if (!ili)
>  		return -ENOMEM;
> -	}
>  
>  	ili->spi = spi;
>  	spi_set_drvdata(spi, ili);
> 

Acked-by: Stefano Babic <sbabic@denx.de>

Thanks !

Best regards,
Stefano Babic

-- 
=====================================================================
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-53 Fax: +49-8142-66989-80 Email: sbabic@denx.de
=====================================================================
