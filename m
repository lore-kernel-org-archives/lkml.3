Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaH1QQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:16:05 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35807 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaH1QQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:16:01 -0400
Date: Thu, 28 Aug 2014 18:15:56 +0200
From: Robert Richter <rric@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder
 SoC
Message-ID: <20140828161556.GN4703@rric.localhost>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org>
 <CAOesGMh9KkdKB_ytJ7CCbkPW7dHTX91NdfDMsMNfbmOBVOJ8PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMh9KkdKB_ytJ7CCbkPW7dHTX91NdfDMsMNfbmOBVOJ8PQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
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

I was looking into this. It turned out that this would introduce more
pain than it solves. The problem with introducing vendor subdirs for
.dts files is that this will require also subdirs for .dtb files to
avoid name conflicts. This means that dtb files are no longer in a
single directory. Current build scripts and makefiles rely on this.
E.g.:

 scripts/Makefile.lib:$(obj)/%.dtb.S: $(obj)/%.dtb

Thus, the introduction of vendor subdirs is not easy to implement and
may break existing workflows. Also, no other arch has vendor subdirs.

A solution would be to have a naming scheme for dts files which
requires the vendor in the file name, such as cavium-thunder-88xx.dtb.
Though, these long names may look a bit ugly.

Hmm... Any thoughts?

Thanks,

-Robert
