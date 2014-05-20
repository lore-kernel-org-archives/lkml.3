Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaETP1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:27:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50963 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbaETP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:27:04 -0400
Date: Tue, 20 May 2014 16:26:59 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave P Martin <Dave.Martin@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140520152659.GA30404@arm.com>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <5080348.QmhgfQRxZW@wuerfel>
 <20140520130659.GA5041@e103592.cambridge.arm.com>
 <6382280.3uMvoxaUSK@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6382280.3uMvoxaUSK@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 02:23:47PM +0100, Arnd Bergmann wrote:
> 	Bit#   33222222 22221111 11111100 00000000
> 	       10987654 32109876 54321098 76543210
> phys.hi cell:  npt000ss bbbbbbbb dddddfff rrrrrrrr
> phys.mid cell: hhhhhhhh hhhhhhhh hhhhhhhh hhhhhhhh
> phys.lo cell:  llllllll llllllll llllllll llllllll
> 
> where:
> n is 0 if the address is relocatable, 1 otherwise
> p is 1 if the addressable region is "prefetchable", 0 otherwise
> t is 1 if the address is aliased (for non-relocatable I/O),
>  below 1 MB (for Memory), or below 64 KB (for relocatable I/O).
> ss is the space code, denoting the address space
> bbbbbbbb is the 8-bit Bus Number
> ddddd is the 5-bit Device Number
> fff is the 3-bit Function Number
> rrrrrrrr is the 8-bit Register Number
> hh...hh is a 32-bit unsigned number
> ll...ll is a 32-bit unsigned number
> 
> We can ignore n, p, t and r here, and use the same format for a DMA
> address, then define an empty "dma-ranges" property. That would
> imply that using b/d/f is sufficient to identify each master at the
> iommu. Any device outside of the PCI host but connected to the same
> iommu can use the same notation to list the logical b/d/f that gets
> sent to the IOMMU in bus master transactions.
> 
> Do you think this is sufficient for the ARM SMMU, or do we need
> something beyond that?

I think it can define the common-cases for the existing implementations,
yes. I anticipate Stream-IDs becoming > 16-bit in the near future though,
so we'd need extra bits if we're describing other devices coming into the
SMMU.

Note that we already have a binding for the current SMMU driver, so I'm not
really in a position to shift over to a new binding until the next version of
the SMMU architecture comes along...

Will
