Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaFQOdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:33:41 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53247 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbaFQOdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:33:38 -0400
Date: Tue, 17 Jun 2014 15:33:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mfd: arizona: Disable PM runtime at start of driver
 removal
Message-ID: <20140617143333.GB29841@lee--X1>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1401699043-16835-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401699043-16835-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't want to trigger any PM runtime operations whilst we are tearing
> down the driver, as things the suspend and resume callbacks rely on
> might already have been destroyed. So disable PM runtime for the device
> as the first step arizona_dev_exit.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index cabe8f4..7bdc0f5 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -1024,11 +1024,12 @@ EXPORT_SYMBOL_GPL(arizona_dev_init);
>  
>  int arizona_dev_exit(struct arizona *arizona)
>  {
> +	pm_runtime_disable(arizona->dev);
> +
>  	mfd_remove_devices(arizona->dev);
>  	arizona_free_irq(arizona, ARIZONA_IRQ_UNDERCLOCKED, arizona);
>  	arizona_free_irq(arizona, ARIZONA_IRQ_OVERCLOCKED, arizona);
>  	arizona_free_irq(arizona, ARIZONA_IRQ_CLKGEN_ERR, arizona);
> -	pm_runtime_disable(arizona->dev);
>  	arizona_irq_exit(arizona);
>  	if (arizona->pdata.reset)
>  		gpio_set_value_cansleep(arizona->pdata.reset, 0);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
