Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaHYELO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 00:11:14 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58557 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbaHYELN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 00:11:13 -0400
Date: Sun, 24 Aug 2014 21:11:01 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: broonie@kernel.org, timur@tabi.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org, galak@codeaurora.org,
        mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/4] ASoC: fsl-asrc: Convert to use regmap framework's
 endianness method.
Message-ID: <20140825041100.GA2126@Alpha>
References: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
 <1408937462-18727-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408937462-18727-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 11:30:59AM +0800, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  sound/soc/fsl/fsl_asrc.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
> index 8221104..3b14531 100644
> --- a/sound/soc/fsl/fsl_asrc.c
> +++ b/sound/soc/fsl/fsl_asrc.c
> @@ -802,10 +802,6 @@ static int fsl_asrc_probe(struct platform_device *pdev)
>  
>  	asrc_priv->paddr = res->start;
>  
> -	/* Register regmap and let it prepare core clock */

Oops, I didn't notice this change. This should be needless.

Otherwise, the whole change within sound/soc/fsl by this series looks fine.

Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>

> -	if (of_property_read_bool(np, "big-endian"))
> -		fsl_asrc_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
> -
 
