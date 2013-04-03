Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763366Ab3DCVOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 17:14:12 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34376 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759074Ab3DCVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 17:14:11 -0400
Date: Wed, 3 Apr 2013 23:14:06 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] fix hugetlb memory check in vma_dump_size()
Message-ID: <20130403211354.GA27611@dhcp22.suse.cz>
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1365014138-19589-3-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365014138-19589-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-04-13 14:35:37, Naoya Horiguchi wrote:
> Documentation/filesystems/proc.txt says about coredump_filter bitmask,
> 
>   Note bit 0-4 doesn't effect any hugetlb memory. hugetlb memory are only
>   effected by bit 5-6.
> 
> However current code can go into the subsequent flag checks of bit 0-4
> for vma(VM_HUGETLB). So this patch inserts 'return' and makes it work
> as written in the document.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: stable@vger.kernel.org

Just for the record. It should be stable for 3.7+ since (314e51b98)
becuase then have lost VM_RESERVED check which used to stop hugetlb
mappings.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  fs/binfmt_elf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git v3.9-rc3.orig/fs/binfmt_elf.c v3.9-rc3/fs/binfmt_elf.c
> index 3939829..86af964 100644
> --- v3.9-rc3.orig/fs/binfmt_elf.c
> +++ v3.9-rc3/fs/binfmt_elf.c
> @@ -1137,6 +1137,7 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
>  			goto whole;
>  		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
>  			goto whole;
> +		return 0;
>  	}
>  
>  	/* Do not dump I/O mapped devices or special mappings */
> -- 
> 1.7.11.7
> 

-- 
Michal Hocko
SUSE Labs
