Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaCaK2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:28:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbaCaK2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:28:14 -0400
Date: Sat, 29 Mar 2014 17:22:16 +0100
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 03/22] axonram: Fix bug in direct_access
Message-ID: <20140329162216.GC1211@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <e3ede380dd37d3cae604ee20198e568c9eb4fa00.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3ede380dd37d3cae604ee20198e568c9eb4fa00.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-03-14 15:08:29, Matthew Wilcox wrote:
> The 'pfn' returned by axonram was completely bogus, and has been since
> 2008.
  Maybe time to drop the driver instead? When noone noticed for 6 years, it
seems pretty much dead... Or is there some possibility the driver can get
reused for new HW?

  Anyway the patch looks correct so feel free to add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> ---
>  arch/powerpc/sysdev/axonram.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
> index 47b6b9f..830edc8 100644
> --- a/arch/powerpc/sysdev/axonram.c
> +++ b/arch/powerpc/sysdev/axonram.c
> @@ -156,7 +156,7 @@ axon_ram_direct_access(struct block_device *device, sector_t sector,
>  	}
>  
>  	*kaddr = (void *)(bank->ph_addr + offset);
> -	*pfn = virt_to_phys(kaddr) >> PAGE_SHIFT;
> +	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
>  
>  	return 0;
>  }
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
