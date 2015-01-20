Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbbATL5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:57:36 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60501 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbbATL5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:57:31 -0500
Date: Tue, 20 Jan 2015 11:57:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] mfd: max77686: Constify struct regmap_config
Message-ID: <20150120115726.GQ13701@x1>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
 <1420448493-9355-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420448493-9355-6-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:

> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/max77686.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 929795eae9fc..2b2f2ccda523 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c
> @@ -111,17 +111,17 @@ static bool max77802_is_volatile_reg(struct device *dev, unsigned int reg)
>  		max77802_rtc_is_volatile_reg(dev, reg));
>  }
>  
> -static struct regmap_config max77686_regmap_config = {
> +static const struct regmap_config max77686_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  };
>  
> -static struct regmap_config max77686_rtc_regmap_config = {
> +static const struct regmap_config max77686_rtc_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  };
>  
> -static struct regmap_config max77802_regmap_config = {
> +static const struct regmap_config max77802_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  	.writeable_reg = max77802_is_accessible_reg,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
