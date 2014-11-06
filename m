Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaKFS4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:56:03 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49001 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaKFSz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:55:59 -0500
MIME-Version: 1.0
In-Reply-To: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
Date: Thu, 6 Nov 2014 22:55:58 +0400
Message-ID: <CALYGNiO85ts2J_c8fiYHGDe5gEhb4QMB_HAsST3opdwumUptFg@mail.gmail.com>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2014 at 6:15 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Memory cgroups used to have 5 per-page pointers.  To allow users to
> disable that amount of overhead during runtime, those pointers were
> allocated in a separate array, with a translation layer between them
> and struct page.
>
> There is now only one page pointer remaining: the memcg pointer, that
> indicates which cgroup the page is associated with when charged.  The
> complexity of runtime allocation and the runtime translation overhead
> is no longer justified to save that *potential* 0.19% of memory.  With
> CONFIG_SLUB, page->mem_cgroup actually sits in the doubleword padding
> after the page->private member and doesn't even increase struct page,
> and then this patch actually saves space.  Remaining users that care
> can still compile their kernels without CONFIG_MEMCG.
>
>    text    data     bss     dec     hex     filename
> 8828345 1725264  983040 11536649 b00909  vmlinux.old
> 8827425 1725264  966656 11519345 afc571  vmlinux.new
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Great! Never thought I'd see this. =)

Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>


> ---
>  include/linux/memcontrol.h  |   6 +-
>  include/linux/mm_types.h    |   5 +
>  include/linux/mmzone.h      |  12 --
>  include/linux/page_cgroup.h |  53 --------
>  init/main.c                 |   7 -
>  mm/memcontrol.c             | 124 +++++------------
>  mm/page_alloc.c             |   2 -
>  mm/page_cgroup.c            | 319 --------------------------------------------
>  8 files changed, 41 insertions(+), 487 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index d4575a1d6e99..dafba59b31b4 100644



> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
