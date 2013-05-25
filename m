Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3EYOkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 10:40:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab3EYOkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 10:40:10 -0400
Message-ID: <1369492793.2646.164.camel@ul30vt.home>
Subject: Re: [PATCH 0/2] vfio: type1 iommu hugepage support
From: Alex Williamson <alex.williamson@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 25 May 2013 08:39:53 -0600
In-Reply-To: <20130525112153.GD2418@localhost.localdomain>
References: <20130524171613.14229.84050.stgit@bling.home>
	 <20130525112153.GD2418@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-25 at 07:21 -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, May 24, 2013 at 11:24:26AM -0600, Alex Williamson wrote:
> > This series let's the vfio type1 iommu backend take advantage of iommu
> > large page support.  See patch 2/2 for the details.  This has been
> > tested on both amd_iommu and intel_iommu, but only my AMD system has
> > large page support.  I'd appreciate any testing and feedback on other
> > systems, particularly vt-d systems supporting large pages.  Mapping
> > efficiency should be improved a bit without iommu hugepages, but I
> > hope that it's much more noticeable with huge pages, especially for
> > very large QEMU guests.
> 
> I took a very very quick look - and I am wondering if there should also
> be a flag to turn it on/off in ther kernel in such case? Especially in the 
> field if a user finds out that their particular IOMMU chipset might
> be doing something funky with large-pages ?

Yeah, that's probably a reasonable feature.  intel-iommu has a boot
option to disable superpages, but we could make it more consistent at
the vfio level if we have a switch there.  It could provided interesting
performance and debugging info.  I'll add a module option to do this.
Thanks,

Alex
 
> > This change includes a clarification to the mapping expectations for
> > users of the type1 iommu, but is compatible with known users and works
> > with existing QEMU userspace supporting vfio.  Thanks,
> > 
> > Alex
> > 
> > ---
> > 
> > Alex Williamson (2):
> >       vfio: Convert type1 iommu to use rbtree
> >       vfio: hugepage support for vfio_iommu_type1
> > 
> > 
> >  drivers/vfio/vfio_iommu_type1.c |  607 ++++++++++++++++++++++++---------------
> >  include/uapi/linux/vfio.h       |    8 -
> >  2 files changed, 387 insertions(+), 228 deletions(-)
> > _______________________________________________
> > iommu mailing list
> > iommu@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/iommu



