Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaFXKOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:14:20 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41208 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaFXKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:14:18 -0400
Date: Tue, 24 Jun 2014 11:14:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Add comment to explain non-devm
 regulator_get
Message-ID: <20140624101413.GF13803@lee--X1>
References: <1403190263-32737-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403190263-32737-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To avoid someone attempting to change this regulator_get back into a
> devm_regulator_get put a comment in explaining that devres can't be used
> here as the regulator will be destroyed before devres calls
> regulator_put.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 27936fe..b4f22e7 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -683,6 +683,12 @@ int arizona_dev_init(struct arizona *arizona)
>  		goto err_early;
>  	}
>  
> +	/**
> +	 * Don't use devres here because the only device we have to get
> +	 * against is the MFD device and DCVDD will likely be supplied by
> +	 * one of its children. Meaning that the regulator will be
> +	 * destroyed by the time devres calls regulator put.
> +	 */
>  	arizona->dcvdd = regulator_get(arizona->dev, "DCVDD");
>  	if (IS_ERR(arizona->dcvdd)) {
>  		ret = PTR_ERR(arizona->dcvdd);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
