Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaHUPjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:39:44 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:44882 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaHUPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:39:42 -0400
Date: Thu, 21 Aug 2014 16:39:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, David Dajun Chen <dchen@diasemi.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: da9052-i2c: Remove duplicate test for
 I2C_FUNC_SMBUS_BYTE_DATA functionality
Message-ID: <20140821153936.GP4266@lee--X1>
References: <1408110797.6965.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408110797.6965.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2014, Axel Lin wrote:

> Since commit b42261078a91 ("regmap: i2c: fallback to SMBus if the adapter
> does not support standard I2C"), regmap-i2c will check the
> I2C_FUNC_SMBUS_[BYTE|WORD]_DATA functionality based on the regmap_config
> setting if the adapter does not support standard I2C.
> 
> So remove the I2C_FUNC_SMBUS_BYTE_DATA functionality check in the driver code.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/da9052-i2c.c | 7 -------
>  1 file changed, 7 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
> index 6da8ec8..ec39287 100644
> --- a/drivers/mfd/da9052-i2c.c
> +++ b/drivers/mfd/da9052-i2c.c
> @@ -140,13 +140,6 @@ static int da9052_i2c_probe(struct i2c_client *client,
>  	if (!da9052)
>  		return -ENOMEM;
>  
> -	if (!i2c_check_functionality(client->adapter,
> -				     I2C_FUNC_SMBUS_BYTE_DATA)) {
> -		dev_info(&client->dev, "Error in %s:i2c_check_functionality\n",
> -			 __func__);
> -		return  -ENODEV;
> -	}
> -
>  	da9052->dev = &client->dev;
>  	da9052->chip_irq = client->irq;
>  	da9052->fix_io = da9052_i2c_fix;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
