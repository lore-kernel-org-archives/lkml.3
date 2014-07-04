Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbaGDNt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:49:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39529 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756252AbaGDNtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:49:25 -0400
Date: Fri, 4 Jul 2014 14:49:28 +0100
From: Will Deacon <will.deacon@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 01/10] iommu: Add IOMMU device registry
Message-ID: <20140704134928.GA25714@arm.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-2-git-send-email-thierry.reding@gmail.com>
 <20140704110529.GF13434@8bytes.org>
 <20140704134709.GA4203@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704134709.GA4203@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 02:47:10PM +0100, Thierry Reding wrote:
> On Fri, Jul 04, 2014 at 01:05:30PM +0200, Joerg Roedel wrote:
> > On Thu, Jun 26, 2014 at 10:49:41PM +0200, Thierry Reding wrote:
> > > Add an IOMMU device registry for drivers to register with and implement
> > > a method for users of the IOMMU API to attach to an IOMMU device. This
> > > allows to support deferred probing and gives the IOMMU API a convenient
> > > hook to perform early initialization of a device if necessary.
> > 
> > Can you elaborate on why exactly you need this? The IOMMU-API is
> > designed to hide any details from the user about the available IOMMUs in
> > the system and which IOMMU handles which device. This looks like it is
> > going in a completly different direction from that.
> 
> I need this primarily to properly serialize device probing order.
> Without it the IOMMU may be probed later than its clients, in which case
> the client drivers will assume that there is no IOMMU (iommu_present()
> for the parent bus fails).

I can also vouch for needing *a* solution to this problem. The ARM SMMU (and
I think others) rely on initcall ordering rather than the driver probing
model to ensure the IOMMU is probed before any of its masters.

Will
