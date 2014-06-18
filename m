Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965600AbaFRJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:29:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45908 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965099AbaFRJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:29:12 -0400
Date: Wed, 18 Jun 2014 10:29:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stuart Yoder <stuart.yoder@freescale.com>
Cc: Varun Sethi <Varun.Sethi@freescale.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140618092906.GA32699@arm.com>
References: <20140604164132.GF6644@arm.com>
 <07321368d15d4ad9928ebb83af87e401@DM2PR03MB479.namprd03.prod.outlook.com>
 <20140616152739.GS16758@arm.com>
 <8b0492b4697943a0b1f276ef42cc8223@DM2PR03MB352.namprd03.prod.outlook.com>
 <20140616170416.GA16758@arm.com>
 <419e67f783524d208ab3be16bcd94bd9@DM2PR03MB352.namprd03.prod.outlook.com>
 <0587e1f4894546398be0798d2bc2c84f@BL2PR03MB468.namprd03.prod.outlook.com>
 <20140617104304.GD13808@arm.com>
 <32165315f0b84be9948f489fd87bf6a9@BL2PR03MB468.namprd03.prod.outlook.com>
 <7c03c5cffa174b20962bff3b09de0eb8@DM2PR03MB352.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c03c5cffa174b20962bff3b09de0eb8@DM2PR03MB352.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 03:50:25PM +0100, Stuart Yoder wrote:
> > > I think for simple masters (i.e. those that have all their StreamIDs
> > > under control of one driver), then setting something during attach (or
> > > add?) based on the DT could work pretty well. The other case is when we
> > > have masters behind a bridge (such as a PCI RC). In this case, it might
> > > actually be better to ask the bridge for the IDs and let it sort out
> > the
> > > allocation itself. That would also move the RequesterID -> StreamID
> > > mapping out of the SMMU code.
> > >
> > > What do you think?
> > The PCI bus iommu group creation code would be part of the SMMU driver
> > (it is handled by other IOMMU drivers as well). My understanding is that
> > there would be one is to one correspondence between the requestor ID and
> > the iommu group. May be, we can have an API provided by the PCI bridge
> > (architecture specific) for setting the stream ID.
> 
> I think Will is suggesting something along those lines-- I think it's a
> question of where the streamID allocation happens.  You could
> either do something like the following in the SMMU driver when attaching
> a PCI device:
> 
>     id = alloc_stream_id(...);
>     pci_set_streamid(pci-dev, id);
> 
>     or
> 
>     id = pci_get_streamid(pci-dev);
> 
> ...i.e the PCI RC could allocate (from some TBD
> allocator) and set the stream ID itself.
> 
> Not sure how big a deal it is to extend PCI RC interfaces for 
> something like that.

I think both interfaces have their place; the latter for hotpluggable buses
and the former for static allocation (i.e. set once). The only way to see
how well it works is to try implementing it, I guess.

Will
