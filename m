Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaAaWw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:52:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaAaWw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:52:26 -0500
Date: Fri, 31 Jan 2014 14:52:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] Revert
 "thp: make MADV_HUGEPAGE check for mm->def_flags"
Message-Id: <20140131145224.7f8efc67d882a2e1a89b0778@linux-foundation.org>
In-Reply-To: <1391192628-113858-3-git-send-email-athorlton@sgi.com>
References: <1391192628-113858-1-git-send-email-athorlton@sgi.com>
	<1391192628-113858-3-git-send-email-athorlton@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 12:23:43 -0600 Alex Thorlton <athorlton@sgi.com> wrote:

> This reverts commit 8e72033f2a489b6c98c4e3c7cc281b1afd6cb85cm, and adds

'm' is not a hex digit ;)

> in code to fix up any issues caused by the revert.
> 
> The revert is necessary because hugepage_madvise would return -EINVAL
> when VM_NOHUGEPAGE is set, which will break subsequent chunks of this
> patch set.

This is a bit skimpy.  Why doesn't the patch re-break kvm-on-s390?

it would be nice to have a lot more detail here, please.  What was the
intent of 8e72033f2a48, how this patch retains 8e72033f2a48's behavior,
etc.

> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -504,6 +504,9 @@ static int gmap_connect_pgtable(unsigned long address, unsigned long segment,
>  	if (!pmd_present(*pmd) &&
>  	    __pte_alloc(mm, vma, pmd, vmaddr))
>  		return -ENOMEM;
> +	/* large pmds cannot yet be handled */
> +	if (pmd_large(*pmd))
> +		return -EFAULT;

This bit wasn't in 8e72033f2a48.


