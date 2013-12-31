Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab3LaD2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 22:28:16 -0500
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:52845
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750708Ab3LaD2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 22:28:15 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: simple-card: cleanup asoc_simple_card_parse_of()
 code
Thread-Topic: [PATCH] ASoC: simple-card: cleanup asoc_simple_card_parse_of()
 code
Thread-Index: AQHPBViOX+iJOlN4DECU2ZJcLzz22Jptnx/g
Date: Tue, 31 Dec 2013 03:27:53 +0000
Message-ID: <4c44077c52604d0b85c4babb59268eb7@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388114078-24517-1-git-send-email-Li.Xiubo@freescale.com>
 <20131230121113.GQ31886@sirena.org.uk>
In-Reply-To: <20131230121113.GQ31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(189002)(164054003)(51704005)(199002)(24454002)(85306002)(87936001)(74316001)(80976001)(56816005)(74502001)(77982001)(79102001)(85852003)(81686001)(76796001)(33646001)(83072002)(69226001)(31966008)(59766001)(74662001)(90146001)(63696002)(76786001)(2656002)(81542001)(47446002)(56776001)(76576001)(53806001)(80022001)(51856001)(66066001)(74706001)(76482001)(54316002)(50986001)(46102001)(47736001)(81816001)(87266001)(47976001)(49866001)(4396001)(81342001)(74876001)(54356001)(65816001)(74366001)(83322001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB254;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH] ASoC: simple-card: cleanup asoc_simple_card_parse_of()
> code
> 
> On Fri, Dec 27, 2013 at 11:14:38AM +0800, Xiubo Li wrote:
> > Since there is only one common format via "simple-audio-card,format"
> > for simple card driver(CPU & CODEC DAI), there is no need to do the
> > INV mask.
> 
> I don't understand this change, how is the fact that the CPU and CODEC
> DAI share a common format related to using the inversion?  The inversion
> specifies the format relative to the spec rather than relative to the
> other end of the link and for any DAI link the two devices should be
> using the same format.

Also, for most of the devices of the same DAI link, they use the same DAI
formats, but I have found some drivers like : "sound/soc/pxa/magician.c"
and "sound/soc/s6000/s6105-ipcam.c", etc, may have different DAI format
settings for some reasons(maybe some formats are the CPU/Codec devices
default setting that it needn't set it here or others).

I think maybe this is also the reason why the simple-card has common DAI
format and CPU/CODEC private DAI formats at the same time.


Thanks,

--
Best Regards,
Xiubo
