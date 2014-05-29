Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbaE2MCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:02:10 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33177 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbaE2MCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:02:08 -0400
Date: Thu, 29 May 2014 13:02:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: menelaus: Use module_i2c_driver
Message-ID: <20140529120202.GL1954@lee--X1>
References: <1401363802-18961-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401363802-18961-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> module_i2c_driver simplifies the code by eliminating
> boilerplate code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/menelaus.c |   23 +----------------------
>  1 file changed, 1 insertion(+), 22 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index ad25bfa3fb02..5e2667afe2bc 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -1287,29 +1287,8 @@ static struct i2c_driver menelaus_i2c_driver = {
>  	.id_table	= menelaus_id,
>  };
>  
> -static int __init menelaus_init(void)
> -{
> -	int res;
> -
> -	res = i2c_add_driver(&menelaus_i2c_driver);
> -	if (res < 0) {
> -		pr_err(DRIVER_NAME ": driver registration failed\n");
> -		return res;
> -	}
> -
> -	return 0;
> -}
> -
> -static void __exit menelaus_exit(void)
> -{
> -	i2c_del_driver(&menelaus_i2c_driver);
> -
> -	/* FIXME: Shutdown menelaus parts that can be shut down */
> -}
> +module_i2c_driver(menelaus_i2c_driver);
>  
>  MODULE_AUTHOR("Texas Instruments, Inc. (and others)");
>  MODULE_DESCRIPTION("I2C interface for Menelaus.");
>  MODULE_LICENSE("GPL");
> -
> -module_init(menelaus_init);
> -module_exit(menelaus_exit);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
