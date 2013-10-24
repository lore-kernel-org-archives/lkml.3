Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3JXHaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:30:05 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58975 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3JXHaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:30:02 -0400
Message-ID: <5268DAB6.3080608@kernel.org>
Date: Thu, 24 Oct 2013 09:30:46 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH 7/8] staging: Remove OOM message after input_allocate_device
References: <cover.1382555436.git.joe@perches.com> <607933414008a7de55bcd88348d525cbec238ed1.1382555436.git.joe@perches.com>
In-Reply-To: <607933414008a7de55bcd88348d525cbec238ed1.1382555436.git.joe@perches.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/13 20:14, Joe Perches wrote:
> Emitting an OOM message isn't necessary after input_allocate_device
> as there's a generic OOM and a dump_stack already done.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
(for iio driver)

> ---
>  drivers/staging/cptm1217/clearpad_tm1217.c    | 2 --
>  drivers/staging/iio/adc/mxs-lradc.c           | 4 +---
>  drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c | 2 --
>  3 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/cptm1217/clearpad_tm1217.c
> index 42a5f5c..ca4c2c6 100644
> --- a/drivers/staging/cptm1217/clearpad_tm1217.c
> +++ b/drivers/staging/cptm1217/clearpad_tm1217.c
> @@ -457,8 +457,6 @@ static int cp_tm1217_probe(struct i2c_client *client,
>  	for (i = 0; i < TOUCH_SUPPORTED; i++) {
>  		input_dev = input_allocate_device();
>  		if (input_dev == NULL) {
> -			dev_err(ts->dev,
> -				"cp_tm1217:Input Device Struct alloc failed\n");
>  			retval = -ENOMEM;
>  			goto fail;
>  		}
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index 9da64bf..696fbb3 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -529,10 +529,8 @@ static int mxs_lradc_ts_register(struct mxs_lradc *lradc)
>  		return 0;
>  
>  	input = input_allocate_device();
> -	if (!input) {
> -		dev_err(dev, "Failed to allocate TS device!\n");
> +	if (!input)
>  		return -ENOMEM;
> -	}
>  
>  	input->name = DRIVER_NAME;
>  	input->id.bustype = BUS_HOST;
> diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> index 386362c..28b3930 100644
> --- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> +++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> @@ -911,8 +911,6 @@ static int synaptics_rmi4_probe
>  
>  	rmi4_data->input_dev = input_allocate_device();
>  	if (rmi4_data->input_dev == NULL) {
> -		dev_err(&client->dev, "%s:input device alloc failed\n",
> -						__func__);
>  		retval = -ENOMEM;
>  		goto err_input;
>  	}
> 
