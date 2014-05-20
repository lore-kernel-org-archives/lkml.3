Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaETUll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:41:41 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62393 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaETUlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:41:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Tue, 20 May 2014 22:40:50 +0200
Message-ID: <4511166.2tFHJMxbnG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140520163912.GC5041@e103592.cambridge.arm.com>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <20140520152659.GA30404@arm.com> <20140520163912.GC5041@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Xm6dbFwHf5fAztSs3gd/KbXNDI2GlB6q8Pk+Z0kT+PM
 Fz05DhRidpuJQKWB6rWz1VClhTPlco+Ds03LkTv5QoNRMgr87V
 dkH8nRm+mF4pXHDxDT3hpMIeMnffgLKE0nXfgyr/Cjg7sUAcbB
 fWB4cgBkdF2a5g96mLIsjkdHnZHMgG1HDSoWmW9u9BOAK7m+hy
 parAf1Nj58IvY1Eeki7epg/LVReuO4qH54hSi+Q3pMwjONJLt+
 GHIGiMj4pWYF6zNyyy5gIaFJLO/QvQXZdflDCYliKdaOjkG+ep
 kHSmYhm4HikqvUL3fb0vPnvYUFzNNtCXfcmJJGN5M1UMBFciN8
 xuRXBTVIG8PGznpW9MAU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 17:39:12 Dave Martin wrote:
> On Tue, May 20, 2014 at 04:26:59PM +0100, Will Deacon wrote:
> > On Tue, May 20, 2014 at 02:23:47PM +0100, Arnd Bergmann wrote:
> > > 	Bit#   33222222 22221111 11111100 00000000
> > > 	       10987654 32109876 54321098 76543210
> > > phys.hi cell:  npt000ss bbbbbbbb dddddfff rrrrrrrr
> > > phys.mid cell: hhhhhhhh hhhhhhhh hhhhhhhh hhhhhhhh
> > > phys.lo cell:  llllllll llllllll llllllll llllllll
> > > 
> > > where:
> > > n is 0 if the address is relocatable, 1 otherwise
> > > p is 1 if the addressable region is "prefetchable", 0 otherwise
> > > t is 1 if the address is aliased (for non-relocatable I/O),
> > >  below 1 MB (for Memory), or below 64 KB (for relocatable I/O).
> > > ss is the space code, denoting the address space
> > > bbbbbbbb is the 8-bit Bus Number
> > > ddddd is the 5-bit Device Number
> > > fff is the 3-bit Function Number
> > > rrrrrrrr is the 8-bit Register Number
> > > hh...hh is a 32-bit unsigned number
> > > ll...ll is a 32-bit unsigned number
> > > 
> > > We can ignore n, p, t and r here, and use the same format for a DMA
> > > address, then define an empty "dma-ranges" property. That would
> > > imply that using b/d/f is sufficient to identify each master at the
> > > iommu. Any device outside of the PCI host but connected to the same
> > > iommu can use the same notation to list the logical b/d/f that gets
> > > sent to the IOMMU in bus master transactions.
> > > 
> > > Do you think this is sufficient for the ARM SMMU, or do we need
> > > something beyond that?
> > 
> > I think it can define the common-cases for the existing implementations,
> > yes. I anticipate Stream-IDs becoming > 16-bit in the near future though,
> > so we'd need extra bits if we're describing other devices coming into the
> > SMMU.
> > 
> > Note that we already have a binding for the current SMMU driver, so I'm not
> > really in a position to shift over to a new binding until the next version of
> > the SMMU architecture comes along...
> 
> How much code relies on the meaning of the nptsbdf bits?

Not much at all, I think this was defined mostly for open firmware
client interfaces, which we don't use with FDT.

n, t and r are probably only used in PCI functions that are listed
in DT, not in the host bridge.

b/d/f I think is mostly used for the interrupt-maps property, when
describing hardwired interrupts.

p and s are used when setting up the translation for inbound MMIO
and PIO.

	Arnd
