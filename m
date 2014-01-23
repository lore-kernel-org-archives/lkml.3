Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaAWGfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:35:41 -0500
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:40831
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751718AbaAWGfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:35:40 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: David Rientjes <rientjes@google.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/8] ASoC: simple-card: add tdm slot supports
Thread-Topic: [PATCH 6/8] ASoC: simple-card: add tdm slot supports
Thread-Index: AQHPGAClUMEH+aXAu0Kr9scjlixeR5qR092AgAAF4XE=
Date: Thu, 23 Jan 2014 06:35:35 +0000
Message-ID: <a02ec2db6eb4459498ad5dbea44e511c@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-7-git-send-email-Li.Xiubo@freescale.com>,<alpine.DEB.2.02.1401222210560.8088@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401222210560.8088@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(164054003)(199002)(189002)(81816001)(47976001)(47736001)(85306002)(81542001)(87936001)(81686001)(4396001)(80976001)(53806001)(76796001)(92566001)(76576001)(50986001)(79102001)(56776001)(76786001)(93136001)(81342001)(87266001)(49866001)(69226001)(74366001)(59766001)(65816001)(54316002)(85852003)(33646001)(2656002)(63696002)(56816005)(51856001)(74706001)(83072002)(47446002)(74316001)(54356001)(76482001)(74502001)(74876001)(83322001)(31966008)(19580395003)(86362001)(66066001)(80022001)(46102001)(90146001)(93516002)(74662001)(77982001)(94316002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Firstly thanks for your comment.

> > +asoc_simple_card_of_parse_tdm_slot(struct device_node *np,
> > +				   struct device *dev,
> > +				   struct asoc_simple_dai *dai,
> > +				   const char *propname)
> > +{
> > +	struct asoc_simple_tdm_slot *tdm;
> > +	u32 out_value[4];
> > +	int ret;
> > +
> > +	if (!of_property_read_bool(np, propname))
> > +		return 0;
> > +
> > +	tdm = devm_kzalloc(dev, sizeof(*tdm), GFP_KERNEL);
> > +	if (!tdm)
> > +		return -ENOMEM;
> > +
> > +	ret = of_property_read_u32_array(np, propname, out_value, 4);
> > +	if (ret)
> > +		return ret;
> 
> Looks like a memory leak?
>

Using devm_ and this will be called by _probe().

Please see the "Documentation/driver-model/devres.txt" for detail about
devres.

 
> > +
> > +	tdm->tx_mask = out_value[0];
> > +	tdm->rx_mask = out_value[1];
> > +	tdm->slots = out_value[2];
> > +	tdm->slot_width = out_value[3];
> > +
> > +	dai->tdm = tdm;
> > +
> > +	return 0;
> > +}
> > +

Thanks,

Best Regards,
Xiubo

