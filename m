Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3EFK6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:58:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:24770 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab3EFK6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,621,1363158000"; 
   d="scan'208";a="329488784"
Message-ID: <51878D66.4000502@linux.intel.com>
Date: Mon, 06 May 2013 14:00:54 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] gpio: lynxpoint: remove unnecessary platform_set_drvdata()
References: <001801ce4a09$cbf95800$63ec0800$@samsung.com>
In-Reply-To: <001801ce4a09$cbf95800$63ec0800$@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 06:28 AM, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han<jg1.han@samsung.com>
> ---
>   drivers/gpio/gpio-lynxpoint.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
> index 86c17de..761c470 100644
> --- a/drivers/gpio/gpio-lynxpoint.c
> +++ b/drivers/gpio/gpio-lynxpoint.c
> @@ -447,7 +447,6 @@ static int lp_gpio_remove(struct platform_device *pdev)
>   	err = gpiochip_remove(&lg->chip);
>   	if (err)
>   		dev_warn(&pdev->dev, "failed to remove gpio_chip.\n");
> -	platform_set_drvdata(pdev, NULL);
>   	return 0;
>   }
>

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>


