Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3JHAv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:51:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3JHAv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:51:27 -0400
Date: Mon, 7 Oct 2013 17:51:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] smaps: show VM_SOFTDIRTY flag in VmFlags line
Message-Id: <20131007175125.7bb300853d37b6a64eba248d@linux-foundation.org>
In-Reply-To: <1381155304-2ro6e10t-mutt-n-horiguchi@ah.jp.nec.com>
References: <1380913335-17466-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<5252B56C.8030903@parallels.com>
	<1381155304-2ro6e10t-mutt-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Oct 2013 10:15:04 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Fri, 4 Oct 2013 13:42:13 -0400
> Subject: [PATCH] smaps: show VM_SOFTDIRTY flag in VmFlags line
> 
> This flag shows that the VMA is "newly created" and thus represents
> "dirty" in the task's VM.
> You can clear it by "echo 4 > /proc/pid/clear_refs."
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  fs/proc/task_mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 7366e9d..c591928 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -561,6 +561,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  		[ilog2(VM_NONLINEAR)]	= "nl",
>  		[ilog2(VM_ARCH_1)]	= "ar",
>  		[ilog2(VM_DONTDUMP)]	= "dd",
> +#ifdef CONFIG_MEM_SOFT_DIRTY
> +		[ilog2(VM_SOFTDIRTY)]	= "sd",
> +#endif
>  		[ilog2(VM_MIXEDMAP)]	= "mm",
>  		[ilog2(VM_HUGEPAGE)]	= "hg",
>  		[ilog2(VM_NOHUGEPAGE)]	= "nh",

Documentation/filesystems/proc.txt needs updating, please.
