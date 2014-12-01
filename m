Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaLAXR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:17:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:52861 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbaLAXR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:17:58 -0500
Message-ID: <1417473849.7182.9.camel@kernel.crashing.org>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to
 p[te|md]_protnone_numa
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 02 Dec 2014 09:44:09 +1100
In-Reply-To: <1416578268-19597-4-git-send-email-mgorman@suse.de>
References: <1416578268-19597-1-git-send-email-mgorman@suse.de>
	 <1416578268-19597-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 13:57 +0000, Mel Gorman wrote:
> void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
>                 pte_t pte)
>  {
> -#ifdef CONFIG_DEBUG_VM
> -       WARN_ON(pte_val(*ptep) & _PAGE_PRESENT);
> -#endif
> +       /*
> +        * When handling numa faults, we already have the pte marked
> +        * _PAGE_PRESENT, but we can be sure that it is not in hpte.
> +        * Hence we can use set_pte_at for them.
> +        */
> +       VM_WARN_ON((pte_val(*ptep) & (_PAGE_PRESENT | _PAGE_USER)) ==
> +               (_PAGE_PRESENT | _PAGE_USER));
> +

His is that going to fare with set_pte_at() called for kernel pages ?

Cheers,
Ben.


