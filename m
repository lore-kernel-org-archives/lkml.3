Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbaHGMLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:11:06 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:54484
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754519AbaHGMLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:11:05 -0400
Date: Thu, 7 Aug 2014 20:09:11 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH V2 2/2] Revert "ASoC: fsl-esai: Add
 .xlate_tdm_slot_mask() support."
Message-ID: <20140807120909.GA4153@MrMyself>
References: <cover.1407403727.git.shengjiu.wang@freescale.com>
 <5627d0f839900c33b1c15de4c21f745015d3e19d.1407403727.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5627d0f839900c33b1c15de4c21f745015d3e19d.1407403727.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(24454002)(51704005)(50986999)(46102001)(106466001)(64706001)(80022001)(99396002)(20776003)(21056001)(105606002)(97756001)(54356999)(47776003)(97736001)(74502001)(33716001)(74662001)(4396001)(95666004)(50466002)(46406003)(86362001)(81342001)(83322001)(76482001)(77982001)(33656002)(81542001)(6806004)(102836001)(19580405001)(26826002)(19580395003)(84676001)(79102001)(44976005)(31966008)(85852003)(92726001)(110136001)(85306004)(87936001)(76176999)(107046002)(23726002)(92566001)(68736004)(104016003)(15975445006)(83072002)(83506001)(15202345003)(142923001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB328;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 029651C7A1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shengjiu,
   
On Thu, Aug 07, 2014 at 05:33:25PM +0800, Shengjiu Wang wrote:
> This reverts commit a603c8ee526f5ea9ad9b40710308766299ad8a69.
> 
> fsl_asoc_xlate_tdm_slot_mask() will invert the mask, which isn't fit for
> esai. The default function snd_soc_xlate_tdm_slot_mask() is ok for esai.

You should describe why that doesn't fit for ESAI and what's the result
if keeping it.

Thank you,
Nicolin

> 
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> ---
>  sound/soc/fsl/Kconfig    |    1 -
>  sound/soc/fsl/fsl_esai.c |    2 --
>  2 files changed, 3 deletions(-)
> 
> diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
> index f54a8fc..f3012b6 100644
> --- a/sound/soc/fsl/Kconfig
> +++ b/sound/soc/fsl/Kconfig
> @@ -49,7 +49,6 @@ config SND_SOC_FSL_ESAI
>  	tristate "Enhanced Serial Audio Interface (ESAI) module support"
>  	select REGMAP_MMIO
>  	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
> -	select SND_SOC_FSL_UTILS
>  	help
>  	  Say Y if you want to add Enhanced Synchronous Audio Interface
>  	  (ESAI) support for the Freescale CPUs.
> diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
> index f252370..b2f6b3e 100644
> --- a/sound/soc/fsl/fsl_esai.c
> +++ b/sound/soc/fsl/fsl_esai.c
> @@ -18,7 +18,6 @@
>  
>  #include "fsl_esai.h"
>  #include "imx-pcm.h"
> -#include "fsl_utils.h"
>  
>  #define FSL_ESAI_RATES		SNDRV_PCM_RATE_8000_192000
>  #define FSL_ESAI_FORMATS	(SNDRV_PCM_FMTBIT_S8 | \
> @@ -612,7 +611,6 @@ static struct snd_soc_dai_ops fsl_esai_dai_ops = {
>  	.hw_params = fsl_esai_hw_params,
>  	.set_sysclk = fsl_esai_set_dai_sysclk,
>  	.set_fmt = fsl_esai_set_dai_fmt,
> -	.xlate_tdm_slot_mask = fsl_asoc_xlate_tdm_slot_mask,
>  	.set_tdm_slot = fsl_esai_set_dai_tdm_slot,
>  };
>  
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
