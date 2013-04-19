Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3DSRgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:36:07 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:60008 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3DSRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:36:05 -0400
Message-ID: <5171808B.1010209@gmail.com>
Date: Fri, 19 Apr 2013 19:36:11 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
CC: perex@perex.cz, tiwai@suse.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        marek.belisko@streamunlimited.com, broonie@opensource.wolfsonmicro.com,
        lgirdwood@gmail.com
Subject: Re: [PATCH 1/2] ALSA: ASoc: spdif_transciever: Add DT support
References: <1366378725-14471-1-git-send-email-michal.bachraty@streamunlimited.com>
In-Reply-To: <1366378725-14471-1-git-send-email-michal.bachraty@streamunlimited.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 19.04.2013 15:38, Michal Bachraty wrote:
> Add devicetree support for this dummy audio soc driver.

I think Mark wants to see only "ASoC:" in the patch subjects now.

> 
> Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>
> ---
>  sound/soc/codecs/spdif_transciever.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/sound/soc/codecs/spdif_transciever.c b/sound/soc/codecs/spdif_transciever.c
> index 112a49d..4c8c295 100644
> --- a/sound/soc/codecs/spdif_transciever.c
> +++ b/sound/soc/codecs/spdif_transciever.c
> @@ -20,6 +20,7 @@
>  #include <sound/soc.h>
>  #include <sound/pcm.h>
>  #include <sound/initval.h>
> +#include <linux/of.h>
>  
>  #define DRV_NAME "spdif-dit"
>  
> @@ -52,12 +53,21 @@ static int spdif_dit_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id spdif_dit_dt_ids[] = {
> +	{ .compatible = DRV_NAME, },

I think this needs a "linux," prefix. Just put the whole string here.

Same goes for the patch against the spdif_receiver driver.


Thanks,
Daniel


> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, spdif_dits_dt_ids);
> +#endif
> +
>  static struct platform_driver spdif_dit_driver = {
>  	.probe		= spdif_dit_probe,
>  	.remove		= spdif_dit_remove,
>  	.driver		= {
>  		.name	= DRV_NAME,
>  		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(spdif_dit_dt_ids),
>  	},
>  };
>  
> 

