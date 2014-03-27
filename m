Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbaC0EG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:06:58 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:15110
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750761AbaC0EG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:06:56 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Topic: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Index: AQHPSOk07qbuL0Yc9E6K9N8Cg7O135r0MFsAgAAIfACAAAOIEIAAAjIAgAALYOD///5EAIAAB+Kw
Date: Thu, 27 Mar 2014 04:06:53 +0000
Message-ID: <62630844c7434df6937ca25d3f47b656@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
 <11a8271c31044515bd2657a93aefdaec@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327023617.GB16197@MrMyself>
 <1e2d210764724c7e834c5307b54c37ab@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327025647.GC16197@MrMyself>
 <12f887b3889a41849026965f0cf7db1f@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327033117.GD16197@MrMyself>
In-Reply-To: <20140327033117.GD16197@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.212]
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(199002)(76576001)(76482001)(83322001)(56776001)(76796001)(79102001)(81342001)(76786001)(98676001)(47736001)(33646001)(87266001)(47976001)(54316002)(95666003)(74502001)(49866001)(85852003)(94316002)(74876001)(53806001)(66066001)(80976001)(54356001)(46102001)(2656002)(93516002)(97186001)(81686001)(94946001)(92566001)(65816001)(47446002)(4396001)(63696002)(69226001)(50986001)(56816005)(90146001)(74366001)(86362001)(95416001)(74316001)(74662001)(81816001)(51856001)(20776003)(93136001)(97336001)(85306002)(77982001)(81542001)(83072002)(31966008)(74706001)(87936001)(59766001)(80022001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB442;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:CDD0E035.83E4772B.E5ED95A8.1CDAC420.2019D;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > > > +	if (xcsr & FSL_SAI_CSR_FWF)
> > > > > > > +		dev_dbg(dev, "isr: Enabled transmit FIFO is empty\n");
> > > > > > > +
> > > > > > > +	if (xcsr & FSL_SAI_CSR_FRF)
> > > > > > > +		dev_dbg(dev, "isr: Transmit FIFO watermark has been
> > > reached\n");
> > > > > > > +
> > > > > >
> > > > > > While are these ones really needed to clear manually ?
> > > > >
> > > > > The reference manual doesn't mention about the requirement. So SAI
> should
> > > do
> > > > > the self-clearance.
> > > >
> > > > Yes, I do think we should let it do the self-clearance, and shouldn't
> > > interfere
> > > > of them...
> > >
> > > SAI is supposed to ignore the interference, isn't it?
> > >
> >
> > Maybe, but I'm not very sure.
> > And these bits are all writable and readable.
> 
> Double-confirmed? Because FWF and FRF should be read-only bits.
> 

So let's just ignore the clearance of these bits in isr().

+++++
SAI Transmit Control Register (I2S1_TCSR) : 32 : R/W : 0000_0000h
-----

I have checked in the Vybrid and LS1 SoC datasheets, and they are all the
Same as above, and nothing else.

Have I missed ?

