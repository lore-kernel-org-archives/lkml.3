Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab3FQIRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:17:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3FQIRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:17:19 -0400
Date: Mon, 17 Jun 2013 10:17:16 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] mm/page_alloc: fix doc for numa_zonelist_order
Message-ID: <20130617081716.GB19194@dhcp22.suse.cz>
References: <1371345290-19588-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371345290-19588-5-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371345290-19588-5-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 16-06-13 09:14:48, Wanpeng Li wrote:
> The default zonelist order selecter will select "node" order if any node's
> DMA zone comprises greater than 70% of its local memory instead of 60%,
> according to default_zonelist_order::low_kmem_size > total * 70/100.

Hmm, interesting. This comment has been incorrect since f0c0b2b808
(change zonelist order: zonelist order selection logic).
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  Documentation/sysctl/vm.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index a5717c3..15d341a 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -531,7 +531,7 @@ Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
>  will select "node" order in following case.
>  (1) if the DMA zone does not exist or
>  (2) if the DMA zone comprises greater than 50% of the available memory or
> -(3) if any node's DMA zone comprises greater than 60% of its local memory and
> +(3) if any node's DMA zone comprises greater than 70% of its local memory and
>      the amount of local memory is big enough.
>  
>  Otherwise, "zone" order will be selected. Default order is recommended unless
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
