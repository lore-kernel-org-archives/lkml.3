Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaICChX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:37:23 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:59609
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753196AbaICChV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:37:21 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jyri Sarha <jsarha@ti.com>, "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "moinejf@free.fr" <moinejf@free.fr>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 1/4] ASoC: simple-card: add
 asoc_simple_card_fmt_master() to simplify the code.
Thread-Topic: [PATCHv2 1/4] ASoC: simple-card: add
 asoc_simple_card_fmt_master() to simplify the code.
Thread-Index: AQHPxpcekkjfhHGZ10mq29bP6VjQVZvtr8QAgAEBA4A=
Date: Wed, 3 Sep 2014 02:37:06 +0000
Message-ID: <707d1400a4514be9b599d4b7a6449ba7@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
 <1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
 <5405A598.4050208@ti.com>
In-Reply-To: <5405A598.4050208@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(24454002)(199003)(164054003)(479174003)(377454003)(51704005)(33646002)(46102001)(76176999)(101416001)(74502001)(90102001)(54356999)(50986999)(106356001)(20776003)(95666004)(31966008)(99286002)(83072002)(107046002)(74662001)(85852003)(105586002)(85306004)(77982001)(77096002)(74316001)(83322001)(80022001)(81542001)(19580405001)(76576001)(106116001)(19580395003)(87936001)(66066001)(92566001)(4396001)(81342001)(108616004)(79102001)(21056001)(86362001)(99396002)(2656002)(76482001)(2201001)(64706001)(2501002)(1121002)(921003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv2 1/4] ASoC: simple-card: add asoc_simple_card_fmt_master()
> to simplify the code.
> 
> On 09/02/2014 12:26 PM, Xiubo Li wrote:
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >   sound/soc/generic/simple-card.c | 61 ++++++++++++++++++++-----------------
> ----
> >   1 file changed, 29 insertions(+), 32 deletions(-)
> >
> > diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-
> card.c
> > index 986d2c7..cad2b30 100644
> > --- a/sound/soc/generic/simple-card.c
> > +++ b/sound/soc/generic/simple-card.c
> > @@ -163,6 +163,26 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
> >   	return 0;
> >   }
> >
> > +static inline unsigned int
> > +asoc_simple_card_fmt_master(struct device_node *np,
> > +			    struct device_node *bitclkmaster,
> > +			    struct device_node *framemaster)
> > +{
> > +	switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
> > +	case 0x11:
> > +		return SND_SOC_DAIFMT_CBS_CFS;
> > +	case 0x10:
> > +		return SND_SOC_DAIFMT_CBS_CFM;
> > +	case 0x01:
> > +		return SND_SOC_DAIFMT_CBM_CFS;
> > +	default:
> > +		return SND_SOC_DAIFMT_CBM_CFM;
> > +	}
> > +
> > +	/* Shouldn't be here */
> > +	return -EINVAL;
> > +}
> > +
> ....
> > +	fmt = asoc_simple_card_fmt_master(np, bitclkmaster, framemaster);
> > +	dai_props->cpu_dai.fmt = daifmt | fmt;
> ...
> > +		fmt = asoc_simple_card_fmt_master(np, bitclkmaster,
> > +						  framemaster);
> > +		dai_props->codec_dai.fmt = daifmt | fmt;
> 
> This won't work. The logic for cpu node needs to be negated for codec node.
> 

Yes, actually it should be.

As my previous patches about this:
----
Since from the DAI format micro SND_SOC_DAIFMT_CBx_CFx, the 'CBx'
mean Codec's bit clock is as master/slave and the 'CFx' mean Codec's
frame clock is as master/slave.

So these same DAI formats should be informed to CPU and CODE DAIs at
the same time. For the Codec driver will set the bit clock and frame
clock as the DAI formats said, but for the CPU driver, if the the
bit clock or frame clock is as Codec master, so it should be set CPU
DAI device as bit clock or frame clock as slave, and vice versa.

The old code will cause confusion, and we should be clear that the
letter 'C' here mean to Codec.
----

For the master format, no matter for CPU or CODEC, it always means Codec
is master or slave for bit/frame clock, not means the local DAI device's
bit/frame clock as master or slave.

So your CPU DAI device driver should negate this locally as the existed
Ones do.

Thanks,

BRs
Xiubo



