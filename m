Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaABJ05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 04:26:57 -0500
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:28667
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750711AbaABJ04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:26:56 -0500
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
Thread-Index: AQHPBViOX+iJOlN4DECU2ZJcLzz22Jptnx/ggACbmgCAAukgYA==
Date: Thu, 2 Jan 2014 09:26:50 +0000
Message-ID: <f91162146c844cf79694b1b3880fd926@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388114078-24517-1-git-send-email-Li.Xiubo@freescale.com>
 <20131230121113.GQ31886@sirena.org.uk>
 <4c44077c52604d0b85c4babb59268eb7@BY2PR03MB505.namprd03.prod.outlook.com>
 <20131231122036.GM31886@sirena.org.uk>
In-Reply-To: <20131231122036.GM31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(199002)(189002)(51704005)(24454002)(77982001)(54316002)(50986001)(74876001)(47736001)(47976001)(33646001)(87266001)(81816001)(87936001)(2656002)(81686001)(63696002)(76796001)(76786001)(66066001)(79102001)(80022001)(76576001)(31966008)(47446002)(74662001)(56776001)(4396001)(74502001)(65816001)(85306002)(49866001)(74706001)(76482001)(59766001)(56816005)(19580405001)(83322001)(85852003)(53806001)(69226001)(83072002)(51856001)(90146001)(74366001)(46102001)(19580395003)(54356001)(80976001)(81342001)(74316001)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB256;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
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
> On Tue, Dec 31, 2013 at 03:27:53AM +0000, Li.Xiubo@freescale.com wrote:
> 
> > Also, for most of the devices of the same DAI link, they use the same DAI
> > formats, but I have found some drivers like : "sound/soc/pxa/magician.c"
> > and "sound/soc/s6000/s6105-ipcam.c", etc, may have different DAI format
> > settings for some reasons(maybe some formats are the CPU/Codec devices
> > default setting that it needn't set it here or others).
> 
> The ipcam still has that?  

	-----------
        /* set codec DAI configuration */
        ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
                                             SND_SOC_DAIFMT_CBM_CFM);
        if (ret < 0)
                return ret;

        /* set cpu DAI configuration */
        ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_CBM_CFM |
                                           SND_SOC_DAIFMT_NB_NF);
        if (ret < 0)
                return ret;
	----------

 ... ?

> 
> > I think maybe this is also the reason why the simple-card has common DAI
> > format and CPU/CODEC private DAI formats at the same time.
> 
> I'd really want to see a real use case that actually was a simple card.

I'm also still trying.


Thanks,

--
Best Regards,
Xiubo
