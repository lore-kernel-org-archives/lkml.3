Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3EYLWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 07:22:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42255 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3EYLWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 07:22:06 -0400
Date: Sat, 25 May 2013 07:21:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vfio: type1 iommu hugepage support
Message-ID: <20130525112153.GD2418@localhost.localdomain>
References: <20130524171613.14229.84050.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524171613.14229.84050.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 11:24:26AM -0600, Alex Williamson wrote:
> This series let's the vfio type1 iommu backend take advantage of iommu
> large page support.  See patch 2/2 for the details.  This has been
> tested on both amd_iommu and intel_iommu, but only my AMD system has
> large page support.  I'd appreciate any testing and feedback on other
> systems, particularly vt-d systems supporting large pages.  Mapping
> efficiency should be improved a bit without iommu hugepages, but I
> hope that it's much more noticeable with huge pages, especially for
> very large QEMU guests.

I took a very very quick look - and I am wondering if there should also
be a flag to turn it on/off in ther kernel in such case? Especially in the 
field if a user finds out that their particular IOMMU chipset might
be doing something funky with large-pages ?

> 
> This change includes a clarification to the mapping expectations for
> users of the type1 iommu, but is compatible with known users and works
> with existing QEMU userspace supporting vfio.  Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (2):
>       vfio: Convert type1 iommu to use rbtree
>       vfio: hugepage support for vfio_iommu_type1
> 
> 
>  drivers/vfio/vfio_iommu_type1.c |  607 ++++++++++++++++++++++++---------------
>  include/uapi/linux/vfio.h       |    8 -
>  2 files changed, 387 insertions(+), 228 deletions(-)
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
