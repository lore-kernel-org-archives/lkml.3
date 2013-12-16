Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3LPDso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 22:48:44 -0500
Received: from [207.46.163.155] ([207.46.163.155]:12059 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab3LPDsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 22:48:43 -0500
X-Greylist: delayed 1024 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Dec 2013 22:48:43 EST
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>, Shawn Guo <shawn.guo@linaro.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "oskar@scara.com" <oskar@scara.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] ASoC: SGTL5000: Fix kernel failed while trying to
 get optional VDDD supply.
Thread-Topic: [PATCH v2] ASoC: SGTL5000: Fix kernel failed while trying to
 get optional VDDD supply.
Thread-Index: AQHO7AxdZKvMm2ccHkqsJB91kAqIGJo8jGuAgAWYrhCAAEr2gIAT0M6A
Date: Mon, 16 Dec 2013 03:31:36 +0000
Message-ID: <1e493d42f11648428d1ce95883313f2a@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1385621219-20652-1-git-send-email-Li.Xiubo@freescale.com>
 <20131129183855.GI27568@sirena.org.uk>
 <1DD289F6464F0949A2FCA5AA6DC23F828E3D21@039-SN2MPN1-011.039d.mgd.msft.net>
 <20131203123459.GS27568@sirena.org.uk>
In-Reply-To: <20131203123459.GS27568@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0062BDD52C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(189002)(199002)(51704005)(54356001)(53806001)(85306002)(81816001)(81686001)(76482001)(83322001)(63696002)(74662001)(51856001)(69226001)(2656002)(81542001)(50986001)(81342001)(87936001)(76796001)(76786001)(46102001)(74706001)(74366001)(74316001)(56816005)(74876001)(47976001)(76576001)(47736001)(4396001)(87266001)(83072002)(74502001)(31966008)(85852003)(47446002)(66066001)(80022001)(80976001)(65816001)(33646001)(49866001)(79102001)(54316002)(56776001)(59766001)(77982001)(90146001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB253;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 2, If the regulator dt node is exist but the optional VDDD is absent (i.e.
> > The external VDDD is not used), a -EPROBE_DEFER will be returned, if
> > just return the -EPROBE_DEFER to the probe(and then the probe deferral
> > mechanism will do the probe again later, is that right ?), and then
> > the
> > regulator_get_optional() will be called later again, and the
> > -EPROBE_DEFER will be returned again too, and now how should I handle
> > -EPROBE_DEFER error twice ? Or should there be a counter about this ?
> > That to say when the -EPROBE_DEFER error is the second time returned
> > from regulator_get_optional() can we ensure that the optional VDDD is really
> not in use.
> 
> The driver should just defer when it's told to defer, I don't understand why it
> would want to count anything?
>

It's just one idea for the special handling of regulator_get_optional() in this
case.

--
Xiubo


