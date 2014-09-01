Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaIAC5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:57:11 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:7318
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751679AbaIAC5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:57:09 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jyri Sarha <jsarha@ti.com>, Nicolin Chen <nicoleotsuka@gmail.com>
Subject: RE: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
 code.
Thread-Topic: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
 code.
Thread-Index: AQHPw1WlKghmtyQaZ0ed1b/HG05M45vq6jqAgACt5TA=
Date: Mon, 1 Sep 2014 02:57:05 +0000
Message-ID: <1330150cda9f47eb88497fc10fb2b045@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409294797-21948-1-git-send-email-Li.Xiubo@freescale.com>
 <20140831182725.3135db4f@armhf>
In-Reply-To: <20140831182725.3135db4f@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03218BFD9F
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(189002)(199003)(110136001)(31966008)(87936001)(74502001)(85852003)(76482001)(83322001)(19580405001)(99286002)(105586002)(77982001)(79102001)(106116001)(107046002)(99396002)(83072002)(92566001)(74662001)(77096002)(101416001)(76176999)(21056001)(80022001)(66066001)(20776003)(64706001)(46102001)(108616004)(76576001)(90102001)(95666004)(2656002)(85306004)(74316001)(106356001)(86362001)(81542001)(33646002)(54356999)(81342001)(4396001)(50986999)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s812vVaQ002345

> > ---
> >
> > Hi,
> >
> > This patch will break the old DT, so i just send one RFC version, and
> > will add the old DT patches in next version if this patch can work
> > well.
> >
> > Any comments and advices are welcome.
> 
> Hi Xiubo,
> 
> My DT is
> 
> 	sound {
> 		compatible = "simple-audio-card";
> 		simple-audio-card,name = "Cubox Audio";
> 
> 		simple-audio-card,dai-link@0 {		/* I2S - HDMI */
> 			format = "i2s";
> 			cpu {
> 				sound-dai = <&audio1 0>;
> 			};
> 			codec {
> 				sound-dai = <&hdmi 0>;
> 			};
> 		};
> 	...
> 
> I was getting 0x1001 as the format (codec clk & FRM master and i2s').
> 
> With your patch, I get 0x4000 (clk master & frame slave and no format).
> 

Well, yes, If your DAI link's bit clock & frame using the CODEC as master,
You should specify it in your DAI link node like:

> 	sound {
> 		compatible = "simple-audio-card";
> 		simple-audio-card,name = "Cubox Audio";
> 
> 		simple-audio-card,dai-link@0 {		/* I2S - HDMI */
> 			format = "i2s";
> 			cpu {
> 				sound-dai = <&audio1 0>;
> 			};
> 			codec {
> 				sound-dai = <&hdmi 0>;
> 			};

			bitclock-master;
			frame-master;
> 		};
> 	...

And the reason for cannot parsing the "i2s" format is that there is one bug
in this patch and I will fix it in next version.

Thanks very much for your comment.

BRs
Xiubo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
