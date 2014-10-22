Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbaJVLiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:38:18 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42625 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbaJVLiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:38:17 -0400
Date: Wed, 22 Oct 2014 12:38:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: max77693: Fix a truncate warning
Message-ID: <20141022113811.GL4939@x1>
References: <1413289537-10951-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413289537-10951-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2014, Krzysztof Kozlowski wrote:

> Fix warning on x86_64, make allyesconfig:
> 
> drivers/mfd/max77693.c: In function ‘max77693_i2c_probe’:
> drivers/mfd/max77693.c:259:5: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>      SRC_IRQ_ALL, ~SRC_IRQ_ALL);
>      ^

Applied and fixed up into:

  mfd: max77693: Fix always masked MUIC interrupts

Thanks.

> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/max77693.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 4e4e6a1a6301..0c9ec6bae022 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -256,7 +256,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  	/* Unmask interrupts from all blocks in interrupt source register */
>  	ret = regmap_update_bits(max77693->regmap,
>  				MAX77693_PMIC_REG_INTSRC_MASK,
> -				SRC_IRQ_ALL, ~SRC_IRQ_ALL);
> +				SRC_IRQ_ALL, (unsigned int)~SRC_IRQ_ALL);
>  	if (ret < 0) {
>  		dev_err(max77693->dev,
>  			"Could not unmask interrupts in INTSRC: %d\n",

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
