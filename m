Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBXCRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:17:08 -0500
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:45158
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751042AbaBXCRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:17:06 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@renesas.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 1/4] ASoC: simple-card: Fix device node locks
Thread-Topic: [PATCH 1/4] ASoC: simple-card: Fix device node locks
Thread-Index: AQHPLxptjLjL1rYjok64d+mPQ4DO05rDrJtg
Date: Mon, 24 Feb 2014 02:17:00 +0000
Message-ID: <23e531e0edb34aa9b84799e558abaf26@BY2PR03MB505.namprd03.prod.outlook.com>
References: <cover.1392995566.git.moinejf@free.fr>
 <4dca81f45b67a4dcb21271e57409ba114c3b59cb.1392995566.git.moinejf@free.fr>
In-Reply-To: <4dca81f45b67a4dcb21271e57409ba114c3b59cb.1392995566.git.moinejf@free.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0132C558ED
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(164054003)(199002)(189002)(81686001)(76576001)(63696002)(74316001)(76786001)(76796001)(81816001)(74366001)(92566001)(79102001)(77982001)(59766001)(74706001)(74876001)(83072002)(85852003)(95666003)(65816001)(56816005)(66066001)(80022001)(86362001)(95416001)(85306002)(94316002)(94946001)(69226001)(87266001)(76482001)(83322001)(54316002)(56776001)(31966008)(93136001)(93516002)(90146001)(51856001)(54356001)(46102001)(74502001)(53806001)(47446002)(33646001)(80976001)(50986001)(47976001)(47736001)(87936001)(81342001)(81542001)(74662001)(2656002)(4396001)(49866001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB428;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -169,22 +164,26 @@ static int asoc_simple_card_parse_of(struct device_node
> *node,
>  	/* CPU sub-node */
>  	ret = -EINVAL;
>  	np = of_get_child_by_name(node, "simple-audio-card,cpu");
> -	if (np)
> +	if (np) {
>  		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
>  						  &priv->cpu_dai,
>  						  &dai_link->cpu_of_node,
>  						  &dai_link->cpu_dai_name);
> +		of_node_put(np);

Does the of_node_put(np) is really needed here ?


> +	}
>  	if (ret < 0)
>  		return ret;
> 
>  	/* CODEC sub-node */
>  	ret = -EINVAL;
>  	np = of_get_child_by_name(node, "simple-audio-card,codec");
> -	if (np)
> +	if (np) {
>  		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
>  						  &priv->codec_dai,
>  						  &dai_link->codec_of_node,
>  						  &dai_link->codec_dai_name);
> +		of_node_put(np);

The same here...

> +	}
>  	if (ret < 0)
>  		return ret;
> 

Thanks,

--
Best Regards,
Xiubo

