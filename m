Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3LVQzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 11:55:19 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47142 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab3LVQzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 11:55:16 -0500
Message-ID: <52B71973.1000907@kernel.org>
Date: Sun, 22 Dec 2013 16:55:15 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] iio: ti_am335x_adc: Adjust the closing bracket in
 tiadc_read_raw()
References: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de> <1387466911-3732-2-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1387466911-3732-2-git-send-email-bigeasy@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/13 15:28, Sebastian Andrzej Siewior wrote:
> It somehow looks like the ending bracket belongs to the if statement but
> it does belong to the while loop. This patch moves the bracket where it
> belongs.
> 
> Reviewed-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Jonathan Cameron <jic23@kernel.org>

Lee, I'm assuming you are fine taking the whole series!
> ---
>  drivers/iio/adc/ti_am335x_adc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index d4d7482..e948454 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -341,7 +341,7 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
>  	while (tiadc_readl(adc_dev, REG_ADCFSM) & SEQ_STATUS) {
>  		if (time_after(jiffies, timeout))
>  			return -EAGAIN;
> -		}
> +	}
>  	map_val = chan->channel + TOTAL_CHANNELS;
>  
>  	/*
> 
