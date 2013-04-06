Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3DFKGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 06:06:34 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:52096 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162Ab3DFKGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 06:06:33 -0400
Message-ID: <515FF438.6090305@metafoo.de>
Date: Sat, 06 Apr 2013 12:08:56 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>,
        Joe Perches <joe@perches.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] staging/adt7316 Fix some 'interesting' string operations
References: <515df29417437372eb@agluck-desk.sc.intel.com>
In-Reply-To: <515df29417437372eb@agluck-desk.sc.intel.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 11:37 PM, Luck, Tony wrote:
> Calling memcmp() to check the value of the first byte in a string is overkill.
> Just use buf[0] == '1' or buf[0] != '1' as appropriate.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 

I think it is a good idea to switch directly to strtobool. But anyway, if you
don't want to respin the patch it is fine as it is.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
> 
> [Inspired by a rant on IRC about a different driver doing something similar]
> 
> diff --git a/drivers/staging/iio/addac/adt7316.c b/drivers/staging/iio/addac/adt7316.c
> index 0b431bc..506b5a7 100644
> --- a/drivers/staging/iio/addac/adt7316.c
> +++ b/drivers/staging/iio/addac/adt7316.c
> @@ -256,7 +256,7 @@ static ssize_t adt7316_store_enabled(struct device *dev,
>  	struct adt7316_chip_info *chip = iio_priv(dev_info);
>  	int enable;
>  
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		enable = 1;
>  	else
>  		enable = 0;
> @@ -299,7 +299,7 @@ static ssize_t adt7316_store_select_ex_temp(struct device *dev,
>  		return -EPERM;
>  
>  	config1 = chip->config1 & (~ADT7516_SEL_EX_TEMP);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		config1 |= ADT7516_SEL_EX_TEMP;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG1, config1);
> @@ -495,7 +495,7 @@ static ssize_t adt7316_store_disable_averaging(struct device *dev,
>  	int ret;
>  
>  	config2 = chip->config2 & (~ADT7316_DISABLE_AVERAGING);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		config2 |= ADT7316_DISABLE_AVERAGING;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG2, config2);
> @@ -534,7 +534,7 @@ static ssize_t adt7316_store_enable_smbus_timeout(struct device *dev,
>  	int ret;
>  
>  	config2 = chip->config2 & (~ADT7316_EN_SMBUS_TIMEOUT);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		config2 |= ADT7316_EN_SMBUS_TIMEOUT;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG2, config2);
> @@ -597,7 +597,7 @@ static ssize_t adt7316_store_powerdown(struct device *dev,
>  	int ret;
>  
>  	config1 = chip->config1 & (~ADT7316_PD);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		config1 |= ADT7316_PD;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG1, config1);
> @@ -635,7 +635,7 @@ static ssize_t adt7316_store_fast_ad_clock(struct device *dev,
>  	int ret;
>  
>  	config3 = chip->config3 & (~ADT7316_ADCLK_22_5);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		config3 |= ADT7316_ADCLK_22_5;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG3, config3);
> @@ -681,7 +681,7 @@ static ssize_t adt7316_store_da_high_resolution(struct device *dev,
>  
>  	chip->dac_bits = 8;
>  
> -	if (!memcmp(buf, "1", 1)) {
> +	if (buf[0] == '1') {
>  		config3 = chip->config3 | ADT7316_DA_HIGH_RESOLUTION;
>  		if (chip->id == ID_ADT7316 || chip->id == ID_ADT7516)
>  			chip->dac_bits = 12;
> @@ -731,7 +731,7 @@ static ssize_t adt7316_store_AIN_internal_Vref(struct device *dev,
>  	if ((chip->id & ID_FAMILY_MASK) != ID_ADT75XX)
>  		return -EPERM;
>  
> -	if (memcmp(buf, "1", 1))
> +	if (buf[0] != '1')
>  		config3 = chip->config3 & (~ADT7516_AIN_IN_VREF);
>  	else
>  		config3 = chip->config3 | ADT7516_AIN_IN_VREF;
> @@ -773,7 +773,7 @@ static ssize_t adt7316_store_enable_prop_DACA(struct device *dev,
>  	int ret;
>  
>  	config3 = chip->config3 & (~ADT7316_EN_IN_TEMP_PROP_DACA);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		config3 |= ADT7316_EN_IN_TEMP_PROP_DACA;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG3, config3);
> @@ -812,7 +812,7 @@ static ssize_t adt7316_store_enable_prop_DACB(struct device *dev,
>  	int ret;
>  
>  	config3 = chip->config3 & (~ADT7316_EN_EX_TEMP_PROP_DACB);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		config3 |= ADT7316_EN_EX_TEMP_PROP_DACB;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG3, config3);
> @@ -1018,7 +1018,7 @@ static ssize_t adt7316_store_DA_AB_Vref_bypass(struct device *dev,
>  		return -EPERM;
>  
>  	dac_config = chip->dac_config & (~ADT7316_VREF_BYPASS_DAC_AB);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		dac_config |= ADT7316_VREF_BYPASS_DAC_AB;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_DAC_CONFIG, dac_config);
> @@ -1063,7 +1063,7 @@ static ssize_t adt7316_store_DA_CD_Vref_bypass(struct device *dev,
>  		return -EPERM;
>  
>  	dac_config = chip->dac_config & (~ADT7316_VREF_BYPASS_DAC_CD);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		dac_config |= ADT7316_VREF_BYPASS_DAC_CD;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_DAC_CONFIG, dac_config);
> @@ -1982,7 +1982,7 @@ static ssize_t adt7316_set_int_enabled(struct device *dev,
>  	int ret;
>  
>  	config1 = chip->config1 & (~ADT7316_INT_EN);
> -	if (!memcmp(buf, "1", 1))
> +	if (buf[0] == '1')
>  		config1 |= ADT7316_INT_EN;
>  
>  	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG1, config1);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

