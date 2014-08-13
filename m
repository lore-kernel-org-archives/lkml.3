Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaHMJgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:36:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaHMJgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:36:15 -0400
Date: Wed, 13 Aug 2014 11:36:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] x86,mm: check freeze request in page fault handler
Message-ID: <20140813093613.GB2775@dhcp22.suse.cz>
References: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
 <1407804835-24763-2-git-send-email-xiyou.wangcong@gmail.com>
 <20140812120905.GB7049@dhcp22.suse.cz>
 <CAM_iQpWV8DRGBQ-Brz=_Nqen0fNPDk+6kn_Og3HnXnujmgA+JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWV8DRGBQ-Brz=_Nqen0fNPDk+6kn_Og3HnXnujmgA+JA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-08-14 17:47:02, Cong Wang wrote:
[...]
> Does the following updated patch make any sense to you? If not, I will just
> drop it.

Not really to be honest. I do not see what problem you are trying to fix.

> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index a241946..8c0a7d8 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -14,6 +14,7 @@
>  #include <linux/hugetlb.h>             /* hstate_index_to_shift        */
>  #include <linux/prefetch.h>            /* prefetchw                    */
>  #include <linux/context_tracking.h>    /* exception_enter(), ...       */
> +#include <linux/freezer.h>             /* try_to_freeze()              */
> 
>  #include <asm/traps.h>                 /* dotraplinkage, ...           */
>  #include <asm/pgalloc.h>               /* pgd_*(), ...                 */
> @@ -904,6 +905,9 @@ mm_fault_error(struct pt_regs *regs, unsigned long
> error_code,
>                  * oom-killed):
>                  */
>                 pagefault_out_of_memory();
> +
> +               if (signal_pending(current))
> +                       try_to_freeze();
>         } else {
>                 if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
>                              VM_FAULT_HWPOISON_LARGE))

-- 
Michal Hocko
SUSE Labs
