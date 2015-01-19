Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbbASOEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:04:05 -0500
Received: from 8bytes.org ([81.169.241.247]:58156 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbbASOED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:04:03 -0500
Date: Mon, 19 Jan 2015 15:04:01 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: fix trace_unmap() to report original iova
Message-ID: <20150119140400.GN6343@8bytes.org>
References: <1421452039-7646-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421452039-7646-1-git-send-email-shuahkh@osg.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 04:47:19PM -0700, Shuah Khan wrote:
> iommu_unmap() calls trace_unmap() with changed iova and original
> size. trace_unmap() should report original iova instead. Change
> iommu_unmap() to call trace_unmap() with original iova.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/iommu/iommu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index fbf8827..2eb7554 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1094,6 +1094,7 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
>  {
>  	size_t unmapped_page, unmapped = 0;
>  	unsigned int min_pagesz;
> +	unsigned long orig_iova = iova;

Instead of adding another variable I think it is better to just move the
trace_unmap call before the unmap loop. It can actually replace the
pr_debug there.


	Joerg

