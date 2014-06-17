Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaFQMST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:18:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33593 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281AbaFQMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:18:17 -0400
Date: Tue, 17 Jun 2014 13:18:11 +0100
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
Message-ID: <20140617121811.GG13808@arm.com>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com>
 <538757B6.4010109@wwwdotorg.org>
 <20140530073006.GA24748@ulmo>
 <20140530112728.GB3949@e103592.cambridge.arm.com>
 <20140604211237.GC18710@mithrandir>
 <20140616125704.GE16758@arm.com>
 <20140617115829.GB18816@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617115829.GB18816@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 12:58:30PM +0100, Thierry Reding wrote:
> On Mon, Jun 16, 2014 at 01:57:04PM +0100, Will Deacon wrote:
> > On Wed, Jun 04, 2014 at 10:12:38PM +0100, Thierry Reding wrote:
> > > It can easily be argued that if the algorithm used to remap the ID
> > > varies, the compatibility of the device changes. Therefore I would
> > > expect any variant of the GICv3 that deviates from the "standard"
> > > mapping (if there is such a thing) to have its own compatible string.
> > 
> > There is no standard mapping; it's a property defined at system integration
> > time. I fully expect different SoCs to do different things here.
> 
> My point was that the mapping itself seems to be fundamental enough to
> make devices with different mappings "incompatible". Therefore I think
> this could probably be handled by using different compatible values,
> something along the lines of this:
> 
> 	compatible = "vendor,soc-gicv3", "arm,gicv3";
> 
> Then the mapping can be described in code, which should be a whole lot
> easier and more flexible than a more or less generic notation in device
> tree.

I don't think that scales well beyond a handful of unique mappings, and I
really anticipate everybody doing something different based on their
integration constraints.

You'd very quickly end up with sets of tables for each SoC, describing the
topology and associated IDs in the kernel source, which feels like a giant
step backwards from where we are today with device tree.

If, for example, the GIC architecture prescribed a fixed set of Device IDs
and an algorithm for converting from Stream IDs then your approach may have
some merits, but that's not where we are today (and I also don't think it's
practical to try and enforce such system-wide properties into an interrupt
controller architecture).

Will
