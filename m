Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaAHJCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:02:25 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36813 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaAHJCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:02:15 -0500
Date: Wed, 8 Jan 2014 09:02:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        broonie@kernel.org, robh+dt@kernel.org, lgirdwood@gmail.com,
        sameo@linux.intel.com, sbkim73@samsung.com, patches@linaro.org
Subject: Re: [PATCH 1/3] mfd: Add support for S2MPA01 device
Message-ID: <20140108090208.GD19974@lee--X1>
References: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add the necessary entries required for S2MPA01 multi-function
> device. While at it also convert whitespaces to tabs in core.h.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/sec-core.c              |   39 +++++++
>  include/linux/mfd/samsung/core.h    |   16 ++-
>  include/linux/mfd/samsung/irq.h     |   50 +++++++++
>  include/linux/mfd/samsung/s2mpa01.h |  192 +++++++++++++++++++++++++++++++++++
>  4 files changed, 292 insertions(+), 5 deletions(-)
>  create mode 100644 include/linux/mfd/samsung/s2mpa01.h
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index a139798b8065..d2e890d50a36 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -26,6 +26,7 @@
>  #include <linux/mfd/samsung/core.h>
>  #include <linux/mfd/samsung/irq.h>
>  #include <linux/mfd/samsung/rtc.h>
> +#include <linux/mfd/samsung/s2mpa01.h>
>  #include <linux/mfd/samsung/s2mps11.h>
>  #include <linux/mfd/samsung/s5m8763.h>
>  #include <linux/mfd/samsung/s5m8767.h>
> @@ -69,6 +70,13 @@ static const struct mfd_cell s2mps11_devs[] = {
>  	}
>  };
>  
> +static const struct mfd_cell s2mpa01_devs[] = {
> +	{
> +		.name = "s2mpa01-pmic",
> +	},
> +};
> +
> +

Extra '/n' here.

>  #ifdef CONFIG_OF
>  static struct of_device_id sec_dt_match[] = {
>  	{	.compatible = "samsung,s5m8767-pmic",
> @@ -77,10 +85,25 @@ static struct of_device_id sec_dt_match[] = {
>  	{	.compatible = "samsung,s2mps11-pmic",
>  		.data = (void *)S2MPS11X,
>  	},
> +	{	.compatible = "samsung,s2mpa01-pmic",
> +		.data = (void *)S2MPA01,
> +	},

Can you use the same format at the rest of the file.

I'm happy for you to fix the entire struct in this patch.

Rest of the file uses overlapping format:

        }, {
                .compatible = "samsung,s2mpa01-pmic",
        },


<snip>

> @@ -92,7 +93,7 @@ struct sec_platform_data {
>  	int				buck3_default_idx;
>  	int				buck4_default_idx;
>  
> -	int                             buck_ramp_delay;
> +	int				buck_ramp_delay;

What's this? Are you fixing (or breaking) white space here?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
