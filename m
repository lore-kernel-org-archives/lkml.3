Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbaFQOeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:34:02 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:40532 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaFQOd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:33:58 -0400
Date: Tue, 17 Jun 2014 15:33:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mfd: arizona: Disable DCVDD before we destroy the MFD
Message-ID: <20140617143353.GC29841@lee--X1>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1401699043-16835-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401699043-16835-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014, Charles Keepax wrote:

> As DCVDD is probably supplied by a child of the MFD device move its
> disable to before we destroy the MFD children as the regulator likely
> won't exist after that.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 7bdc0f5..48acac6 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -1026,6 +1026,8 @@ int arizona_dev_exit(struct arizona *arizona)
>  {
>  	pm_runtime_disable(arizona->dev);
>  
> +	regulator_disable(arizona->dcvdd);
> +
>  	mfd_remove_devices(arizona->dev);
>  	arizona_free_irq(arizona, ARIZONA_IRQ_UNDERCLOCKED, arizona);
>  	arizona_free_irq(arizona, ARIZONA_IRQ_OVERCLOCKED, arizona);
> @@ -1033,7 +1035,7 @@ int arizona_dev_exit(struct arizona *arizona)
>  	arizona_irq_exit(arizona);
>  	if (arizona->pdata.reset)
>  		gpio_set_value_cansleep(arizona->pdata.reset, 0);
> -	regulator_disable(arizona->dcvdd);
> +
>  	regulator_bulk_disable(ARRAY_SIZE(arizona->core_supplies),
>  			       arizona->core_supplies);
>  	return 0;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
