Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaFPPaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:30:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52541 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbaFPPaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:30:05 -0400
Date: Mon, 16 Jun 2014 16:30:00 +0100
From: Will Deacon <will.deacon@arm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "stuart.yoder@freescale.com" <stuart.yoder@freescale.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        Joerg Roedel <joro@8bytes.org>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 03/20] iommu/arm-smmu: add IOMMU_CAP_NOEXEC to the
 ARM SMMU driver
Message-ID: <20140616153000.GT16758@arm.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-4-git-send-email-a.motakis@virtualopensystems.com>
 <20140616150451.GP16758@arm.com>
 <1402932328.3707.36.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402932328.3707.36.camel@ul30vt.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:25:28PM +0100, Alex Williamson wrote:
> On Mon, 2014-06-16 at 16:04 +0100, Will Deacon wrote:
> > On Thu, Jun 05, 2014 at 06:03:11PM +0100, Antonios Motakis wrote:
> > > The ARM SMMU supports the IOMMU_NOEXEC protection flag. Add the
> > > corresponding IOMMU capability.
> > > 
> > > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > > ---
> > >  drivers/iommu/arm-smmu.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> > > index d5a2200..15ab2af 100644
> > > --- a/drivers/iommu/arm-smmu.c
> > > +++ b/drivers/iommu/arm-smmu.c
> > > @@ -1544,6 +1544,8 @@ static int arm_smmu_domain_has_cap(struct iommu_domain *domain,
> > >  	if (smmu_domain->root_cfg.smmu->features & ARM_SMMU_FEAT_COHERENT_WALK)
> > >  		caps |= IOMMU_CAP_CACHE_COHERENCY;
> > >  
> > > +	caps |= IOMMU_CAP_NOEXEC;
> > > +
> > 
> > Just initialise caps to IOMMU_CAP_NOEXEC.
> 
> No, it shouldn't be a bitmap in the first place.  Thanks,

Ah, ok. I probably led Antonios down the garden path with the ARM SMMU
driver then. Apologies!

Will
