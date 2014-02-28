Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaB1HJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:09:00 -0500
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:18391
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750820AbaB1HI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:08:59 -0500
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
Thread-Index: AQHPM6qACYVR5A4ww0ayWu7DY52qF5rKCb6AgAAA4rCAABoHAIAAB6RAgAALwACAAAAvYIAAAhGAgAAEQ0A=
Date: Fri, 28 Feb 2014 07:08:56 +0000
Message-ID: <5d534c2ac77040d9bc373db9e43dde7c@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
 <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com>
 <20140228035244.GJ9383@sirena.org.uk>
 <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140228052904.GP9383@sirena.org.uk>
 <1b89016263c84e0297655034a648032f@BY2PR03MB505.namprd03.prod.outlook.com>
 <53102EE4.80702@metafoo.de>
 <d872d0fd60eb4c01b38af98014c802aa@BY2PR03MB505.namprd03.prod.outlook.com>
 <531030C7.2060703@metafoo.de>
In-Reply-To: <531030C7.2060703@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(24454002)(189002)(199002)(51704005)(87936001)(54316002)(83322001)(56776001)(2656002)(47736001)(90146001)(81342001)(47976001)(33646001)(19580395003)(69226001)(50986001)(76482001)(19580405001)(49866001)(81542001)(31966008)(74662001)(74502001)(80976001)(93136001)(92566001)(4396001)(93516002)(53806001)(46102001)(85306002)(51856001)(47446002)(74366001)(95416001)(87266001)(54356001)(94946001)(79102001)(63696002)(74316001)(81686001)(81816001)(76576001)(76786001)(76796001)(83072002)(74706001)(74876001)(85852003)(95666003)(59766001)(94316002)(77982001)(86362001)(56816005)(65816001)(80022001)(66066001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB428;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:FF7AFA4B.1DE07C01.3AE5BF4F.E5BBE8.201DD;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>> Subject: Re: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
> >>>>
> >>>> On Fri, Feb 28, 2014 at 04:00:38AM +0000, Li.Xiubo@freescale.com wrote:
> >>>>
> >>>>> I'll send another patches to applied to use this for another CODEC
> drivers.
> >>>>> And there almost 80 files, Should I send them in one patch or split them
> >>>> into
> >>>>> individual patch for each CODEC driver ?
> >>>>
> >>>> I'd suggest doing one patch that covers the boring drivers where the
> >>>> first thing they do is call set_cache_io() but split out the others into
> >>>> one patch per driver since the need more examination.
> >>>
> >>> Got it.
> >>
> >> Btw. be careful, just removing the set_cache_io() call will not work for
> all
> >> drivers. There are some MFD child devices which use regmap from the parent
> >> device. So dev_get_regmap() will return NULL for those.
> >>
> >
> > @Lars,
> >
> > Do you mean the CODEC drivers like wm5110 and wm8997 ?
> >
> 
> 
> Yes.
> 

I only found these two CODEC drivers using MFD who would get its parent's regmap.

Has I missed some ?

Thanks,

Best Regards,
Xiubo
