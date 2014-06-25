Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaFYJRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:17:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34063 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529AbaFYJRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:17:04 -0400
Date: Wed, 25 Jun 2014 10:17:02 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olav Haugan <ohaugan@codeaurora.org>, Rob Herring <robherring2@gmail.com>,
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
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140625091702.GF6153@arm.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <53A9BC18.2090106@codeaurora.org>
 <20140624181150.GB4067@arm.com>
 <4855051.rhxSrNMNLg@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4855051.rhxSrNMNLg@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 07:20:56PM +0100, Arnd Bergmann wrote:
> On Tuesday 24 June 2014 19:11:50 Will Deacon wrote:
> > On Tue, Jun 24, 2014 at 06:57:44PM +0100, Olav Haugan wrote:
> > > We do describe the masked StreamID (SID) but we need to specify the mask
> > > that the SMMU should apply to the incoming SIDs, right?
> > > 
> > > We have a bus master that emits 43 unique SIDs. However, we have only 40
> > > SMMU_SMRn registers in the SMMU. So we need to mask out some of the
> > > incoming SID bits so that the 43 SIDs can match one of 40 entries in the
> > > SMR.
> > 
> > Hmm, so you're talking about stream matching, right? That doesn't belong in
> > the device-tree. I appreciate that the current driver does a terrible job at
> > allocating the SMRs (it's bloody difficult!), but we should try to improve
> > the dynamic behaviour instead of moving configuration of the SMMU out into
> > device-tree, where it's inflexible at best.
> > 
> > There have been patches previously posted by Andreas Herrmann helping here.
> > I'd be glad to see them revived.
> 
> Note that there are areas where we have in the past decided that dynamic
> configuration is just too hard for the kernel to do and that we're better
> off putting the configuration into DT. Pinctrl and clocks are at least
> partially in that category.
> 
> It's always best if you can get the kernel to do things in the ideal
> way where that is possible, but getting there may be just not worth it.
> 
> I have no idea where it should be for SMMU, but it's something to consider:
> if you can take reasonable shortcuts by reading parts of the configuration
> from DT, you may just as well do that.

I treat this in the same manner as the topology bindings we discussed
previously; we should do a best-effort to configure things dynamically and
solve corner-cases and quirks as special cases.

Will
