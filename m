Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaIBJQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:16:18 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:55577
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752121AbaIBJQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:16:16 -0400
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
Thread-Index: AQHPxbhYUt4NIVbtUkuD0vLpW80mr5vtkGhA
Date: Tue, 2 Sep 2014 09:15:54 +0000
Message-ID: <6ebdb2b0dcec46ef95084d2fc578b7b8@BY2PR0301MB0613.namprd03.prod.outlook.com>
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
x-forefront-prvs: 0322B4EDE1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(189002)(51704005)(13464003)(199003)(53474002)(4396001)(83072002)(105586002)(54356999)(76176999)(108616004)(80022001)(76482001)(74662001)(31966008)(74502001)(85306004)(90102001)(107046002)(106356001)(46102001)(85852003)(110136001)(106116001)(77982001)(95666004)(99286002)(76576001)(92566001)(81542001)(81342001)(20776003)(2656002)(66066001)(64706001)(74316001)(101416001)(21056001)(83322001)(87936001)(77096002)(86362001)(50986999)(33646002)(19580395003)(99396002)(19580405001)(15866825004)(21314002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB343;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kuninori-san

This patch series will break the old DTs, and I will follow Mark's
Advice to maintain compatibility with the old DTs.

I will send another version, please help me to review it. And I will also
split the update patch series to many small ones.

Thanks very much,

BRs
Xiubo

> -----Original Message-----
> From: Kuninori Morimoto [mailto:kuninori.morimoto.gx@gmail.com]
> Sent: Monday, September 01, 2014 3:43 PM
> To: Xiubo Li-B47053
> Cc: broonie@kernel.org; lgirdwood@gmail.com; perex@perex.cz; tiwai@suse.de;
> kuninori.morimoto.gx@renesas.com; moinejf@free.fr; andrew@lunn.ch;
> jsarha@ti.com; devicetree@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-sh@vger.kernel.org; alsa-devel@alsa-
> project.org; Guo Shawn-R65073; Nicolin Chen; linux-kernel@vger.kernel.org
> Subject: Re: [alsa-devel] [PATCHv1 1/7] ASoC: simple-card: Merge single and
> muti DAI link code.
> 
> 
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
> Best regards
> ---
> Kuninori Morimoto
