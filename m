Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbaH0CMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:12:25 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:25779
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755066AbaH0CMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:12:23 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "timur@tabi.org" <timur@tabi.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
Thread-Topic: [PATCH] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
Thread-Index: AQHPwDUK14r1GsQH/EGJmKvgOz4mE5vimQ4AgAEbmIA=
Date: Wed, 27 Aug 2014 02:12:18 +0000
Message-ID: <cf0e029ae99d4b48a432e5c1669ddc15@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1408950961-19177-1-git-send-email-Li.Xiubo@freescale.com>
 <20140826090426.GA31558@leverpostej>
In-Reply-To: <20140826090426.GA31558@leverpostej>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(24454002)(13464003)(51704005)(377454003)(199003)(164054003)(80022001)(105586002)(4396001)(83072002)(90102001)(31966008)(81542001)(76482001)(46102001)(107046002)(101416001)(77982001)(66066001)(77096002)(64706001)(74502001)(20776003)(79102001)(108616004)(81342001)(87936001)(85852003)(106116001)(76176999)(86362001)(74316001)(74662001)(50986999)(19580405001)(110136001)(230783001)(575784001)(2656002)(76576001)(95666004)(21056001)(92566001)(99286002)(19580395003)(54356999)(85306004)(106356001)(99396002)(33646002)(83322001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





> -----Original Message-----
> From: Mark Rutland [mailto:mark.rutland@arm.com]
> Sent: Tuesday, August 26, 2014 5:04 PM
> To: Xiubo Li-B47053
> Cc: broonie@kernel.org; nicoleotsuka@gmail.com; timur@tabi.org;
> lgirdwood@gmail.com; perex@perex.cz; tiwai@suse.de; alsa-devel@alsa-
> project.org; galak@codeaurora.org; robh+dt@kernel.org; Pawel Moll; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] ASoC: fsl-sai: using 'lsb-first' property instead of
> 'big-endian-data'.
> 
> On Mon, Aug 25, 2014 at 08:16:01AM +0100, Xiubo Li wrote:
> > This property used for configuring whether the LSB or the MSB is transmitted
> > first for the fifo data.
> 
> I don't follow the rationale for this change.
> 
> This looks like a pointless renaming.
> 
> Why is this any better?
> 

This is originally to indicate whether the LSB firstly or MSB firstly will be
transmitted to the CODEC or received from the CODEC, and there has nothing
Relation to the memory data.

Generally, if the audio data in big endian format, which will be using the bytes
Reversion ? Here this can only be used to bits reversion.

Thanks,


BRs
Xiubo


> Thanks,
> Mark.
> 
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Cc: Nicolin Chen <nicoleotsuka@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/sound/fsl-sai.txt | 8 ++++----
> >  sound/soc/fsl/fsl_sai.c                             | 6 +++---
> >  sound/soc/fsl/fsl_sai.h                             | 2 +-
> >  3 files changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt
> b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> > index 06a405e..4956b14 100644
> > --- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
> > +++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> > @@ -20,9 +20,9 @@ Required properties:
> >    See ../pinctrl/pinctrl-bindings.txt for details of the property values.
> >  - big-endian: Boolean property, required if all the FTM_PWM registers
> >    are big-endian rather than little-endian.
> > -- big-endian-data: If this property is absent, the little endian mode will
> > -  be in use as default, or the big endian mode will be in use for all the
> > -  fifo data.
> > +- lsb-first: Configures whether the LSB or the MSB is transmitted first for
> > +  the fifo data. If this property is absent, the MSB is transmitted first
> as
> > +  default, or the LSB is transmitted first.
> >  - fsl,sai-synchronous-rx: This is a boolean property. If present,
> indicating
> >    that SAI will work in the synchronous mode (sync Tx with Rx) which means
> >    both the transimitter and receiver will send and receive data by
> following
> > @@ -53,5 +53,5 @@ sai2: sai@40031000 {
> >  	      dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
> >  		   <&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;
> >  	      big-endian;
> > -	      big-endian-data;
> > +	      lsb-first;
> >  };
> > diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> > index a6eb784..7eeb1dd 100644
> > --- a/sound/soc/fsl/fsl_sai.c
> > +++ b/sound/soc/fsl/fsl_sai.c
> > @@ -175,7 +175,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai
> *cpu_dai,
> >  	bool tx = fsl_dir == FSL_FMT_TRANSMITTER;
> >  	u32 val_cr2 = 0, val_cr4 = 0;
> >
> > -	if (!sai->big_endian_data)
> > +	if (!sai->is_lsb_first)
> >  		val_cr4 |= FSL_SAI_CR4_MF;
> >
> >  	/* DAI mode */
> > @@ -304,7 +304,7 @@ static int fsl_sai_hw_params(struct snd_pcm_substream
> *substream,
> >  	val_cr5 |= FSL_SAI_CR5_WNW(word_width);
> >  	val_cr5 |= FSL_SAI_CR5_W0W(word_width);
> >
> > -	if (sai->big_endian_data)
> > +	if (sai->is_lsb_first)
> >  		val_cr5 |= FSL_SAI_CR5_FBT(0);
> >  	else
> >  		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
> > @@ -573,7 +573,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
> >  	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx6sx-sai"))
> >  		sai->sai_on_imx = true;
> >
> > -	sai->big_endian_data = of_property_read_bool(np, "big-endian-data");
> > +	sai->is_lsb_first = of_property_read_bool(np, "lsb-first");
> >
> >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	base = devm_ioremap_resource(&pdev->dev, res);
> > diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
> > index 2cded44..3466720 100644
> > --- a/sound/soc/fsl/fsl_sai.h
> > +++ b/sound/soc/fsl/fsl_sai.h
> > @@ -132,7 +132,7 @@ struct fsl_sai {
> >  	struct clk *bus_clk;
> >  	struct clk *mclk_clk[FSL_SAI_MCLK_MAX];
> >
> > -	bool big_endian_data;
> > +	bool is_lsb_first;
> >  	bool is_dsp_mode;
> >  	bool sai_on_imx;
> >  	bool synchronous[2];
> > --
> > 1.8.5
> >
> >
