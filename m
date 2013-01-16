Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3APXTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:19:07 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51370 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3APXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:19:04 -0500
Date: Wed, 16 Jan 2013 15:18:57 -0800
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Subhash Jadavani <subhashj@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, martin.petersen@oracle.com,
        asias@redhat.com, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with
 non-contiguous descriptors
Message-ID: <20130116231857.GU2668@htj.dyndns.org>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org>
 <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com>
 <50F64AC1.3040304@codeaurora.org>
 <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:32:35AM +0000, James Bottomley wrote:
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 6b2fb87..ab88c5b 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -809,7 +809,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
>  			op(vaddr, len, dir);
>  		}
>  		offset = 0;
> -		page++;
> +		page = pfn_to_page(page_to_pfn(page) + 1);

Probably page = nth_page(page, 1) is the better form.

Thanks.

-- 
tejun
