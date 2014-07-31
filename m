Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaGaKuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:50:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56920 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbaGaKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:50:22 -0400
Date: Thu, 31 Jul 2014 11:50:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140731105017.GB22994@leverpostej>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140730152646.GC20162@leverpostej>
 <CAOesGMi3zM1-cqmeGddJ69RNXx0ktFm_zXO_yq7N0EeA3HNrUQ@mail.gmail.com>
 <20140730181842.GG20162@leverpostej>
 <20140731100905.GA7458@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731100905.GA7458@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 11:09:06AM +0100, Thierry Reding wrote:
> On Wed, Jul 30, 2014 at 07:18:42PM +0100, Mark Rutland wrote:
> [...]
> > > >> +
> > > >> +Multiple-master IOMMU with configurable DMA window:
> > > >> +---------------------------------------------------
> > > >> +
> > > >> +     / {
> > > >> +             #address-cells = <1>;
> > > >> +             #size-cells = <1>;
> > > >> +
> > > >> +             iommu {
> > > >> +                     /* master ID, address and length of DMA window */
> > > >> +                     #iommu-cells = <4>;
> > > >> +             };
> > > >> +
> > > >> +             master {
> > > >> +                     /* master ID 42, 4 GiB DMA window starting at 0 */
> > > >> +                     iommus = <&/iommu  42  0  0x1 0x0>;
> > > >
> > > > Is this that window is from the POV of the master, i.e. the master can
> > > > address 0x0 to 0xffffffff when generating transactions, and these get
> > > > translated somehow?
> > > >
> > > > Or is this the physical addresses to allocate to the master?
> > > 
> > > It needs to be clarified in the documentation, but as far as I know it
> > > is the DMA address space that is used.
> > 
> > Ok. So that's pre-translation, from the POV of the master?
> 
> Correct. It represents the window of the IOMMU's addressable I/O virtual
> address space that should be assigned to this particular master.
> 
> > If we don't have that knowledge about the master already (e.g. based on
> > the compatible string), surely we always need that information in a
> > given iommu-specifier format? Otherwise certain iommus won't be able to
> > handle masters with limited addressing only due to limitations of their
> > binding.
> 
> This is only used for what's often called a windowed IOMMU. Many IOMMUs
> (non-windowed) typically allow only a complete address space to be
> assigned to a master without additional control over subregions. So this
> is really a property/capability of the IOMMU rather than the masters
> themselves.

I'm not sure I follow, but I'm happy to wait until we have the first
windowed IOMMU using this binding. I'll try to get myself up to speed in
the mean time.

> There are already other means to respect the addressing limitations of
> masters. We typcially use a device's DMA mask for this, and it's natural
> to reuse that for I/O virtual addresses since they will in fact take the
> place of physical addresses for the master when translation is enabled.

Ok, that covers my worry then.

Cheers,
Mark.
