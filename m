Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaAWHWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:22:52 -0500
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:4404
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751050AbaAWHWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:22:51 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH Resend 2/8] ASoC: simple-card: fix
 __asoc_simple_card_dai_init
Thread-Topic: [PATCH Resend 2/8] ASoC: simple-card: fix
 __asoc_simple_card_dai_init
Thread-Index: AQHPGACgsNlYt5I0/Ey4S5vAJlYBj5qR5MWAgAACT5A=
Date: Thu, 23 Jan 2014 07:22:48 +0000
Message-ID: <54eb54a8ba71491ba5fe9248aa53732b@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
	<1390453370-29194-3-git-send-email-Li.Xiubo@freescale.com>
 <20140123081151.35837d3b@armhf>
In-Reply-To: <20140123081151.35837d3b@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(189002)(164054003)(47446002)(4396001)(80022001)(85306002)(74502001)(81342001)(74316001)(76576001)(31966008)(87936001)(90146001)(65816001)(2656002)(85852003)(77982001)(74706001)(56816005)(81542001)(93516002)(74366001)(94316002)(86362001)(69226001)(83072002)(87266001)(47736001)(76796001)(74662001)(49866001)(74876001)(83322001)(81686001)(66066001)(46102001)(76786001)(80976001)(53806001)(79102001)(63696002)(51856001)(47976001)(33646001)(50986001)(54316002)(92566001)(59766001)(76482001)(54356001)(56776001)(81816001)(93136001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0N7N12K021977


> > diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-
> card.c
> > index 6443c87..3b8c9a2 100644
> > --- a/sound/soc/generic/simple-card.c
> > +++ b/sound/soc/generic/simple-card.c
> > @@ -31,16 +31,21 @@ static int __asoc_simple_card_dai_init(struct
> snd_soc_dai *dai,
> >
> >  	daifmt |= set->fmt;
> >
> > -	if (daifmt)
> > +	if (daifmt) {
> >  		ret = snd_soc_dai_set_fmt(dai, daifmt);
> > -
> > -	if (ret == -ENOTSUPP) {
> > -		dev_dbg(dai->dev, "ASoC: set_fmt is not supported\n");
> > -		ret = 0;
> > +		if (ret && ret != -ENOTSUPP) {
> > +			dev_err(dai->dev, "simple-card: set_fmt error\n");
> > +			return ret;
> > +		}
> >  	}
> >
> > -	if (!ret && set->sysclk)
> > +	if (set->sysclk) {
> >  		ret = snd_soc_dai_set_sysclk(dai, 0, set->sysclk, 0);
> > +		if (ret && ret != -ENOTSUPP) {
> > +			dev_err(dai->dev, "simple-card: set_sysclk error\n");
> > +			return ret;
> > +		}
> > +	}
> >
> >  	return ret;
> 
> Sorry: you must return 0 here
> 

Yes, the ret maybe -ENOTSUPP.

I will revise it.

Thanks,

Best Regards,
Xiubo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
