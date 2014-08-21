Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaHUMBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:01:13 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:41400 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbaHUMBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:01:12 -0400
Date: Thu, 21 Aug 2014 13:01:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] mfd: wm5102: Mark register write sequencer
 control 3 readable
Message-ID: <20140821120106.GD4266@lee--X1>
References: <1407926567-10047-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407926567-10047-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014, Charles Keepax wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> During init the core checks if the wm5102 has finished starting by reading
> register 0x19 and looking at the value. This read always fails since this
> is not a readable register, mark it as being one. While we're at it provide
> a constant for the register name (as supplied by Charles Keepax).
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
> 
> Just added the sign-off I forgot on the last version.
> 
> Thanks,
> Charles
> 
>  drivers/mfd/arizona-core.c            |    3 ++-
>  drivers/mfd/wm5102-tables.c           |    1 +
>  include/linux/mfd/arizona/registers.h |    1 +
>  3 files changed, 4 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 10a0cb9..7eabc36 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -784,7 +784,8 @@ int arizona_dev_init(struct arizona *arizona)
>  	/* Ensure device startup is complete */
>  	switch (arizona->type) {
>  	case WM5102:
> -		ret = regmap_read(arizona->regmap, 0x19, &val);
> +		ret = regmap_read(arizona->regmap,
> +				  ARIZONA_WRITE_SEQUENCER_CTRL_3, &val);
>  		if (ret != 0)
>  			dev_err(dev,
>  				"Failed to check write sequencer state: %d\n",
> diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
> index fb4d4bb..c18d527 100644
> --- a/drivers/mfd/wm5102-tables.c
> +++ b/drivers/mfd/wm5102-tables.c
> @@ -1016,6 +1016,7 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_WRITE_SEQUENCER_CTRL_0:
>  	case ARIZONA_WRITE_SEQUENCER_CTRL_1:
>  	case ARIZONA_WRITE_SEQUENCER_CTRL_2:
> +	case ARIZONA_WRITE_SEQUENCER_CTRL_3:
>  	case ARIZONA_WRITE_SEQUENCER_PROM:
>  	case ARIZONA_TONE_GENERATOR_1:
>  	case ARIZONA_TONE_GENERATOR_2:
> diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
> index dbd23c3..68913ec 100644
> --- a/include/linux/mfd/arizona/registers.h
> +++ b/include/linux/mfd/arizona/registers.h
> @@ -27,6 +27,7 @@
>  #define ARIZONA_WRITE_SEQUENCER_CTRL_0           0x16
>  #define ARIZONA_WRITE_SEQUENCER_CTRL_1           0x17
>  #define ARIZONA_WRITE_SEQUENCER_CTRL_2           0x18
> +#define ARIZONA_WRITE_SEQUENCER_CTRL_3           0x19
>  #define ARIZONA_WRITE_SEQUENCER_PROM             0x1A
>  #define ARIZONA_TONE_GENERATOR_1                 0x20
>  #define ARIZONA_TONE_GENERATOR_2                 0x21

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
