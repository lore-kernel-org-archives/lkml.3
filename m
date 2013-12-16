Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3LPInT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:43:19 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41736 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3LPInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:43:18 -0500
Date: Mon, 16 Dec 2013 08:43:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/3] mfd: mc13xxx: Simplify "probe" & "remove"
Message-ID: <20131216084313.GF18769@lee--X1>
References: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
 <1387026192-21234-3-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387026192-21234-3-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch simplifies "probe" and "remove" functions by moving
> some initialization code in the driver core.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/mc13xxx-core.c | 36 +++++++++++++++++-------------------
>  drivers/mfd/mc13xxx-i2c.c  | 18 ++++--------------
>  drivers/mfd/mc13xxx-spi.c  | 19 ++++++-------------
>  drivers/mfd/mc13xxx.h      |  6 ++----
>  4 files changed, 29 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index b0c7cb0..06e64b6 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c

<snip>

> -	ret = request_threaded_irq(irq, NULL, mc13xxx_irq_thread,
> +	ret = request_threaded_irq(mc13xxx->irq, NULL, mc13xxx_irq_thread,
>  			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);

Please use devm_* managed resources, then you can remove the free_irq().

<snip>

> -void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx)
> +int mc13xxx_common_exit(struct device *dev)
>  {
> +	struct mc13xxx *mc13xxx = dev_get_drvdata(dev);
> +
>  	free_irq(mc13xxx->irq, mc13xxx);

Here.


> -	spi_set_drvdata(spi, mc13xxx);
> +	dev_set_drvdata(&spi->dev, mc13xxx);
> +

What's the point of this? It does the same thing?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
