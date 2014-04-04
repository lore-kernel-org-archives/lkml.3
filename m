Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaDDHhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:37:24 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:2529
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752427AbaDDHhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:37:20 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "timur@tabi.org" <timur@tabi.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Fix Bit Clock Polarity configurations
Thread-Topic: [PATCH] ASoC: fsl_sai: Fix Bit Clock Polarity configurations
Thread-Index: AQHPT9SzoBtFKZIfLEyeDsRSykEKpJsBEOVw
Date: Fri, 4 Apr 2014 07:37:00 +0000
Message-ID: <9cb53ac6e0e04c01bc0c6ae6a4d42557@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396595387-4371-1-git-send-email-Guangyu.Chen@freescale.com>
In-Reply-To: <1396595387-4371-1-git-send-email-Guangyu.Chen@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(199002)(189002)(51704005)(76482001)(74366001)(85306002)(76576001)(59766001)(56776001)(54316002)(77982001)(63696002)(76786001)(51856001)(76796001)(74316001)(54356001)(4396001)(47976001)(19580395003)(47736001)(49866001)(20776003)(74706001)(50986001)(74502001)(79102001)(33646001)(46102001)(74662001)(81816001)(74876001)(47446002)(94316002)(81542001)(95666003)(97186001)(93516002)(86362001)(94946001)(81342001)(95416001)(80976001)(99286001)(99396002)(81686001)(69226001)(87266001)(85852003)(98676001)(83322001)(19580405001)(2656002)(90146001)(87936001)(66066001)(65816001)(56816005)(93136001)(80022001)(97336001)(83072002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB443;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:2E207F6C.AEF20CF9.73DCA740.42842B1.20273;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH] ASoC: fsl_sai: Fix Bit Clock Polarity configurations
> 
> The BCP bit in TCR4/RCR4 register rules as followings:
>   0 Bit clock is active high with drive outputs on rising edge
>     and sample inputs on falling edge.
>   1 Bit clock is active low with drive outputs on falling edge
>     and sample inputs on rising edge.
> 
> For all formats currently supported in the fsl_sai driver, they're exactly
> sending data on the falling edge and sampling on the rising edge.
> 
> However, the driver clears this BCP bit for all of them which results click
> noise when working with SGTL5000 and big noise with WM8962.
> 
> Thus this patch corrects the BCP settings for all the formats here to fix
> the nosie issue.
> 
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> ---

Good catch.

Acked-by: Xiubo Li <Li.Xiubo@freescale.com>

Thanks,
--

BRs,
Xiubo


>  sound/soc/fsl/fsl_sai.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> index 99051c7..9bbebea 100644
> --- a/sound/soc/fsl/fsl_sai.c
> +++ b/sound/soc/fsl/fsl_sai.c
> @@ -180,7 +180,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai
> *cpu_dai,
>  		 * that is, together with the last bit of the previous
>  		 * data word.
>  		 */
> -		val_cr2 &= ~FSL_SAI_CR2_BCP;
> +		val_cr2 |= FSL_SAI_CR2_BCP;
>  		val_cr4 |= FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP;
>  		break;
>  	case SND_SOC_DAIFMT_LEFT_J:
> @@ -188,7 +188,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai
> *cpu_dai,
>  		 * Frame high, one word length for frame sync,
>  		 * frame sync asserts with the first bit of the frame.
>  		 */
> -		val_cr2 &= ~FSL_SAI_CR2_BCP;
> +		val_cr2 |= FSL_SAI_CR2_BCP;
>  		val_cr4 &= ~(FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP);
>  		break;
>  	case SND_SOC_DAIFMT_DSP_A:
> @@ -198,7 +198,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai
> *cpu_dai,
>  		 * that is, together with the last bit of the previous
>  		 * data word.
>  		 */
> -		val_cr2 &= ~FSL_SAI_CR2_BCP;
> +		val_cr2 |= FSL_SAI_CR2_BCP;
>  		val_cr4 &= ~FSL_SAI_CR4_FSP;
>  		val_cr4 |= FSL_SAI_CR4_FSE;
>  		sai->is_dsp_mode = true;
> @@ -208,7 +208,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai
> *cpu_dai,
>  		 * Frame high, one bit for frame sync,
>  		 * frame sync asserts with the first bit of the frame.
>  		 */
> -		val_cr2 &= ~FSL_SAI_CR2_BCP;
> +		val_cr2 |= FSL_SAI_CR2_BCP;
>  		val_cr4 &= ~(FSL_SAI_CR4_FSE | FSL_SAI_CR4_FSP);
>  		sai->is_dsp_mode = true;
>  		break;
> --
> 1.8.4
> 

