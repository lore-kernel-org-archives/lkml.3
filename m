Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaDAETo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:19:44 -0400
Received: from [207.46.163.186] ([207.46.163.186]:33136 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752541AbaDAETl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:19:41 -0400
X-Greylist: delayed 1881 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2014 00:19:41 EDT
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
Thread-Index: AQHPTVjbRLXYSOiWaEaYn6jUdqX/4pr8GHGA///9wwCAAAgzIP///nSAgAAKafA=
Date: Tue, 1 Apr 2014 04:19:17 +0000
Message-ID: <f16e469a534e4d10ad3c6873758ae4a8@BN1PR03MB188.namprd03.prod.outlook.com>
References: <1396322227-482-1-git-send-email-Guangyu.Chen@freescale.com>
 <1396322227-482-3-git-send-email-Guangyu.Chen@freescale.com>
 <d00e324f09954dcbb509f8c135ad51af@BN1PR03MB188.namprd03.prod.outlook.com>
 <20140401031409.GA26925@MrMyself>
 <034c8b9a3822441dac07512ae2bbb1e7@BN1PR03MB188.namprd03.prod.outlook.com>
 <20140401033758.GB26925@MrMyself>
In-Reply-To: <20140401033758.GB26925@MrMyself>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 016885DD9B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(199002)(377454003)(13464003)(189002)(85852003)(4396001)(56776001)(95666003)(76786001)(79102001)(77096001)(80976001)(31966008)(19580405001)(50986001)(47736001)(56816005)(92566001)(81542001)(2656002)(99396001)(65816001)(74316001)(74366001)(86362001)(87266001)(93516002)(54316002)(76576001)(83072002)(87936001)(76482001)(94316002)(47976001)(83322001)(19580395003)(47446002)(80022001)(20776003)(53806001)(81686001)(51856001)(98676001)(90146001)(59766001)(85306002)(81342001)(74502001)(77982001)(95416001)(46102001)(81816001)(97186001)(33646001)(99286001)(74662001)(93136001)(69226001)(66066001)(94946001)(49866001)(74876001)(54356001)(63696002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB511;H:BN1PR03MB188.namprd03.prod.outlook.com;FPR:20CDFF56.97B0C478.75ED9FB2.4269DAC1.2038F;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Nicolin Chen [mailto:Guangyu.Chen@freescale.com]
> Sent: Tuesday, April 01, 2014 11:38 AM
> To: Wang Dongsheng-B40534
> Cc: broonie@kernel.org; alsa-devel@alsa-project.org; Xiubo Li-B47053; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; timur@tabi.org
> Subject: Re: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts for
> Tx and Rx streams
> 
> On Tue, Apr 01, 2014 at 11:48:16AM +0800, Wang Dongsheng-B40534 wrote:
> >
> >
> > > -----Original Message-----
> > > From: Nicolin Chen [mailto:Guangyu.Chen@freescale.com]
> > > Sent: Tuesday, April 01, 2014 11:14 AM
> > > To: Wang Dongsheng-B40534
> > > Cc: broonie@kernel.org; alsa-devel@alsa-project.org; Xiubo Li-B47053;
> linuxppc-
> > > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; timur@tabi.org
> > > Subject: Re: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts
> for
> > > Tx and Rx streams
> > >
> > > On Tue, Apr 01, 2014 at 11:25:02AM +0800, Wang Dongsheng-B40534 wrote:
> > > > > Subject: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts
> for
> > > Tx
> > > > > and Rx streams
> > > > >
> > > > > We only enable one side interrupt for each stream since over/underrun
> > > > > on the opposite stream would be resulted from what we previously did,
> > > > > enabling TERE but remaining FRDE disabled, even though the xrun on the
> > > > > opposite direction will not break the current stream.
> > > > >
> > > > > Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> > > > > Acked-by: Xiubo Li <Li.Xiubo@freescale.com>
> > > > > ---
> > > > >  sound/soc/fsl/fsl_sai.c | 8 ++++++--
> > > > >  sound/soc/fsl/fsl_sai.h | 1 +
> > > > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> > > > > index bdfd497..d64c33f 100644
> > > > > --- a/sound/soc/fsl/fsl_sai.c
> > > > > +++ b/sound/soc/fsl/fsl_sai.c
> > > > > @@ -397,4 +397,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> > > > > *substream, int cmd,
> > > > >
> > > > >  		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > > > +				   FSL_SAI_CSR_xIE_MASK, FSL_SAI_FLAGS);
> > > > > +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > > >  				   FSL_SAI_CSR_FRDE, FSL_SAI_CSR_FRDE);
> > > > >  		break;
> > > > > @@ -404,4 +406,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> > > > > *substream, int cmd,
> > > > >  		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > > >  				   FSL_SAI_CSR_FRDE, 0);
> > > > > +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > > > +				   FSL_SAI_CSR_xIE_MASK, 0);
> > > > >
> > > > >  		if (!(tcsr & FSL_SAI_CSR_FRDE || rcsr & FSL_SAI_CSR_FRDE)) {
> > > > > @@ -464,6 +468,6 @@ static int fsl_sai_dai_probe(struct snd_soc_dai
> *cpu_dai)
> > > > >  	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
> > > > >
> > > > > -	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff,
> FSL_SAI_FLAGS);
> > > > > -	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff,
> FSL_SAI_FLAGS);
> > > > > +	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, 0x0);
> > > > > +	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, 0x0);
> > > >
> > > > Why are you remove this macro? Don't use magic number.
> > >
> > > It's pretty clear that the so-called magic number is to clear the settings
> > > in the registers for driver init as what this driver did at the first place
> > > -- no offense but I don't think you would ask this if you check the git-log
> > > of the driver.
> > >
> > ~FSL_SAI_MASK is better than 0x0. And you also replace 0xffffffff.
> 
> I would later send a patch to reset SAI for a true init instead of these lines
> but not within this patch as it's focusing on the interrupts enabling.
> 
> So please don't grasp the mask here. Just let me continue.
> 

:), fine.

Regards,
-Dongsheng

> Thank you,
> Nicolin Chen

