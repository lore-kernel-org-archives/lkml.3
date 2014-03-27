Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaC0DlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 23:41:06 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:37447
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752564AbaC0DlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 23:41:05 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Topic: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Index: AQHPSOk07qbuL0Yc9E6K9N8Cg7O135r0MFsAgAAIfACAAAOIEIAAAjIAgAALYOA=
Date: Thu, 27 Mar 2014 03:41:02 +0000
Message-ID: <12f887b3889a41849026965f0cf7db1f@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
 <11a8271c31044515bd2657a93aefdaec@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327023617.GB16197@MrMyself>
 <1e2d210764724c7e834c5307b54c37ab@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327025647.GC16197@MrMyself>
In-Reply-To: <20140327025647.GC16197@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.212]
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(51704005)(189002)(85852003)(4396001)(92566001)(76576001)(98676001)(56816005)(90146001)(50986001)(49866001)(74502001)(47446002)(80976001)(81342001)(47736001)(83072002)(47976001)(97336001)(81542001)(33646001)(80022001)(95416001)(87266001)(87936001)(20776003)(65816001)(85306002)(2656002)(95666003)(79102001)(54356001)(97186001)(93516002)(46102001)(86362001)(94316002)(54316002)(56776001)(51856001)(59766001)(77982001)(53806001)(74706001)(74366001)(74876001)(69226001)(31966008)(74662001)(93136001)(76796001)(81816001)(74316001)(94946001)(63696002)(81686001)(76482001)(76786001)(83322001)(66066001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB444;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:B22AC036.2FF4753B.F5E995A4.90FEECF0.201C7;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
> 
> On Thu, Mar 27, 2014 at 10:53:50AM +0800, Xiubo Li-B47053 wrote:
> > > On Thu, Mar 27, 2014 at 10:13:48AM +0800, Xiubo Li-B47053 wrote:
> > > > > +	regmap_read(sai->regmap, FSL_SAI_TCSR, &xcsr);
> > > > > +	regmap_write(sai->regmap, FSL_SAI_TCSR, xcsr);
> > > > > +
> > > > > +	if (xcsr & FSL_SAI_CSR_WSF)
> > > > > +		dev_dbg(dev, "isr: Start of Tx word detected\n");
> > > > > +
> > > > > +	if (xcsr & FSL_SAI_CSR_SEF)
> > > > > +		dev_dbg(dev, "isr: Tx Frame sync error detected\n");
> > > > > +
> > > > > +	if (xcsr & FSL_SAI_CSR_FEF)
> > > > > +		dev_dbg(dev, "isr: Transmit underrun detected\n");
> > > > > +
> > > >
> > > > Actually, the above three isrs should to write a logic 1 to this field
> > > > to clear this flag.
> > > >
> > > >
> > > > > +	if (xcsr & FSL_SAI_CSR_FWF)
> > > > > +		dev_dbg(dev, "isr: Enabled transmit FIFO is empty\n");
> > > > > +
> > > > > +	if (xcsr & FSL_SAI_CSR_FRF)
> > > > > +		dev_dbg(dev, "isr: Transmit FIFO watermark has been
> reached\n");
> > > > > +
> > > >
> > > > While are these ones really needed to clear manually ?
> > >
> > > The reference manual doesn't mention about the requirement. So SAI should
> do
> > > the self-clearance.
> >
> > Yes, I do think we should let it do the self-clearance, and shouldn't
> interfere
> > of them...
> 
> SAI is supposed to ignore the interference, isn't it?
> 

Maybe, but I'm not very sure.
And these bits are all writable and readable.



