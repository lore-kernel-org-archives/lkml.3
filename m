Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaIXL6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:58:20 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:59139 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaIXL6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:58:19 -0400
Date: Wed, 24 Sep 2014 12:58:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: arizona: Correct mask to allow setting micbias
 external cap
Message-ID: <20140924115813.GN19999@lee--X1>
References: <1411551431-13045-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1411551431-13045-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411551431-13045-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Charles Keepax wrote:

> Currently the mask for the external capacitor bit is missing when
> writing the MICBIAS config meaning it will never be set this patch fixes
> this.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 72b3202..bce7c07 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -947,6 +947,7 @@ int arizona_dev_init(struct arizona *arizona)
>  		regmap_update_bits(arizona->regmap,
>  				   ARIZONA_MIC_BIAS_CTRL_1 + i,
>  				   ARIZONA_MICB1_LVL_MASK |
> +				   ARIZONA_MICB1_EXT_CAP |
>  				   ARIZONA_MICB1_DISCH |
>  				   ARIZONA_MICB1_BYPASS |
>  				   ARIZONA_MICB1_RATE, val);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
