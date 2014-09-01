Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaIAHsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:48:40 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:6925
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752165AbaIAHsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:48:38 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "jsarha@ti.com" <jsarha@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Shawn Guo <Shawn.Guo@freescale.com>,
        "Nicolin Chen" <nicoleotsuka@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCHv1 1/7] ASoC: simple-card: Merge single and
 muti	DAI link code.
Thread-Topic: [alsa-devel] [PATCHv1 1/7] ASoC: simple-card: Merge single and
 muti	DAI link code.
Thread-Index: AQHPxbhYUt4NIVbtUkuD0vLpW80mr5vr5jeA
Date: Mon, 1 Sep 2014 07:48:34 +0000
Message-ID: <ac4db632b6c944dcb2179089076b7871@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
	<1409545781-20530-2-git-send-email-Li.Xiubo@freescale.com>
 <87tx4rzszx.wl%kuninori.morimoto.gx@gmail.com>
In-Reply-To: <87tx4rzszx.wl%kuninori.morimoto.gx@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03218BFD9F
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199003)(51704005)(189002)(74316001)(77982001)(76482001)(106116001)(33646002)(90102001)(105586002)(107046002)(50986999)(21056001)(76176999)(4396001)(83322001)(110136001)(108616004)(54356999)(106356001)(19580395003)(76576001)(86362001)(101416001)(92566001)(74502001)(31966008)(79102001)(87936001)(95666004)(46102001)(74662001)(66066001)(2656002)(77096002)(80022001)(85306004)(99286002)(81342001)(85852003)(81542001)(20776003)(21314002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB338;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Xiubo
> 
> Thank you for your patch.
> This clean-up is very nice for me.
> But, I have 1 small comment
> 
> >  asoc_simple_card_sub_parse_of(struct device_node *np,
> >  			      struct asoc_simple_dai *dai,
> >  			      struct device_node **p_node,
> > -			      const char **name)
> > +			      const char **name,
> > +			      unsigned int *daifmt)
> >  {
> >  	struct device_node *node;
> >  	struct clk *clk;
> >  	u32 val;
> >  	int ret;
> >
> > +	if (!daifmt)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Parse format, bitclock-inversion and frame-inversion
> > +	 * for DAI each device.
> > +	 */
> > +	*daifmt = snd_soc_of_parse_daifmt(np, NULL, NULL, NULL);
> > +	*daifmt &= ~(SND_SOC_DAIFMT_MASTER_MASK | SND_SOC_DAIFMT_FORMAT_MASK);
> (snip)
> >  	ret = asoc_simple_card_sub_parse_of(np, &dai_props->cpu_dai,
> >  					    &dai_link->cpu_of_node,
> > -					    &dai_link->cpu_dai_name);
> > +					    &dai_link->cpu_dai_name,
> > +					    &daifmt);
> (snip)
> > +	dai_props->cpu_dai.fmt |= daifmt;
> (snip)
> >  	ret = asoc_simple_card_sub_parse_of(np, &dai_props->codec_dai,
> >  					    &dai_link->codec_of_node,
> > -					    &dai_link->codec_dai_name);
> > +					    &dai_link->codec_dai_name,
> > +					    &daifmt);
> (snip)
> > +	dai_props->codec_dai.fmt |= daifmt;
> 
> These are using
> 
>       asoc_simple_card_sub_parse_of(np, &dai_props->cpu_dai, xxx)
>       asoc_simple_card_sub_parse_of(np, &dai_props->codec_dai, xxx)
> 
> I guess, asoc_simple_card_sub_parse_of() can update
> below inside function
> 
> 	dai_props->cpu_dai.fmt |= daifmt;
> 	dai_props->codec_dai.fmt |= daifmt;
> 
> 

Yes, yes, that's very well.

Thanks very much for you advice.

For some reason I must resent this patch series, and then I will
fix this together.


BRs
Xiubo

