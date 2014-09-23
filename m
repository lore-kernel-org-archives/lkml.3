Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaIWWPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:15:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbaIWWPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:15:04 -0400
Message-ID: <1411510450.24563.44.camel@ul30vt.home>
Subject: Re: [PATCHv7 01/26] iommu/arm-smmu: change IOMMU_EXEC to
 IOMMU_NOEXEC
From: Alex Williamson <alex.williamson@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Thierry Reding <treding@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 23 Sep 2014 16:14:10 -0600
In-Reply-To: <20140923145816.GE28608@arm.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1411483586-29304-2-git-send-email-a.motakis@virtualopensystems.com>
	 <20140923145816.GE28608@arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 15:58 +0100, Will Deacon wrote:
> Hi Antonios,
> 
> On Tue, Sep 23, 2014 at 03:46:00PM +0100, Antonios Motakis wrote:
> > Exposing the XN flag of the SMMU driver as IOMMU_NOEXEC instead of
> > IOMMU_EXEC makes it enforceable, since for IOMMUs that don't support
> > the XN flag pages will always be executable.
> > 
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > ---
> >  drivers/iommu/arm-smmu.c | 9 +++++----
> >  include/linux/iommu.h    | 2 +-
> >  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> [...]
> 
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index 20f9a52..e1a644c 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -27,7 +27,7 @@
> >  #define IOMMU_READ	(1 << 0)
> >  #define IOMMU_WRITE	(1 << 1)
> >  #define IOMMU_CACHE	(1 << 2) /* DMA cache coherency */
> > -#define IOMMU_EXEC	(1 << 3)
> > +#define IOMMU_NOEXEC	(1 << 3)
> 
> This hunk needs to be a separate patch merged by Joerg before I can take the
> arm-smmu part (which looks fine).

That separate hunk would be unbuildable since arm-smmu depends on the
IOMMU_EXEC define.  Patch 2/ is also in iommu code and gates patch 3/ in
arm-smmu.  The IOMMU-core changes are pretty trivial, so perhaps Joerg
would be willing to ACK 1&2 and let Will include the first 3 patches
through his tree.

These first 3 patches should have been sent on their own since they're
small an obvious so they don't get hung up on the reset of the series.
Thanks,

Alex

