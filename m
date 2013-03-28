Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3C1RDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:03:25 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:56909 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3C1RDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:03:21 -0400
Message-ID: <515477D4.1060206@openvz.org>
Date: Thu, 28 Mar 2013 21:03:16 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hugetlbfs: stop setting VM_DONTDUMP in initializing
 vma(VM_HUGETLB)
References: <1364485358-8745-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1364485358-8745-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1364485358-8745-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi wrote:
> Currently we fail to include any data on hugepages into coredump,
> because VM_DONTDUMP is set on hugetlbfs's vma. This behavior was recently
> introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
> mm->reserved_vm counter". This looks to me a serious regression,
> so let's fix it.

That was introduced in my patch? Really?
Here was VM_RESERVED and it had the same effect as VM_DONTDUMP. At least I thought so.

>
> Signed-off-by: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>
> Cc: Konstantin Khlebnikov<khlebnikov@openvz.org>
> ---
>   fs/hugetlbfs/inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git v3.9-rc3.orig/fs/hugetlbfs/inode.c v3.9-rc3/fs/hugetlbfs/inode.c
> index 84e3d85..523464e 100644
> --- v3.9-rc3.orig/fs/hugetlbfs/inode.c
> +++ v3.9-rc3/fs/hugetlbfs/inode.c
> @@ -110,7 +110,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
>   	 * way when do_mmap_pgoff unwinds (may be important on powerpc
>   	 * and ia64).
>   	 */
> -	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND | VM_DONTDUMP;
> +	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
>   	vma->vm_ops =&hugetlb_vm_ops;
>
>   	if (vma->vm_pgoff&  (~huge_page_mask(h)>>  PAGE_SHIFT))

