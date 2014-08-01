Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaHAQTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:19:17 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:41319
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750886AbaHAQTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:19:16 -0400
Date: Fri, 1 Aug 2014 18:18:39 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Olof Johansson <olof@lixom.net>
CC: Robert Richter <rric@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder
 SoC
Message-ID: <20140801161839.GE4703@rric.localhost>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org>
 <CAOesGMh9KkdKB_ytJ7CCbkPW7dHTX91NdfDMsMNfbmOBVOJ8PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOesGMh9KkdKB_ytJ7CCbkPW7dHTX91NdfDMsMNfbmOBVOJ8PQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [78.53.84.104]
X-ClientProxiedBy: DB4PR01CA014.eurprd01.prod.exchangelabs.com (10.242.152.44)
 To SN2PR0701MB814.namprd07.prod.outlook.com (25.160.16.148)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6069001)(6009001)(24454002)(189002)(51704005)(199002)(377454003)(4396001)(64706001)(46102001)(76506005)(77982001)(106356001)(50466002)(110136001)(76482001)(42186005)(85306004)(83072002)(105586002)(81342001)(50986999)(19580405001)(74662001)(92566001)(81542001)(87976001)(83506001)(19580395003)(31966008)(107046002)(20776003)(79102001)(66066001)(46406003)(21056001)(99396002)(54356999)(101416001)(80022001)(23726002)(95666004)(86362001)(77096002)(85852003)(76176999)(97756001)(92726001)(47776003)(102836001)(83322001)(74502001)(33656002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR0701MB814;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof,

On 30.07.14 11:14:23, Olof Johansson wrote:
> On Wed, Jul 30, 2014 at 8:06 AM, Robert Richter <rric@kernel.org> wrote:
> > From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> >
> > Add initial device tree nodes for Cavium Thunder SoCs with support of
> > 48 cores and gicv3. The dts file requires further changes, esp. for
> > pci, gicv3-its and smmu. This changes will be added later together
> > with the device drivers.
> >
> > Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > ---
> >  arch/arm64/boot/dts/Makefile         |   1 +
> >  arch/arm64/boot/dts/thunder-88xx.dts | 387 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 388 insertions(+)
> >  create mode 100644 arch/arm64/boot/dts/thunder-88xx.dts
> >
> > diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> > index c52bdb051f66..f8001a62029c 100644
> > --- a/arch/arm64/boot/dts/Makefile
> > +++ b/arch/arm64/boot/dts/Makefile
> > @@ -1,3 +1,4 @@
> > +dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
> >  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
> >  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> 
> Oh, and:
> 
> Let's fix the mistake we made on 32-bit here (that we can't undo
> unless we move all dts files now, which is too much churn), and put
> each SoC vendor in its own subdirectory.
> 
> So, please add a arch/arm64/boot/dts/cavium/ directory, add a Makefile
> and the dts there.
> 
> We should move vexpress under arm/   and xgene under apm/ too.

I well take a look at this.

-Robert
