Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaHMHZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:25:55 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34879 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHMHZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <1407913728-13095-1-git-send-email-vishnu.ps@samsung.com>
References: <1407913728-13095-1-git-send-email-vishnu.ps@samsung.com>
Date: Wed, 13 Aug 2014 09:25:53 +0200
Message-ID: <CAFLxGvy+iMV08aUqP_F+1eDCu+XCT1=w6TgawMfXjmkvgB9_1A@mail.gmail.com>
Subject: Re: [PATCH] Fix checkpatch error's for mm/mmap.c
From: Richard Weinberger <richard.weinberger@gmail.com>
To: "vishnu.ps" <vishnu.ps@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        walken@google.com, jmarchan@redhat.com, davidlohr@hp.com,
        Sasha Levin <sasha.levin@oracle.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, dh.herrmann@gmail.com,
        mitchelh@codeaurora.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, cpgs@samsung.com,
        "pintu.k@samsung.com" <pintu.k@samsung.com>, vishu13285@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 9:08 AM, vishnu.ps <vishnu.ps@samsung.com> wrote:
> From: "vishnu.ps" <vishnu.ps@samsung.com>
>
> Signed-off-by: vishnu.ps <vishnu.ps@samsung.com>
> ---
>  mm/mmap.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)

Please don't run checkpatch.pl on in-kernel files.
The tool is designed to check patches, not files.
Such whitespace cleanups pollute the kernel history, i.e. such that
git blame returns false positives.

The purpose of --file is:
- Checking out-of-tree files (like existing drivers to be imported)
- One notable exception is drivers/staging/, you can run it on these files.

Besides of that, your patch description is too sloppy.
Please see Documentation/SubmittingPatches "2) Describe your changes."

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 80217c9..5cce169 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -70,7 +70,7 @@ static void unmap_region(struct mm_struct *mm,
>   * MAP_SHARED  r: (no) no      r: (yes) yes    r: (no) yes     r: (no) yes
>   *             w: (no) no      w: (no) no      w: (yes) yes    w: (no) no
>   *             x: (no) no      x: (no) yes     x: (no) yes     x: (yes) yes
> - *
> + *
>   * MAP_PRIVATE r: (no) no      r: (yes) yes    r: (no) yes     r: (no) yes
>   *             w: (no) no      w: (no) no      w: (copy) copy  w: (no) no
>   *             x: (no) no      x: (no) yes     x: (no) yes     x: (yes) yes
> @@ -741,7 +741,7 @@ again:                      remove_next = 1 + (end > next->vm_end);
>                          * split_vma inserting another: so it must be
>                          * mprotect case 4 shifting the boundary down.
>                          */
> -                       adjust_next = - ((vma->vm_end - end) >> PAGE_SHIFT);
> +                       adjust_next = -((vma->vm_end - end) >> PAGE_SHIFT);
>                         exporter = vma;
>                         importer = next;
>                 }
> @@ -1010,7 +1010,7 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
>  struct vm_area_struct *vma_merge(struct mm_struct *mm,
>                         struct vm_area_struct *prev, unsigned long addr,
>                         unsigned long end, unsigned long vm_flags,
> -                       struct anon_vma *anon_vma, struct file *file,
> +                       struct anon_vma *anon_vma, struct file *file,
>                         pgoff_t pgoff, struct mempolicy *policy)
>  {
>         pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
> @@ -1036,7 +1036,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>          * Can it merge with the predecessor?
>          */
>         if (prev && prev->vm_end == addr &&
> -                       mpol_equal(vma_policy(prev), policy) &&
> +                       mpol_equal(vma_policy(prev), policy) &&
>                         can_vma_merge_after(prev, vm_flags,
>                                                 anon_vma, file, pgoff)) {
>                 /*
> @@ -1064,7 +1064,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>          * Can this new request be merged in front of next?
>          */
>         if (next && end == next->vm_start &&
> -                       mpol_equal(policy, vma_policy(next)) &&
> +                       mpol_equal(policy, vma_policy(next)) &&
>                         can_vma_merge_before(next, vm_flags,
>                                         anon_vma, file, pgoff+pglen)) {
>                 if (prev && addr < prev->vm_end)        /* case 4 */
> @@ -1235,7 +1235,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>                         unsigned long flags, unsigned long pgoff,
>                         unsigned long *populate)
>  {
> -       struct mm_struct * mm = current->mm;
> +       struct mm_struct *mm = current->mm;
>         vm_flags_t vm_flags;
>
>         *populate = 0;
> @@ -1263,7 +1263,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>
>         /* offset overflow? */
>         if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
> -               return -EOVERFLOW;
> +               return -EOVERFLOW;
>
>         /* Too many mappings? */
>         if (mm->map_count > sysctl_max_map_count)
> @@ -1921,7 +1921,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
>         info.align_mask = 0;
>         return vm_unmapped_area(&info);
>  }
> -#endif
> +#endif
>
>  /*
>   * This mmap-allocator allocates new areas top-down from below the
> @@ -2321,13 +2321,13 @@ int expand_stack(struct vm_area_struct *vma, unsigned long address)
>  }
>
>  struct vm_area_struct *
> -find_extend_vma(struct mm_struct * mm, unsigned long addr)
> +find_extend_vma(struct mm_struct *mm, unsigned long addr)
>  {
> -       struct vm_area_struct * vma;
> +       struct vm_area_struct *vma;
>         unsigned long start;
>
>         addr &= PAGE_MASK;
> -       vma = find_vma(mm,addr);
> +       vma = find_vma(mm, addr);
>         if (!vma)
>                 return NULL;
>         if (vma->vm_start <= addr)
> @@ -2376,7 +2376,7 @@ static void unmap_region(struct mm_struct *mm,
>                 struct vm_area_struct *vma, struct vm_area_struct *prev,
>                 unsigned long start, unsigned long end)
>  {
> -       struct vm_area_struct *next = prev? prev->vm_next: mm->mmap;
> +       struct vm_area_struct *next = prev ? prev->vm_next : mm->mmap;
>         struct mmu_gather tlb;
>
>         lru_add_drain();
> @@ -2423,7 +2423,7 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
>   * __split_vma() bypasses sysctl_max_map_count checking.  We use this on the
>   * munmap path where it doesn't make sense to fail.
>   */
> -static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
> +static int __split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
>               unsigned long addr, int new_below)
>  {
>         struct vm_area_struct *new;
> @@ -2512,7 +2512,8 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
>         if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
>                 return -EINVAL;
>
> -       if ((len = PAGE_ALIGN(len)) == 0)
> +       len = PAGE_ALIGN(len);
> +       if (len == 0)
>                 return -EINVAL;
>
>         /* Find the first overlapping VMA */
> @@ -2558,7 +2559,7 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
>                 if (error)
>                         return error;
>         }
> -       vma = prev? prev->vm_next: mm->mmap;
> +       vma = prev ? prev->vm_next : mm->mmap;
>
>         /*
>          * unlock any mlock()ed ranges before detaching vmas
> @@ -2690,10 +2691,10 @@ static inline void verify_mm_writelocked(struct mm_struct *mm)
>   */
>  static unsigned long do_brk(unsigned long addr, unsigned long len)
>  {
> -       struct mm_struct * mm = current->mm;
> -       struct vm_area_struct * vma, * prev;
> +       struct mm_struct *mm = current->mm;
> +       struct vm_area_struct *vma, *prev;
>         unsigned long flags;
> -       struct rb_node ** rb_link, * rb_parent;
> +       struct rb_node **rb_link, *rb_parent;
>         pgoff_t pgoff = addr >> PAGE_SHIFT;
>         int error;
>
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
