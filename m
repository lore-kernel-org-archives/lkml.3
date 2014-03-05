Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaCEBc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:32:59 -0500
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:53036
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755811AbaCEBc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:32:58 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [RFC][PATCH 1/3] ASoC: core: Move the default
 regmap I/O setting to snd_soc_register_codec()
Thread-Topic: [alsa-devel] [RFC][PATCH 1/3] ASoC: core: Move the default
 regmap I/O setting to snd_soc_register_codec()
Thread-Index: AQHPN4ydFg9Q570tYUWOT7hNLDkgQJrQr2SAgAEGV5A=
Date: Wed, 5 Mar 2014 01:32:55 +0000
Message-ID: <6957e65a46b94957a9192f1145f8a79c@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393921529-28985-1-git-send-email-Li.Xiubo@freescale.com>
 <1393921529-28985-2-git-send-email-Li.Xiubo@freescale.com>
 <5315A203.2060103@metafoo.de>
In-Reply-To: <5315A203.2060103@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(24454002)(479174003)(377454003)(199002)(189002)(90146001)(63696002)(66066001)(86362001)(92566001)(56816005)(79102001)(74706001)(81542001)(33646001)(74366001)(74316001)(54356001)(31966008)(53806001)(74876001)(65816001)(51856001)(74502001)(94946001)(80022001)(47446002)(76482001)(93136001)(46102001)(77982001)(95416001)(59766001)(81342001)(76796001)(94316002)(76576001)(47736001)(49866001)(85306002)(76786001)(19580395003)(19580405001)(81816001)(87266001)(85852003)(93516002)(83072002)(69226001)(83322001)(87936001)(54316002)(2656002)(81686001)(47976001)(4396001)(95666003)(50986001)(80976001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB425;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:7CFBF9CF.2D201C2B.B8F36BCC.80E83ADB.20201;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [alsa-devel] [RFC][PATCH 1/3] ASoC: core: Move the default regmap
> I/O setting to snd_soc_register_codec()
> 
> On 03/04/2014 09:25 AM, Xiubo Li wrote:
> > Add the default regmap I/O setting to snd_soc_register_codec() while
> > the CODEC is initialising, which will be called by CODEC driver device
> > probe(), and then we can make set_cache_io() go away entirely from each
> > CODEC ASoC probe.
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >   include/sound/soc.h  |  3 +++
> >   sound/soc/soc-core.c | 11 +++++++++++
> >   2 files changed, 14 insertions(+)
> >
> > diff --git a/include/sound/soc.h b/include/sound/soc.h
> > index 4c4d7e1..94bc1c4 100644
> > --- a/include/sound/soc.h
> > +++ b/include/sound/soc.h
> > @@ -749,6 +749,9 @@ struct snd_soc_codec_driver {
> >   	int (*set_pll)(struct snd_soc_codec *codec, int pll_id, int source,
> >   		unsigned int freq_in, unsigned int freq_out);
> >
> > +	/* codec regmap */
> > +	struct regmap *regmap;
> > +
> 
> Nope. The driver struct is globally shared between all device instances, the
> regmap struct is device instance specific. The proper way to solve this is
> to have a function like snd_soc_register_codec_with_io() which takes a
> pointer to the regmap struct.
> 

@Lars
Yes, this maybe a better choice, and I will think of it.

Thanks very much,

--
Best Regards,
Xiubo

