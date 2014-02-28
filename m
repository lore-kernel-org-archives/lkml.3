Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaB1HvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:51:04 -0500
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:9564
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbaB1HvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:51:02 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH 2/3] ASoC: core: Set the default I/O up try
 regmap.
Thread-Topic: [alsa-devel] [PATCH 2/3] ASoC: core: Set the default I/O up
 try regmap.
Thread-Index: AQHPM6qACYVR5A4ww0ayWu7DY52qF5rKCb6AgAAA4rCAABoHAIAAB6RAgAALwACAAAAvYIAAAhGAgAAEQ0CAAAPJgIAACEhQ
Date: Fri, 28 Feb 2014 07:50:41 +0000
Message-ID: <049024c359df495fb8acedd96e574ce2@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
 <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com>
 <20140228035244.GJ9383@sirena.org.uk>
 <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140228052904.GP9383@sirena.org.uk>
 <1b89016263c84e0297655034a648032f@BY2PR03MB505.namprd03.prod.outlook.com>
 <53102EE4.80702@metafoo.de>
 <d872d0fd60eb4c01b38af98014c802aa@BY2PR03MB505.namprd03.prod.outlook.com>
 <531030C7.2060703@metafoo.de>
 <5d534c2ac77040d9bc373db9e43dde7c@BY2PR03MB505.namprd03.prod.outlook.com>
 <53103787.2020702@metafoo.de>
In-Reply-To: <53103787.2020702@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(164054003)(189002)(199002)(51704005)(63696002)(93136001)(90146001)(66066001)(69226001)(76576001)(95666003)(93516002)(56816005)(76786001)(76796001)(81342001)(47976001)(80022001)(65816001)(56776001)(4396001)(74876001)(74706001)(46102001)(47736001)(94316002)(50986001)(77982001)(49866001)(53806001)(85306002)(47446002)(86362001)(92566001)(95416001)(76482001)(54356001)(74502001)(31966008)(94946001)(74316001)(54316002)(85852003)(83322001)(33646001)(79102001)(87936001)(59766001)(51856001)(74366001)(81686001)(83072002)(80976001)(2656002)(81816001)(87266001)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB425;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:60E1FF03.2920E119.7CE230FF.52D0BF5E.20127;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> A quick grep reveals:
> mc13783.c:	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
> si476x.c:	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
> wm5102.c:	codec->control_data = priv->core.arizona->regmap;
> wm5110.c:	codec->control_data = priv->core.arizona->regmap;
> wm8997.c:	codec->control_data = priv->core.arizona->regmap;
> 
> But there might be more.
> 

I have found the following ones, who are using MFD & set_cache_io.

   1    143  sound/soc/codecs/cq93vc.c <<cq93vc_probe>>
             snd_soc_codec_set_cache_io(codec, 32, 32, SND_SOC_REGMAP);
   2    618  sound/soc/codecs/mc13783.c <<mc13783_probe>>
             ret = snd_soc_codec_set_cache_io(codec, 8, 24, SND_SOC_REGMAP);
   3   1765  sound/soc/codecs/wm5102.c <<wm5102_codec_probe>>
             ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
   4   1593  sound/soc/codecs/wm5110.c <<wm5110_codec_probe>>
             ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
   5   1510  sound/soc/codecs/wm8350.c <<wm8350_codec_probe>>
             snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
   6   1322  sound/soc/codecs/wm8400.c <<wm8400_codec_probe>>
             snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
   7   4004  sound/soc/codecs/wm8994.c <<wm8994_codec_probe>>
             snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
   8   1058  sound/soc/codecs/wm8997.c <<wm8997_codec_probe>>
             ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);


Thanks,

--
Best regards,
Xiubo
