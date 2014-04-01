Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaDADZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:25:11 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:12893
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751186AbaDADZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:25:07 -0400
From: "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "timur@tabi.org" <timur@tabi.org>
Subject: RE: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts
 for Tx and Rx streams
Thread-Topic: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts
 for Tx and Rx streams
Thread-Index: AQHPTVjbRLXYSOiWaEaYn6jUdqX/4pr8GHGA
Date: Tue, 1 Apr 2014 03:25:02 +0000
Message-ID: <d00e324f09954dcbb509f8c135ad51af@BN1PR03MB188.namprd03.prod.outlook.com>
References: <1396322227-482-1-git-send-email-Guangyu.Chen@freescale.com>
 <1396322227-482-3-git-send-email-Guangyu.Chen@freescale.com>
In-Reply-To: <1396322227-482-3-git-send-email-Guangyu.Chen@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 016885DD9B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(377454003)(13464003)(51704005)(19580395003)(94316002)(31966008)(69226001)(81342001)(83322001)(47446002)(80976001)(19580405001)(74502001)(74662001)(99286001)(95666003)(99396001)(79102001)(63696002)(20776003)(56816005)(74316001)(74366001)(74876001)(95416001)(49866001)(53806001)(2656002)(85852003)(83072002)(54356001)(76482001)(87266001)(77982001)(90146001)(85306002)(93136001)(33646001)(59766001)(76786001)(76576001)(86362001)(66066001)(97186001)(94946001)(81816001)(56776001)(81686001)(47976001)(54316002)(98676001)(92566001)(81542001)(50986001)(4396001)(47736001)(65816001)(87936001)(80022001)(77096001)(46102001)(93516002)(51856001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB501;H:BN1PR03MB188.namprd03.prod.outlook.com;FPR:E0C4FF66.1F04C078.7DFF37B2.5265EA41.202A8;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s313PQtt031792



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+b40534=freescale.com@lists.ozlabs.org] On Behalf Of Nicolin Chen
> Sent: Tuesday, April 01, 2014 11:17 AM
> To: broonie@kernel.org
> Cc: alsa-devel@alsa-project.org; Xiubo Li-B47053; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; timur@tabi.org
> Subject: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts for Tx
> and Rx streams
> 
> We only enable one side interrupt for each stream since over/underrun
> on the opposite stream would be resulted from what we previously did,
> enabling TERE but remaining FRDE disabled, even though the xrun on the
> opposite direction will not break the current stream.
> 
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> Acked-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  sound/soc/fsl/fsl_sai.c | 8 ++++++--
>  sound/soc/fsl/fsl_sai.h | 1 +
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> index bdfd497..d64c33f 100644
> --- a/sound/soc/fsl/fsl_sai.c
> +++ b/sound/soc/fsl/fsl_sai.c
> @@ -397,4 +397,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> *substream, int cmd,
> 
>  		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> +				   FSL_SAI_CSR_xIE_MASK, FSL_SAI_FLAGS);
> +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
>  				   FSL_SAI_CSR_FRDE, FSL_SAI_CSR_FRDE);
>  		break;
> @@ -404,4 +406,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> *substream, int cmd,
>  		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
>  				   FSL_SAI_CSR_FRDE, 0);
> +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> +				   FSL_SAI_CSR_xIE_MASK, 0);
> 
>  		if (!(tcsr & FSL_SAI_CSR_FRDE || rcsr & FSL_SAI_CSR_FRDE)) {
> @@ -464,6 +468,6 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
>  	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
> 
> -	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, FSL_SAI_FLAGS);
> -	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, FSL_SAI_FLAGS);
> +	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, 0x0);
> +	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, 0x0);

Why are you remove this macro? Don't use magic number.

Regards,
-Dongsheng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
