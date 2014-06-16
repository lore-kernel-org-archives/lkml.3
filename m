Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaFPM5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:57:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50505 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbaFPM5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:57:12 -0400
Date: Mon, 16 Jun 2014 13:57:04 +0100
From: Will Deacon <will.deacon@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Dave P Martin <Dave.Martin@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140616125704.GE16758@arm.com>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com>
 <538757B6.4010109@wwwdotorg.org>
 <20140530073006.GA24748@ulmo>
 <20140530112728.GB3949@e103592.cambridge.arm.com>
 <20140604211237.GC18710@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604211237.GC18710@mithrandir>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:12:38PM +0100, Thierry Reding wrote:
> On Fri, May 30, 2014 at 12:27:28PM +0100, Dave Martin wrote:
> > On Fri, May 30, 2014 at 08:30:08AM +0100, Thierry Reding wrote:
> [...]
> > > Arnd, can you take another look at this binding and see if there's
> > > anything else missing? If not I'll go through the document again and
> > > update all #address-cells/#size-cells references with #iommu-cells as
> > > appropriate and submit v3.
> > 
> > How do you envisage propagation of the master ID bits downstream of the
> > IOMMU would be described?
> > 
> > We will definitely need a way to describe this for GICv3.  How those
> > values are propagated is likely to vary between related SoCs and doesn't
> > feel like it should be baked into a driver, especially for the ARM SMMU
> > which may get reused in radically different SoC families from different
> > vendors.
> 
> Well, we've had cases like these in the past (power sequences come to
> mind). Some concepts are just too difficult or unwieldy to be put into
> device tree. I think that this is one of them.
> 
> > The most likely types of remapping are the adding of a base offset or
> > some extra bits to the ID -- because not all MSIs to the GIC will
> > necessarily pass through the IOMMU.  It's also possible that we might
> > see ID squashing or folding in some systems.
> 
> It can easily be argued that if the algorithm used to remap the ID
> varies, the compatibility of the device changes. Therefore I would
> expect any variant of the GICv3 that deviates from the "standard"
> mapping (if there is such a thing) to have its own compatible string.

There is no standard mapping; it's a property defined at system integration
time. I fully expect different SoCs to do different things here.

Will
