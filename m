Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbbASQpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:45:13 -0500
Received: from lists.s-osg.org ([54.187.51.154]:53320 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbbASQpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:45:12 -0500
Message-ID: <54BD3495.7070501@osg.samsung.com>
Date: Mon, 19 Jan 2015 09:45:09 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: joro@8bytes.org, alex.williamson@redhat.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: fix trace_map() to report original iova and original
 size
References: <1421375383-8930-1-git-send-email-shuahkh@osg.samsung.com>
In-Reply-To: <1421375383-8930-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 07:29 PM, Shuah Khan wrote:
> iommu_map() calls trace_map() with iova and size. trace_map()
> should report original iova and original size as opposed to
> iova and size after they get changed during mapping. size is
> always zero at the end of mapping which is useless to report
> and iova as it gets incremented, it is not as useful as the
> original iova. Change iommu_map() to call trace_map() to
> report original iova and original size.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/iommu/iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index f7718d7..fbf8827 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1084,7 +1084,7 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
>  	if (ret)
>  		iommu_unmap(domain, orig_iova, orig_size - size);
>  	else
> -		trace_map(iova, paddr, size);
> +		trace_map(orig_iova, paddr, orig_size);
>  
>  	return ret;
>  }
> 


Joerg,

Just makeing sure you saw this as well. I saw your responses on the
trace_unmap() patches that you pulled them in.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
