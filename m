Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaAWKft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:35:49 -0500
Received: from mail-bn1lp0154.outbound.protection.outlook.com ([207.46.163.154]:42132
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbaAWKdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:33:03 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Timur Tabi <timur@tabi.org>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH] ASoC: fsl-sai: convert to use regmap API
 for Freeacale SAI
Thread-Topic: [alsa-devel] [PATCH] ASoC: fsl-sai: convert to use regmap API
 for Freeacale SAI
Thread-Index: AQHPGBe3iZJSuY3aFUejeXJsnUujFpqSFqcAgAABv+A=
Date: Thu, 23 Jan 2014 10:32:57 +0000
Message-ID: <b073a0513dd04d4b99177b2f2c3a8eb5@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390463283-7545-1-git-send-email-Li.Xiubo@freescale.com>
 <CAOMZO5ATVkcORZBMbNzu2F-dyJxjzgjkRgezj2vGM9v7cyfy1w@mail.gmail.com>
In-Reply-To: <CAOMZO5ATVkcORZBMbNzu2F-dyJxjzgjkRgezj2vGM9v7cyfy1w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(164054003)(51704005)(189002)(199002)(31966008)(76576001)(79102001)(81816001)(87266001)(63696002)(47446002)(85306002)(81342001)(81542001)(76786001)(76796001)(69226001)(77982001)(54316002)(83072002)(56776001)(59766001)(74502001)(74662001)(80022001)(65816001)(53806001)(85852003)(47976001)(4396001)(47736001)(49866001)(56816005)(80976001)(54356001)(51856001)(74706001)(86362001)(46102001)(83322001)(50986001)(33646001)(66066001)(74316001)(2656002)(87936001)(76482001)(81686001)(92566001)(74876001)(74366001)(93516002)(93136001)(1411001)(90146001)(94316002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB442;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.216;FPR:;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0NAZrvW022861


> >  static int fsl_sai_set_dai_sysclk(struct snd_soc_dai *cpu_dai,
> >                 int clk_id, unsigned int freq, int dir)
> >  {
> > -       struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> >         int ret;
> >
> >         if (dir == SND_SOC_CLOCK_IN)
> >                 return 0;
> >
> > -       ret = clk_prepare_enable(sai->clk);
> > -       if (ret)
> > -               return ret;
> 
> The clock related change seems unrelated to the usage of regmap, right?
> 
 
The clock operations in the driver is only related to the module clock, and has
move to the regmap core and regmap core will to the same clock operations at 
proper time, since we are using:

+	sai->regmap = devm_regmap_init_mmio_clk(&pdev->dev,
+			"sai", base, &fsl_sai_regmap_config);


Thanks,

Best Regards,
Xiubo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
