Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab3LaBlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 20:41:08 -0500
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:48425
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932391Ab3LaBlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:41:07 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        Mark Brown <broonie@kernel.org>
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
Thread-Index: AQHPBViOX+iJOlN4DECU2ZJcLzz22JptdpAQgAAQu9A=
Date: Tue, 31 Dec 2013 01:41:02 +0000
Message-ID: <c497d85dd348417fae4ae369d761f098@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388114078-24517-1-git-send-email-Li.Xiubo@freescale.com>
 <20131230121113.GQ31886@sirena.org.uk> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51704005)(199002)(189002)(164054003)(51856001)(90146001)(74366001)(76576001)(83072002)(85852003)(69226001)(81542001)(81342001)(74316001)(46102001)(80976001)(54356001)(59766001)(53806001)(76786001)(66066001)(79102001)(76796001)(63696002)(80022001)(50986001)(47976001)(47736001)(74876001)(77982001)(54316002)(87936001)(2656002)(87266001)(81816001)(81686001)(33646001)(83322001)(56816005)(65816001)(74502001)(47446002)(74662001)(31966008)(56776001)(4396001)(76482001)(49866001)(85306002)(74706001)(21314002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB256;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,


> -----
> 	......
> 
>         /* get CPU/CODEC common format via simple-audio-card,format */
>         info->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
>                 (SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);
> 
> 	......
> 
> 		ret = asoc_simple_card_sub_parse_of(cpu, ...);
> 
> 		...
> 
> 		ret = asoc_simple_card_sub_parse_of(codec, ...);
> 
> 	......
> -----
> The SND_SOC_DAIFMT_INV_MASK bits mask should be for "bitclock-master" and

Sorry the "bitclock-master" should be "bitclock-inversion" just for written
Mistake.



> "frame-inversion" in subnodes' daifmt parsing if need, or why shouldn't
> SND_SOC_DAIFMT_CLOCK_MASK be here like SND_SOC_DAIFMT_INV_MASK ?
> 
> IMO, the SND_SOC_DAIFMT_INV_MASK bits mask here maybe a little confused.
> 
> Certainly, these two and other subnode properties can also be common
> properties
> like "[prefix]format" for other drivers.
> 
> It's the limitation of snd_soc_of_parse_daifmt() that the simple-card driver
> must
> do the mask(except SND_SOC_DAIFMT_MASTER_MASK, because it default value is not
> zero)
> operation.
> 
> Or should we change "bitclock-master" and "frame-master" as one string
> property
> like "[prefix]master = XXX", and set the default value as zero like others.
> And then
> we can remove all the bits mask operations in simple-card and other drivers.
> If need, I will send this patch of this.
> 

 Thanks,
 
 --
 Best Regards,
 Xiubo

