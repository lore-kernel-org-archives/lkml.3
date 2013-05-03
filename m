Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763262Ab3ECLgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:36:37 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:46046 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762367Ab3ECLgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:36:36 -0400
Message-ID: <5183A137.4060808@linux.vnet.ibm.com>
Date: Fri, 03 May 2013 19:36:23 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] mm: soft-dirty bits for user memory changes tracking
References: <517FED13.8090806@parallels.com> <517FED64.4020400@parallels.com>
In-Reply-To: <517FED64.4020400@parallels.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050311-8256-0000-0000-000007525EFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 12:12 AM, Pavel Emelyanov wrote:

> +static inline void clear_soft_dirty(struct vm_area_struct *vma,
> +		unsigned long addr, pte_t *pte)
> +{
> +#ifdef CONFIG_MEM_SOFT_DIRTY
> +	/*
> +	 * The soft-dirty tracker uses #PF-s to catch writes
> +	 * to pages, so write-protect the pte as well. See the
> +	 * Documentation/vm/soft-dirty.txt for full description
> +	 * of how soft-dirty works.
> +	 */
> +	pte_t ptent = *pte;
> +	ptent = pte_wrprotect(ptent);
> +	ptent = pte_clear_flags(ptent, _PAGE_SOFT_DIRTY);
> +	set_pte_at(vma->vm_mm, addr, pte, ptent);
> +#endif

It seems that TLBs are not flushed and mmu-notification is not called?

