Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbaFQOgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:36:39 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51009 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaFQOgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:36:38 -0400
Date: Tue, 17 Jun 2014 15:36:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mfd: arizona: Use num_core_supplies in
 arizona_dev_exit
Message-ID: <20140617143631.GE29841@lee--X1>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1401699043-16835-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401699043-16835-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014, Charles Keepax wrote:

> Currently we call regulator_bulk_disable with
> ARRAY_SIZE(arizona->core_supplies), however this array may be larger
> than the number of supplies actually used by the chip we are dealing
> with. Use the provided num_core_supplies member instead, so that we only
> disable supplies which actually exist.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 7678e84..51c0110 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -1039,7 +1039,7 @@ int arizona_dev_exit(struct arizona *arizona)
>  	if (arizona->pdata.reset)
>  		gpio_set_value_cansleep(arizona->pdata.reset, 0);
>  
> -	regulator_bulk_disable(ARRAY_SIZE(arizona->core_supplies),
> +	regulator_bulk_disable(arizona->num_core_supplies,
>  			       arizona->core_supplies);
>  	return 0;
>  }

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
