Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaKFMmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:42:52 -0500
Received: from 8bytes.org ([81.169.241.247]:49039 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaKFMmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:42:50 -0500
Date: Thu, 6 Nov 2014 13:42:48 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oded.Gabbay@amd.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH] iommu/amd: Use new invalidate_range mmu-notifier
Message-ID: <20141106124248.GM10744@8bytes.org>
References: <1415277608-23688-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415277608-23688-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew,

On Thu, Nov 06, 2014 at 01:40:08PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Make use of the new invalidate_range mmu_notifier call-back
> and remove the old logic of assigning an empty page-table
> between invalidate_range_start and invalidate_range_end.
> 
> Tested-by: Oded Gabbay <oded.gabbay@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/amd_iommu_v2.c | 61 +++++++-------------------------------------
>  1 file changed, 9 insertions(+), 52 deletions(-)

This patch depends on the mmu_notifier_invalidate_range patches in your
mm-tree. It converts the AMD IOMMUv2 driver to make use of it and is
tested by AMD. Can you please carry this patch in the mm-tree too?

Thanks,

	Joerg

