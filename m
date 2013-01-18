Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab3ARVjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:39:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ARVjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:39:03 -0500
Date: Fri, 18 Jan 2013 13:39:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Define set_pmd_at for numabalance for
 CONFIG_PARAVIRT
Message-Id: <20130118133901.b445b348.akpm@linux-foundation.org>
In-Reply-To: <1358501604-6797-1-git-send-email-mhocko@suse.cz>
References: <1358501604-6797-1-git-send-email-mhocko@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013 10:33:24 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> CONFIG_PARAVIRT defines set_pmd_at only for CONFIG_TRANSPARENT_HUGEPAGE
> which leads to the following compile errors when randconfig selected
> CONFIG_NUMA_BALANCING && CONFIG_PARAVIRT && !CONFIG_TRANSPARENT_HUGEPAGE:
> 
> mm/mprotect.c: In function ___change_pmd_protnuma___:
> mm/mprotect.c:120: error: implicit declaration of function ___set_pmd_at___
> 
> mm/memory.c: In function ___do_pmd_numa_page___:
> mm/memory.c:3529: error: implicit declaration of function ___set_pmd_at___
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  arch/x86/include/asm/paravirt.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index a0facf3..f551e89 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -528,7 +528,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
>  		PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pte.pte);
>  }
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_NUMA_BALANCING)
>  static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
>  			      pmd_t *pmdp, pmd_t pmd)
>  {

Confused - there is no "#ifdef CONFIG_TRANSPARENT_HUGEPAGE" in there in
any kernel version I can think of.

