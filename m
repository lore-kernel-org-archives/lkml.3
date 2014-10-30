Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbaJ3I42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:56:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbaJ3I40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:56:26 -0400
Date: Thu, 30 Oct 2014 09:56:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thierry Reding <treding@nvidia.com>, Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] mm-cma-make-kmemleak-ignore-cma-regions-fix
Message-ID: <20141030085623.GC4664@dhcp22.suse.cz>
References: <54515a25.46WrYSce5BExT3V4%akpm@linux-foundation.org>
 <1414658824-16480-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414658824-16480-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-10-14 09:47:04, Michal Hocko wrote:
> include linux/io.h to get phys_to_virt declaration and fix the following
> compile error:
> mm/cma.c:288:4: error: implicit declaration of function ‘phys_to_virt’ [-Werror=implicit-function-declaration]
>     kmemleak_ignore(phys_to_virt(addr));

Ohh, skip this. It seems that this has been merged into
mm-cma-make-kmemleak-ignore-cma-regions.patch already. Just my scripts
haven't noticed.

Sorry about the noise.

> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/cma.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 9bc687a20495..daec407d1057 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -33,6 +33,7 @@
>  #include <linux/log2.h>
>  #include <linux/cma.h>
>  #include <linux/highmem.h>
> +#include <linux/io.h>
>  
>  struct cma {
>  	unsigned long	base_pfn;
> -- 
> 2.1.1
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
