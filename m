Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaJQIFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:05:12 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:63383 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaJQIEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:04:44 -0400
Date: Fri, 17 Oct 2014 10:04:38 +0200
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/7] regulator: max77802: Add header for operating
 modes
Message-ID: <20141017080438.GE22725@lee--X1>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413478133-2577-5-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413478133-2577-5-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014, Javier Martinez Canillas wrote:

> Add a header file for the max77802 constants that could be shared between
> the regulator driver and Device Tree source files. Also, remove standby
> and off opmodes since only normal and low power are valid operating modes.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
> Changes since v1: None
> 
>  drivers/regulator/max77802.c                   |  1 +
>  include/dt-bindings/regulator/maxim,max77802.h | 18 ++++++++++++++++++
>  include/linux/mfd/max77686.h                   |  7 -------

Acked-by: Lee Jones <lee.jones@linaro.org>

>  3 files changed, 19 insertions(+), 7 deletions(-)
>  create mode 100644 include/dt-bindings/regulator/maxim,max77802.h
> 
> diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
> index 3abf99d..5839c45 100644
> --- a/drivers/regulator/max77802.c
> +++ b/drivers/regulator/max77802.c
> @@ -33,6 +33,7 @@
>  #include <linux/regulator/of_regulator.h>
>  #include <linux/mfd/max77686.h>
>  #include <linux/mfd/max77686-private.h>
> +#include <dt-bindings/regulator/maxim,max77802.h>
>  
>  /* Default ramp delay in case it is not manually set */
>  #define MAX77802_RAMP_DELAY		100000		/* uV/us */
> diff --git a/include/dt-bindings/regulator/maxim,max77802.h b/include/dt-bindings/regulator/maxim,max77802.h
> new file mode 100644
> index 0000000..cf28631
> --- /dev/null
> +++ b/include/dt-bindings/regulator/maxim,max77802.h
> @@ -0,0 +1,18 @@
> +/*
> + * Copyright (C) 2014 Google, Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Device Tree binding constants for the Maxim 77802 PMIC regulators
> + */
> +
> +#ifndef _DT_BINDINGS_REGULATOR_MAXIM_MAX77802_H
> +#define _DT_BINDINGS_REGULATOR_MAXIM_MAX77802_H
> +
> +/* Regulator operating modes */
> +#define MAX77802_OPMODE_LP	1
> +#define MAX77802_OPMODE_NORMAL	3
> +
> +#endif /* _DT_BINDINGS_REGULATOR_MAXIM_MAX77802_H */
> diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
> index 7e6dc4b..553f7d0 100644
> --- a/include/linux/mfd/max77686.h
> +++ b/include/linux/mfd/max77686.h
> @@ -131,13 +131,6 @@ enum max77686_opmode {
>  	MAX77686_OPMODE_STANDBY,
>  };
>  
> -enum max77802_opmode {
> -	MAX77802_OPMODE_OFF,
> -	MAX77802_OPMODE_STANDBY,
> -	MAX77802_OPMODE_LP,
> -	MAX77802_OPMODE_NORMAL,
> -};
> -
>  struct max77686_opmode_data {
>  	int id;
>  	int mode;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
