Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaE0IiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:38:13 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:41289 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaE0IiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:38:10 -0400
Date: Tue, 27 May 2014 09:38:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 4/5] mfd: palmas: Add tps65917 support
Message-ID: <20140527083804.GB5875@lee--X1>
References: <1401098197-647-1-git-send-email-j-keerthy@ti.com>
 <1401098197-647-5-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401098197-647-5-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014, Keerthy wrote:

> Add tps65917 PMIC support. tps65917 is a subset of palmas PMIC.
> Some of the register definitions and the interrupt mappings
> are different.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  drivers/mfd/palmas.c |  177 ++++++++++++++++++++++++++++++++++++++++++++++++--

Much nicer.  You just saved yourself(/the subsystem) 420 lines!

I have a single nit.  Once it's fixed-up you can apply my:

  Acked-by: Lee Jones <lee.jones@linaro.org>

>  1 file changed, 172 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> index d280d78..e4684cc 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c

[...]

>  static const struct of_device_id of_palmas_match_tbl[] = {
>  	{
>  		.compatible = "ti,palmas",
> -		.data = &palmas_features,
> +		.data = &palmas_data,
>  	},
>  	{
>  		.compatible = "ti,tps659038",
> -		.data = &tps659038_features,
> +		.data = &tps659038_data,
>  	},
> +	{
> +		.compatible = "ti,tps65917",
> +		.data = &tps65917_data,
> +	},
> +

Please get rid of this line.

>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, of_palmas_match_tbl);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
