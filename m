Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaICIkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:40:21 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:2228
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbaICIkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:40:15 -0400
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
Thread-Index: AQHPxpcekkjfhHGZ10mq29bP6VjQVZvtr8QAgAEBA4CAAGZmgIAAAE+Q
Date: Wed, 3 Sep 2014 08:39:53 +0000
Message-ID: <b1d8cfcf6cfa48fa83dc06016ae2ff70@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
 <1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
 <5405A598.4050208@ti.com>
 <707d1400a4514be9b599d4b7a6449ba7@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <5406D317.5000403@ti.com>
In-Reply-To: <5406D317.5000403@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(479174003)(24454002)(164054003)(189002)(199003)(66066001)(2501002)(80022001)(2656002)(20776003)(106116001)(76576001)(87936001)(4396001)(76482001)(86362001)(64706001)(101416001)(90102001)(85852003)(83072002)(95666004)(105586002)(74316001)(106356001)(107046002)(2201001)(81542001)(81342001)(77982001)(92566001)(99286002)(19580395003)(93886004)(85306004)(31966008)(74502001)(74662001)(77096002)(108616004)(50986999)(83322001)(76176999)(46102001)(21056001)(99396002)(54356999)(19580405001)(33646002)(1121002)(921003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0616;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
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
> On 09/03/2014 05:37 AM, Li.Xiubo@freescale.com wrote:
> >> Subject: Re: [PATCHv2 1/4] ASoC: simple-card: add
> asoc_simple_card_fmt_master()
> ...
> >>
> >> This won't work. The logic for cpu node needs to be negated for codec node.
> >>
> >
> > Yes, actually it should be.
> >
> > As my previous patches about this:
> > ----
> > Since from the DAI format micro SND_SOC_DAIFMT_CBx_CFx, the 'CBx'
> > mean Codec's bit clock is as master/slave and the 'CFx' mean Codec's
> > frame clock is as master/slave.
> >
> > So these same DAI formats should be informed to CPU and CODE DAIs at
> > the same time. For the Codec driver will set the bit clock and frame
> > clock as the DAI formats said, but for the CPU driver, if the the
> > bit clock or frame clock is as Codec master, so it should be set CPU
> > DAI device as bit clock or frame clock as slave, and vice versa.
> >
> > The old code will cause confusion, and we should be clear that the
> > letter 'C' here mean to Codec.
> > ----
> >
> > For the master format, no matter for CPU or CODEC, it always means Codec
> > is master or slave for bit/frame clock, not means the local DAI device's
> > bit/frame clock as master or slave.
> >
> > So your CPU DAI device driver should negate this locally as the existed
> > Ones do.
> >
> 
> 
> Yes, but there is double negation in this patch. The switch-case
> assignments depend on whether the bitclkmaster and framemaster
> DT-node pointers are compared to a cpu-dai-node or
> codec-dai-node. When your patch compares the codec-node, it does
> the decisions like it was a cpu-node, which produces inverted CBM
> and CFM setting.
> 
> However, Kurinori-san's patch fixes this problem because it just
> uses the daifmt generated by comparing to codec node for both cpu
> and codec nodes.
> 
> The reason why I did the comparison per node basis, was to make
> the code more ready for tdm setups with multiple codecs on a same
> wire. But writing code for something that is not really needed
> yet is usually a bad idea, like it was this time too.
> 
> Kurinori-san's version of the fix should be fine and it cleans up
> the code quite nicely.
> 

Yes, agree.

So I just removed this patch from my patch series list.

Kuninori-san will post his local patch about this later.

Thanks,

BRs
Xiubo
