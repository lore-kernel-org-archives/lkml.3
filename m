Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaG3NSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:18:11 -0400
Received: from mail1.windriver.com ([147.11.146.13]:56509 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaG3NSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:18:09 -0400
Message-ID: <53D8F0A1.3000800@windriver.com>
Date: Wed, 30 Jul 2014 09:18:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Input: jornada720_ts: Switch to using Managed resources
References: <1406722183-22678-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1406722183-22678-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-07-30 08:09 AM, Pramod Gurav wrote:
> This switches the driver to using managed resources to simplify
> error handling and to do away with remove function.
> 
> Also fixes some indentations by replacing spaces with tabs.
> 
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> CC: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/input/touchscreen/jornada720_ts.c |   62 ++++++++++-------------------
>  1 file changed, 20 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
> index 7324c5c..0c23bba 100644
> --- a/drivers/input/touchscreen/jornada720_ts.c
> +++ b/drivers/input/touchscreen/jornada720_ts.c
> @@ -37,21 +37,21 @@ struct jornada_ts {
>  static void jornada720_ts_collect_data(struct jornada_ts *jornada_ts)
>  {
>  
> -    /* 3 low word X samples */
> -    jornada_ts->x_data[0] = jornada_ssp_byte(TXDUMMY);
> -    jornada_ts->x_data[1] = jornada_ssp_byte(TXDUMMY);
> -    jornada_ts->x_data[2] = jornada_ssp_byte(TXDUMMY);
> +	/* 3 low word X samples */
> +	jornada_ts->x_data[0] = jornada_ssp_byte(TXDUMMY);
> +	jornada_ts->x_data[1] = jornada_ssp_byte(TXDUMMY);
> +	jornada_ts->x_data[2] = jornada_ssp_byte(TXDUMMY);

Please don't mix pure whitespace changes with technical changes.
While I can't fault you for wanting to get rid of the 4 space
tabs, it makes review more complicated when they are mixed in
a single commit.

P.
--

>  
> -    /* 3 low word Y samples */
> -    jornada_ts->y_data[0] = jornada_ssp_byte(TXDUMMY);
> -    jornada_ts->y_data[1] = jornada_ssp_byte(TXDUMMY);
> -    jornada_ts->y_data[2] = jornada_ssp_byte(TXDUMMY);
> +	/* 3 low word Y samples */
> +	jornada_ts->y_data[0] = jornada_ssp_byte(TXDUMMY);
> +	jornada_ts->y_data[1] = jornada_ssp_byte(TXDUMMY);
> +	jornada_ts->y_data[2] = jornada_ssp_byte(TXDUMMY);
>  
> -    /* combined x samples bits */
> -    jornada_ts->x_data[3] = jornada_ssp_byte(TXDUMMY);
> +	/* combined x samples bits */
> +	jornada_ts->x_data[3] = jornada_ssp_byte(TXDUMMY);
>  
> -    /* combined y samples bits */
> -    jornada_ts->y_data[3] = jornada_ssp_byte(TXDUMMY);
> +	/* combined y samples bits */
> +	jornada_ts->y_data[3] = jornada_ssp_byte(TXDUMMY);
>  }
>  
>  static int jornada720_ts_average(int coords[4])
> @@ -104,13 +104,10 @@ static int jornada720_ts_probe(struct platform_device *pdev)
>  	struct input_dev *input_dev;
>  	int error;
>  
> -	jornada_ts = kzalloc(sizeof(struct jornada_ts), GFP_KERNEL);
> -	input_dev = input_allocate_device();
> -
> -	if (!jornada_ts || !input_dev) {
> -		error = -ENOMEM;
> -		goto fail1;
> -	}
> +	jornada_ts = devm_kzalloc(&pdev->dev, sizeof(*jornada_ts), GFP_KERNEL);
> +	input_dev = devm_input_allocate_device(&pdev->dev);
> +	if (!jornada_ts || !input_dev)
> +		return -ENOMEM;
>  
>  	platform_set_drvdata(pdev, jornada_ts);
>  
> @@ -126,36 +123,18 @@ static int jornada720_ts_probe(struct platform_device *pdev)
>  	input_set_abs_params(input_dev, ABS_X, 270, 3900, 0, 0);
>  	input_set_abs_params(input_dev, ABS_Y, 180, 3700, 0, 0);
>  
> -	error = request_irq(IRQ_GPIO9,
> +	error = devm_request_irq(&pdev->dev, IRQ_GPIO9,
>  			jornada720_ts_interrupt,
>  			IRQF_TRIGGER_RISING,
>  			"HP7XX Touchscreen driver", pdev);
>  	if (error) {
> -		printk(KERN_INFO "HP7XX TS : Unable to acquire irq!\n");
> -		goto fail1;
> +		dev_err(&pdev->dev, "HP7XX TS : Unable to acquire irq!\n");
> +		return error;
>  	}
>  
>  	error = input_register_device(jornada_ts->dev);
>  	if (error)
> -		goto fail2;
> -
> -	return 0;
> -
> - fail2:
> -	free_irq(IRQ_GPIO9, pdev);
> - fail1:
> -	input_free_device(input_dev);
> -	kfree(jornada_ts);
> -	return error;
> -}
> -
> -static int jornada720_ts_remove(struct platform_device *pdev)
> -{
> -	struct jornada_ts *jornada_ts = platform_get_drvdata(pdev);
> -
> -	free_irq(IRQ_GPIO9, pdev);
> -	input_unregister_device(jornada_ts->dev);
> -	kfree(jornada_ts);
> +		return error;
>  
>  	return 0;
>  }
> @@ -165,7 +144,6 @@ MODULE_ALIAS("platform:jornada_ts");
>  
>  static struct platform_driver jornada720_ts_driver = {
>  	.probe		= jornada720_ts_probe,
> -	.remove		= jornada720_ts_remove,
>  	.driver		= {
>  		.name	= "jornada_ts",
>  		.owner	= THIS_MODULE,
> 
