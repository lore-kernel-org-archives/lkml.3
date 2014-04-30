Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbaD3JV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:21:56 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:14123
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758464AbaD3JVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:21:55 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: cq93vc: fix cq93vc_get_regmap build error
Thread-Topic: [PATCH] ASoC: cq93vc: fix cq93vc_get_regmap build error
Thread-Index: AQHPZFN+asrFhsvZfEKkHNY5imRIrZsp4Xkw
Date: Wed, 30 Apr 2014 09:21:52 +0000
Message-ID: <0e8d4a56dbcf440797d5057d22b255b3@BY2PR03MB505.namprd03.prod.outlook.com>
References: <4308079.So6q7GrfYB@wuerfel>
In-Reply-To: <4308079.So6q7GrfYB@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(199002)(189002)(51704005)(77982001)(87936001)(50986999)(46102001)(54356999)(99396002)(19580405001)(33646001)(83072002)(77096999)(99286001)(79102001)(76176999)(74316001)(101416001)(20776003)(76576001)(81542001)(19580395003)(81342001)(2656002)(85852003)(92566001)(74662001)(76482001)(80022001)(83322001)(86362001)(31966008)(80976001)(74502001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:E0B0F61E.1692AEE9.38F519A6.CCD66A49.201A3;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH] ASoC: cq93vc: fix cq93vc_get_regmap build error
> 
> 49101a25acd69c "ASoC: cq93vc: Remove the set_cache_io() entirely from
> ASoC probe" introduced the cq93vc_get_regmap function that has an
> obvious build error referring to the 'codec' variable that is not
> declared anywhere"
> 
> sound/soc/codecs/cq93vc.c: In function 'cq93vc_get_regmap':
> sound/soc/codecs/cq93vc.c:157:34: error: 'codec' undeclared (first use in this
> function)
>   struct davinci_vc *davinci_vc = codec->dev->platform_data;
>                                   ^
> 
> This changes the code to compile again, presumably in the way it was
> intended. Not tested.
> 

Reviewed-by: Xiubo Li <Li.Xiubo@freescale.com>

Thanks,


> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Xiubo Li <Li.Xiubo@freescale.com>
> 
> diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
> index 5ee48c8..537327c 100644
> --- a/sound/soc/codecs/cq93vc.c
> +++ b/sound/soc/codecs/cq93vc.c
> @@ -154,7 +154,7 @@ static int cq93vc_remove(struct snd_soc_codec *codec)
> 
>  static struct regmap *cq93vc_get_regmap(struct device *dev)
>  {
> -	struct davinci_vc *davinci_vc = codec->dev->platform_data;
> +	struct davinci_vc *davinci_vc = dev->platform_data;
> 
>  	return davinci_vc->regmap;
>  }

