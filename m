Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaKELRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:17:01 -0500
Received: from 8bytes.org ([81.169.241.247]:40691 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbaKELQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:16:58 -0500
Date: Wed, 5 Nov 2014 12:16:56 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olav Haugan <ohaugan@codeaurora.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the iommu tree
Message-ID: <20141105111656.GJ10744@8bytes.org>
References: <20141105134731.799a1a3d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105134731.799a1a3d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 01:47:31PM +1100, Stephen Rothwell wrote:
> Hi Joerg,
> 
> After merging the iommu tree, today's linux-next build (powerpc
> pc64_defconfig) failed like this:
> 
> In file included from arch/powerpc/platforms/powernv/pci.c:33:0:
> arch/powerpc/include/asm/iommu.h:140:12: error: conflicting types for 'iommu_map_sg'
>  extern int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
>             ^
> In file included from arch/powerpc/platforms/powernv/pci.c:23:0:
> include/linux/iommu.h:311:22: note: previous definition of 'iommu_map_sg' was here
>  static inline size_t iommu_map_sg(struct iommu_domain *domain,
>                       ^
> 
> Caused by commit 315786ebbf4a ("iommu: Add iommu_map_sg() function").
> Grep is your friend ...
> 
> I have used the iommu tree from next-20141104 for today.

Thanks Stephen, I exluded the my core branch from next for now until the
issue is fixed.


	Joerg

