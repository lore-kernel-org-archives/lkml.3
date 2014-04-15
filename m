Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaDOO6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:58:51 -0400
Received: from [207.46.163.139] ([207.46.163.139]:18176 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751208AbaDOO6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:58:49 -0400
Date: Tue, 15 Apr 2014 16:56:21 +0200
From: Anders Berg <anders.berg@lsi.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/5] ARM: dts: Device tree for AXM55xx.
Message-ID: <20140415145621.GA32285@swsaberg01>
References: <cover.1397552154.git.anders.berg@lsi.com>
 <02c006a6fc64131df82981abbc1c71c7af52254e.1397552154.git.anders.berg@lsi.com>
 <534D294D.7000201@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <534D294D.7000201@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR03CA045.namprd03.prod.outlook.com (10.141.249.18) To
 CO1PR07MB377.namprd07.prod.outlook.com (10.141.74.156)
X-Forefront-PRVS: 0182DBBB05
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(199002)(189002)(479174003)(24454002)(51704005)(83322001)(54356999)(92566001)(19580405001)(50466002)(92726001)(19580395003)(86362001)(50986999)(81542001)(76176999)(4396001)(74502001)(23726002)(46406003)(31966008)(87976001)(74662001)(42186004)(85852003)(20776003)(47776003)(46102001)(79102001)(83072002)(76482001)(99396002)(77982001)(83506001)(80976001)(66066001)(80022001)(97756001)(33656001)(33716001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB377;H:swsaberg01;FPR:74D96520.96308CA6.B8D0ABB6.45C4424E.20256;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 01:42:53PM +0100, Marc Zyngier wrote:
> Hi Anders,
> 
> On 15/04/14 13:06, Anders Berg wrote:
> > Add device tree for the Amarillo validation board with an AXM5516 SoC.
> > 
> > Signed-off-by: Anders Berg <anders.berg@lsi.com>
> > ---
> >  arch/arm/boot/dts/Makefile             |   1 +
> >  arch/arm/boot/dts/axm5516-amarillo.dts |  51 ++++++
> >  arch/arm/boot/dts/axm5516-cpus.dtsi    | 204 ++++++++++++++++++++++
> >  arch/arm/boot/dts/axm55xx.dtsi         | 306 +++++++++++++++++++++++++++++++++
> >  4 files changed, 562 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/axm5516-amarillo.dts
> >  create mode 100644 arch/arm/boot/dts/axm5516-cpus.dtsi
> >  create mode 100644 arch/arm/boot/dts/axm55xx.dtsi
> > 
> 
> [...]
> 
> > +       gic: interrupt-controller@2001001000 {
> > +               compatible = "arm,cortex-a15-gic";
> > +               #interrupt-cells = <3>;
> > +               #address-cells = <0>;
> > +               interrupt-controller;
> > +               reg = <0x20 0x01001000 0 0x1000>,
> > +                     <0x20 0x01002000 0 0x1000>,
> > +                     <0x20 0x01004000 0 0x2000>,
> > +                     <0x20 0x01006000 0 0x2000>;
> > +               interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) |
> > +                               IRQ_TYPE_LEVEL_HIGH)>;
> > +       };
> 
> Given how many CPUs this system has, what's the catch regarding the GIC?
> Is there a second one shadowing this one at the same address for another
> set of 8 CPUs? Is there an additional mechanism to IPI the other CPUs?
> 

There is actually one GIC per cluster and SPIs are used to hook the clusters
together for use as IPIs, so with this patch one cluster may be booted (using
the standard SGIs still works within each cluster).

Have a modified GIC driver to run all clusters, but this patch is a bit to
invasive to submit at the moment...

/Anders
