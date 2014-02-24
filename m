Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaBXDd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:33:59 -0500
Received: from [207.46.163.240] ([207.46.163.240]:26719 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752291AbaBXDd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:33:57 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@renesas.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] ASoC: simple-card: dynamically allocate the DAI
 link array
Thread-Topic: [PATCH 2/4] ASoC: simple-card: dynamically allocate the DAI
 link array
Thread-Index: AQHPLxpyBsEjRYZK50mVh480hBPn1prDwKrg
Date: Mon, 24 Feb 2014 03:32:02 +0000
Message-ID: <397c6a465f424a3eb42ead8f1e55f7d9@BY2PR03MB505.namprd03.prod.outlook.com>
References: <cover.1392995566.git.moinejf@free.fr>
 <41aa7354a6883f31afa60c21c2e14ecbb3bbb7e9.1392995566.git.moinejf@free.fr>
In-Reply-To: <41aa7354a6883f31afa60c21c2e14ecbb3bbb7e9.1392995566.git.moinejf@free.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0132C558ED
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(164054003)(199002)(189002)(81686001)(63696002)(74316001)(76786001)(76796001)(74366001)(79102001)(81816001)(59766001)(77982001)(74706001)(83072002)(74876001)(85852003)(95666003)(66066001)(90146001)(56816005)(65816001)(31966008)(80022001)(95416001)(85306002)(94316002)(86362001)(94946001)(69226001)(87266001)(19580395003)(76482001)(83322001)(54316002)(56776001)(54356001)(92566001)(46102001)(47446002)(93136001)(93516002)(51856001)(53806001)(33646001)(80976001)(74662001)(47736001)(50986001)(47976001)(81342001)(87936001)(74502001)(4396001)(2656002)(81542001)(49866001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB427;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> @@ -20,7 +20,6 @@ struct simple_card_data {
>  	unsigned int daifmt;
>  	struct asoc_simple_dai cpu_dai;
>  	struct asoc_simple_dai codec_dai;
> -	struct snd_soc_dai_link snd_link;
>  };
> 
>  static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
> @@ -246,7 +245,9 @@ static int asoc_simple_card_probe(struct platform_device
> *pdev)
>  	struct device *dev = &pdev->dev;
>  	int ret;
> 
> -	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	priv = devm_kzalloc(dev,
> +			sizeof(*priv) + sizeof(*dai_link),

This is okey for me.

Well, how about splitting the *priv and *dai_link into two separated
memory blocks? As we can get the dai-link pointer via priv->snd_card.dai_link
in other places.

IMHO, then the code will be much more simplifier and readable.

Just for one suggestion.

Thanks,

--
Best regards,
Xiubo


> +			GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> 
> @@ -255,7 +256,7 @@ static int asoc_simple_card_probe(struct platform_device
> *pdev)
>  	 */
>  	priv->snd_card.owner = THIS_MODULE;
>  	priv->snd_card.dev = dev;
> -	dai_link = &priv->snd_link;
> +	dai_link = (struct snd_soc_dai_link *) (priv + 1);
>  	priv->snd_card.dai_link = dai_link;
>  	priv->snd_card.num_links = 1;
> 
> --
> 1.9.0
> 
> 

