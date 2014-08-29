Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaH2MMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:12:21 -0400
Received: from [207.46.163.145] ([207.46.163.145]:25789 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751678AbaH2MMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:12:20 -0400
Date: Fri, 29 Aug 2014 14:10:23 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Olof Johansson <olof@lixom.net>
CC: Robert Richter <rric@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder
 SoC
Message-ID: <20140829121023.GW13038@rric.localhost>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org>
 <CAOesGMh9KkdKB_ytJ7CCbkPW7dHTX91NdfDMsMNfbmOBVOJ8PQ@mail.gmail.com>
 <20140828161556.GN4703@rric.localhost>
 <20140828162549.GP14650@leverpostej>
 <CAOesGMjtjcgUNV8WLp6_Zbok-0zq5afg_KS8QJYp=kDVabrQvg@mail.gmail.com>
 <20140828181429.GO4703@rric.localhost>
 <CAOesGMh3TEKZkyPjopfSm07C2ydw5=2VrzY0xQ=9jkhoA-Z_kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOesGMh3TEKZkyPjopfSm07C2ydw5=2VrzY0xQ=9jkhoA-Z_kQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [78.53.86.220]
X-ClientProxiedBy: AM3PR02CA003.eurprd02.prod.outlook.com (10.242.240.23) To
 CO2PR0701MB807.namprd07.prod.outlook.com (10.141.246.25)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(6069001)(189002)(51704005)(377454003)(24454002)(199003)(76482001)(76506005)(79102001)(99396002)(23726002)(93886004)(46406003)(77096002)(107046002)(21056001)(106356001)(19580405001)(97756001)(105586002)(19580395003)(83322001)(54356999)(81542001)(81342001)(76176999)(77982001)(50466002)(83506001)(46102001)(80022001)(101416001)(66066001)(42186005)(33656002)(47776003)(20776003)(95666004)(83072002)(85852003)(110136001)(92566001)(92726001)(50986999)(85306004)(31966008)(86362001)(64706001)(90102001)(4396001)(87976001)(74502001)(74662001);DIR:OUT;SFP:;SCL:1;SRVR:CO2PR0701MB807;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.08.14 16:01:08, Olof Johansson wrote:
> On Thu, Aug 28, 2014 at 11:14 AM, Robert Richter <rric@kernel.org> wrote:
> > On 28.08.14 09:31:43, Olof Johansson wrote:
> >> On Thu, Aug 28, 2014 at 9:25 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > On Thu, Aug 28, 2014 at 05:15:56PM +0100, Robert Richter wrote:
> >> >> Olof,
> >> >>
> >> >> On 30.07.14 11:14:23, Olof Johansson wrote:
> >> >> > On Wed, Jul 30, 2014 at 8:06 AM, Robert Richter <rric@kernel.org> wrote:
> >> >> > > From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> >> >> > >
> >> >> > > Add initial device tree nodes for Cavium Thunder SoCs with support of
> >> >> > > 48 cores and gicv3. The dts file requires further changes, esp. for
> >> >> > > pci, gicv3-its and smmu. This changes will be added later together
> >> >> > > with the device drivers.
> >> >> > >
> >> >> > > Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> >> >> > > Signed-off-by: Robert Richter <rrichter@cavium.com>
> >> >> > > ---
> >> >> > >  arch/arm64/boot/dts/Makefile         |   1 +
> >> >> > >  arch/arm64/boot/dts/thunder-88xx.dts | 387 +++++++++++++++++++++++++++++++++++
> >> >> > >  2 files changed, 388 insertions(+)
> >> >> > >  create mode 100644 arch/arm64/boot/dts/thunder-88xx.dts
> >> >> > >
> >> >> > > diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> >> >> > > index c52bdb051f66..f8001a62029c 100644
> >> >> > > --- a/arch/arm64/boot/dts/Makefile
> >> >> > > +++ b/arch/arm64/boot/dts/Makefile
> >> >> > > @@ -1,3 +1,4 @@
> >> >> > > +dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
> >> >> > >  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
> >> >> > >  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> >> >> >
> >> >> > Oh, and:
> >> >> >
> >> >> > Let's fix the mistake we made on 32-bit here (that we can't undo
> >> >> > unless we move all dts files now, which is too much churn), and put
> >> >> > each SoC vendor in its own subdirectory.
> >> >> >
> >> >> > So, please add a arch/arm64/boot/dts/cavium/ directory, add a Makefile
> >> >> > and the dts there.
> >> >> >
> >> >> > We should move vexpress under arm/   and xgene under apm/ too.
> >> >>
> >> >> I was looking into this. It turned out that this would introduce more
> >> >> pain than it solves. The problem with introducing vendor subdirs for
> >> >> .dts files is that this will require also subdirs for .dtb files to
> >> >> avoid name conflicts. This means that dtb files are no longer in a
> >> >> single directory. Current build scripts and makefiles rely on this.
> >> >> E.g.:
> >> >>
> >> >>  scripts/Makefile.lib:$(obj)/%.dtb.S: $(obj)/%.dtb
> >> >>
> >> >> Thus, the introduction of vendor subdirs is not easy to implement and
> >> >> may break existing workflows. Also, no other arch has vendor subdirs.
> >> >>
> >> >> A solution would be to have a naming scheme for dts files which
> >> >> requires the vendor in the file name, such as cavium-thunder-88xx.dtb.
> >> >> Though, these long names may look a bit ugly.
> >> >>
> >> >> Hmm... Any thoughts?
> >> >
> >> > That would make it possible to search, but the number of files in one
> >> > place might become somewhat overwelming (which I believe was Olof's
> >> > concern).
> >> >
> >> > Olof, thoughts?
> >>
> >> Yeah, on 32 bit we've got an ever-growing and very large directory
> >> today that is becoming a headache. Carving it up in directories to
> >> reduce plain directory size would come a long way.
> >>
> >> I think we would catch name conflicts quickly with the automatic
> >> builders we have today -- and it's likely that the files will have a
> >> platform prefix anyway so it shouldn't be a big issue. I think we can
> >> live with that.
> >
> > So you mean, having the source files with subdirectories, but the dtb
> > files in a single obj dir?

It seems it will be easier to have also subdirs for objs.

> Thinking about it a bit more, the even more obvious solution that I
> for some reason didn't think of at the time, is to have the
> dtbs_install target create the appropriate subdirectories on the
> install side, so that the structure is preserved.
> 
> That comes a bit closer to how modules are handled as well.

Yes, dtbs_install target would be useful.

Will come with a solution for this too.

-Robert
