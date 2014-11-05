Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaKEJu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:50:27 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:65400 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaKEJuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:50:21 -0500
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:c0ab:7493:ff17:bb99]
In-Reply-To: <1414785851.27420.334.camel@ul30vt.home>
References: <1414433155-31600-1-git-send-email-a.motakis@virtualopensystems.com>
 <1414433155-31600-2-git-send-email-a.motakis@virtualopensystems.com> <1414785851.27420.334.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 5 Nov 2014 10:49:58 +0100
Message-ID: <CAG8rG2wtZeXiGzG7+QJDe7xF2EdCfDDd_b8e4Ge_pGhDvLHu9Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] vfio: implement iommu driver capabilities with an enum
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 9:04 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Mon, 2014-10-27 at 19:05 +0100, Antonios Motakis wrote:
> > Currently a VFIO driver's IOMMU capabilities are encoded as a series of
> > numerical defines. Replace this with an enum for future maintainability.
> >
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > ---
> >  include/uapi/linux/vfio.h | 21 ++++++++++-----------
> >  1 file changed, 10 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 6612974..1e39842 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -19,19 +19,18 @@
> >
> >  /* Kernel & User level defines for VFIO IOCTLs. */
> >
> > -/* Extensions */
> > -
> > -#define VFIO_TYPE1_IOMMU             1
> > -#define VFIO_SPAPR_TCE_IOMMU         2
> > -#define VFIO_TYPE1v2_IOMMU           3
> >  /*
> > - * IOMMU enforces DMA cache coherence (ex. PCIe NoSnoop stripping).  This
> > - * capability is subject to change as groups are added or removed.
> > + * Capabilities exposed by the VFIO IOMMU driver. Some capabilities are subject
> > + * to change as groups are added or removed.
> >   */
> > -#define VFIO_DMA_CC_IOMMU            4
> > -
> > -/* Check if EEH is supported */
> > -#define VFIO_EEH                     5
> > +enum vfio_iommu_cap {
> > +     VFIO_TYPE1_IOMMU        = 1,
> > +     VFIO_SPAPR_TCE_IOMMU    = 2,
> > +     VFIO_TYPE1v2_IOMMU      = 3,
> > +     VFIO_DMA_CC_IOMMU       = 4, /* IOMMU enforces DMA cache coherence
> > +                                     (ex. PCIe NoSnoop stripping) */
> > +     VFIO_EEH                = 5, /* Check if EEH is supported */
> > +};
>
> Your code base is a little out of date, you're missing:
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/include/uapi/linux/vfio.h?id=f5c9ecebaf2a2c9381973798e389cc019dd983e0
>
> I think the logic looks ok in the rest, but you'll need to use index 7
> and the above commit touched the type1 c file as well so you may need to
> adjustment there too.  Thanks,

Hello,

I will reapply on the latest version then.

Thanks

>
> Alex
> >
> >  /*
> >   * The IOCTL interface is designed for extensibility by embedding the
>
>
>
