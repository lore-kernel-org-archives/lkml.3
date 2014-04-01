Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaDAED7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:03:59 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:41358
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750946AbaDAED5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:03:57 -0400
From: "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "timur@tabi.org" <timur@tabi.org>
Subject: RE: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts
 for Tx and Rx streams
Thread-Topic: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts
 for Tx and Rx streams
Thread-Index: AQHPTVjbRLXYSOiWaEaYn6jUdqX/4pr8GHGA///9wwCAAAgzIA==
Date: Tue, 1 Apr 2014 03:48:16 +0000
Message-ID: <034c8b9a3822441dac07512ae2bbb1e7@BN1PR03MB188.namprd03.prod.outlook.com>
References: <1396322227-482-1-git-send-email-Guangyu.Chen@freescale.com>
 <1396322227-482-3-git-send-email-Guangyu.Chen@freescale.com>
 <d00e324f09954dcbb509f8c135ad51af@BN1PR03MB188.namprd03.prod.outlook.com>
 <20140401031409.GA26925@MrMyself>
In-Reply-To: <20140401031409.GA26925@MrMyself>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 016885DD9B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(377454003)(189002)(51704005)(199002)(24454002)(47736001)(95416001)(94316002)(86362001)(77096001)(74876001)(93516002)(94946001)(81686001)(49866001)(51856001)(81542001)(65816001)(33646001)(47976001)(54356001)(79102001)(87266001)(19580405001)(54316002)(95666003)(31966008)(69226001)(80976001)(99396001)(63696002)(90146001)(81816001)(53806001)(83322001)(97186001)(76786001)(66066001)(56776001)(77982001)(85306002)(19580395003)(80022001)(83072002)(76576001)(74366001)(87936001)(81342001)(85852003)(59766001)(93136001)(98676001)(56816005)(74662001)(4396001)(46102001)(2656002)(50986001)(74316001)(92566001)(76482001)(99286001)(20776003)(47446002)(74502001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB445;H:BN1PR03MB188.namprd03.prod.outlook.com;FPR:E3CDFF66.9FB0C578.75FF1FB2.4265CAC1.20335;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Nicolin Chen [mailto:Guangyu.Chen@freescale.com]
> Sent: Tuesday, April 01, 2014 11:14 AM
> To: Wang Dongsheng-B40534
> Cc: broonie@kernel.org; alsa-devel@alsa-project.org; Xiubo Li-B47053; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; timur@tabi.org
> Subject: Re: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts for
> Tx and Rx streams
> 
> On Tue, Apr 01, 2014 at 11:25:02AM +0800, Wang Dongsheng-B40534 wrote:
> > > Subject: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts for
> Tx
> > > and Rx streams
> > >
> > > We only enable one side interrupt for each stream since over/underrun
> > > on the opposite stream would be resulted from what we previously did,
> > > enabling TERE but remaining FRDE disabled, even though the xrun on the
> > > opposite direction will not break the current stream.
> > >
> > > Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> > > Acked-by: Xiubo Li <Li.Xiubo@freescale.com>
> > > ---
> > >  sound/soc/fsl/fsl_sai.c | 8 ++++++--
> > >  sound/soc/fsl/fsl_sai.h | 1 +
> > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> > > index bdfd497..d64c33f 100644
> > > --- a/sound/soc/fsl/fsl_sai.c
> > > +++ b/sound/soc/fsl/fsl_sai.c
> > > @@ -397,4 +397,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> > > *substream, int cmd,
> > >
> > >  		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > +				   FSL_SAI_CSR_xIE_MASK, FSL_SAI_FLAGS);
> > > +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > >  				   FSL_SAI_CSR_FRDE, FSL_SAI_CSR_FRDE);
> > >  		break;
> > > @@ -404,4 +406,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> > > *substream, int cmd,
> > >  		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > >  				   FSL_SAI_CSR_FRDE, 0);
> > > +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > +				   FSL_SAI_CSR_xIE_MASK, 0);
> > >
> > >  		if (!(tcsr & FSL_SAI_CSR_FRDE || rcsr & FSL_SAI_CSR_FRDE)) {
> > > @@ -464,6 +468,6 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
> > >  	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
> > >
> > > -	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, FSL_SAI_FLAGS);
> > > -	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, FSL_SAI_FLAGS);
> > > +	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, 0x0);
> > > +	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, 0x0);
> >
> > Why are you remove this macro? Don't use magic number.
> 
> It's pretty clear that the so-called magic number is to clear the settings
> in the registers for driver init as what this driver did at the first place
> -- no offense but I don't think you would ask this if you check the git-log
> of the driver.
> 
~FSL_SAI_MASK is better than 0x0. And you also replace 0xffffffff.

Regards,
-Dongsheng

> Thank you,
> Nicolin Chen

