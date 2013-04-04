Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3DDAnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:43:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45082 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761851Ab3DDAnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:43:07 -0400
Message-ID: <515CCC8C.5030007@jp.fujitsu.com>
Date: Thu, 04 Apr 2013 09:42:52 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] fix hugetlb memory check in vma_dump_size()
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1365014138-19589-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1365014138-19589-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/04 3:35), Naoya Horiguchi wrote:
> Documentation/filesystems/proc.txt says about coredump_filter bitmask,
> 
>    Note bit 0-4 doesn't effect any hugetlb memory. hugetlb memory are only
>    effected by bit 5-6.
> 
> However current code can go into the subsequent flag checks of bit 0-4
> for vma(VM_HUGETLB). So this patch inserts 'return' and makes it work
> as written in the document.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: stable@vger.kernel.org
> ---
>   fs/binfmt_elf.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git v3.9-rc3.orig/fs/binfmt_elf.c v3.9-rc3/fs/binfmt_elf.c
> index 3939829..86af964 100644
> --- v3.9-rc3.orig/fs/binfmt_elf.c
> +++ v3.9-rc3/fs/binfmt_elf.c
> @@ -1137,6 +1137,7 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
>   			goto whole;
>   		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
>   			goto whole;
> +		return 0;
>   	}
>   
>   	/* Do not dump I/O mapped devices or special mappings */
> 

Thanks for splitting this fix. Now it's easier to keep track of this fix.

Reviewed-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>

Thanks.
HATAYAMA, Daisuke


