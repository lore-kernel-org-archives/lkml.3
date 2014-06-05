Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaFETKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:10:25 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:37776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751418AbaFETKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:10:23 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Will Deacon <will.deacon@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, "Arnd Bergmann" <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Grant Grundler" <grundler@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "Rob Herring" <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: RE: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Thread-Topic: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Thread-Index: AQHPdsaiUOp/jHgCJ0WWjZOTtpbJjZtZJRKAgABh1wCAAAcqgIAABQyAgAQdoQCAA2YSAIAAI08AgAG4pNA=
Date: Thu, 5 Jun 2014 19:10:19 +0000
Message-ID: <07321368d15d4ad9928ebb83af87e401@DM2PR03MB479.namprd03.prod.outlook.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
	<4545972.cM7IP1qTXQ@wuerfel>
	<CAL_Jsq+tkFNpjSEZboT+o69B_Z3a8e-ZVKaYDmLwtkyYoPy6VQ@mail.gmail.com>
	<5288123.eXagyPAxNq@wuerfel>
	<20140602104104.GD3855@e103592.cambridge.arm.com>
	<20140604143509.GF28484@ulmo> <20140604164132.GF6644@arm.com>
In-Reply-To: <20140604164132.GF6644@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(51704005)(24454002)(377454003)(13464003)(19580405001)(101416001)(77982001)(74662001)(64706001)(66066001)(21056001)(19580395003)(50986999)(31966008)(80022001)(74502001)(74316001)(20776003)(33646001)(4396001)(86362001)(77096999)(92566001)(2656002)(76482001)(83322001)(54356999)(81542001)(76176999)(99286001)(99396002)(46102001)(83072002)(93886002)(87936001)(79102001)(81342001)(76576001)(85852003)(41533002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB349;H:DM2PR03MB479.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Varun.Sethi@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Will Deacon
> Sent: Wednesday, June 04, 2014 10:12 PM
> To: Thierry Reding
> Cc: Mark Rutland; devicetree@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org; Pawel Moll; Arnd Bergmann; Ian Campbell; Grant
> Grundler; Stephen Warren; linux-kernel@vger.kernel.org; Marc Zyngier;
> Linux IOMMU; Rob Herring; Kumar Gala; linux-tegra@vger.kernel.org; Cho
> KyongHo; Dave P Martin; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree
> bindings
> 
> On Wed, Jun 04, 2014 at 03:35:10PM +0100, Thierry Reding wrote:
> > On Mon, Jun 02, 2014 at 11:41:04AM +0100, Dave Martin wrote:
> > > In the strictest sense, no.
> > >
> > > But for a large set of sane configurations, this probably works.
> > >
> > > Small sets of randomly-assigned IDs can just be enumerated one by
> one.
> > >
> > > We wouldn't be able to describe folding and bit shuffling, but we
> > > probably don't want to encourage that anyway.
> >
> > I'm having some difficulty understanding this. You make it sound like
> > there's a fairly arbitrary number of IDs that the SMMU can handle. So
> > how is the mapping to devices defined? If you say encourage that does
> > make it sound like the assignment of IDs is purely defined by some
> > mechanism in software rather than in hardware. Or they are more or
> > less randomly picked by someone. If that's the case, is that not
> > something that should be dynamically allocated by the kernel rather
> > than put into the device tree?
> 
> The set of StreamIDs that can be generated by a master is fixed in the
> hardware. The SMMU can then be programmed to map these incoming IDs onto
> a context ID (or a set of context IDs), which are the IDs used internally
> by the SMMU to find the page tables etc.
> 
> The StreamID -> ContextID mapping is dynamic and controlled by software.
> The Master -> StreamIDs mapping is fixed in the hardware.
The Master -> StreamIDs mapping may not always be fixed in the hardware. At, least in our case we plan to program these via software. PCI devices is one place where this mapping would have to be dynamic (based on the topology i.e. if the devices are connected to a bridge etc). Also, we have a hot plug device architecture where the stream ID is software programmable.

Other than that, based on the isolation requirements (iommu domain) software programmability offers greater flexibility.

-Varun


