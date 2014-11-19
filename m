Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaKSRvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:51:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44427 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbaKSRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:51:35 -0500
Date: Wed, 19 Nov 2014 17:51:32 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Zidan Wang <b50113@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        lars@metafoo.de, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH] ASoC: wm8960: Add shared_lrclk and capless
	to device tree
Message-ID: <20141119175132.GF12443@opensource.wolfsonmicro.com>
References: <1416400568-7512-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416400568-7512-1-git-send-email-b50113@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 08:36:08PM +0800, Zidan Wang wrote:
> wm8960 codec has a wm8960_data struct which has two fields shared_lrclk and capless.
> The wm8960_data is get from platform_data and it is reasonable to set it from device
> tree when platform_data is null.
> And when shared_lrclk is set, LRCM will be enabled. But the following software reset
> in wm8960_probe will reset it to the default state. So LRCM operation should after
> software reset.
> 
> Signed-off-by: Zidan Wang <b50113@freescale.com>
> ---
>  sound/soc/codecs/wm8960.c | 49 ++++++++++++++++++++++++++++++-----------------
>  1 file changed, 31 insertions(+), 18 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
> index 4dc4e85..1d56c90 100644
> --- a/sound/soc/codecs/wm8960.c
> +++ b/sound/soc/codecs/wm8960.c
> @@ -1038,6 +1055,7 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
>  
>  	wm8960 = devm_kzalloc(&i2c->dev, sizeof(struct wm8960_priv),
>  			      GFP_KERNEL);
> +
>  	if (wm8960 == NULL)
>  		return -ENOMEM;

Extra blank line accidentally being added here.

Also I would probably make the shifting of the shared_lrclk
handling a different patch as that is a bug fix and shouldn't
really be tided into a patch adding DT bindings.

As pointed out this will need a corresponding DT documentaion
patch, but apart from those things looks good to me.

Thanks,
Charles
