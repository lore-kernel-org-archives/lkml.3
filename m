Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaJBPU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:20:59 -0400
Received: from mta-out1.inet.fi ([62.71.2.234]:33070 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbaJBPU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:20:58 -0400
Date: Thu, 2 Oct 2014 18:18:07 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Mel Gorman <mgorman@suse.de>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
Message-ID: <20141002151807.GA13668@node.dhcp.inet.fi>
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>
 <1412256558-9995-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412256558-9995-5-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:29:18PM +0100, Mel Gorman wrote:
> This patch reverts 1ba6e0b50b ("mm: numa: split_huge_page: transfer the
> NUMA type from the pmd to the pte"). If a huge page is being split due
> a protection change and the tail will be in a PROT_NONE vma then NUMA
> hinting PTEs are temporarily created in the protected VMA.
> 
>  VM_RW|VM_PROTNONE
> |-----------------|
>       ^
>       split here
> 
> In the specific case above, it should get fixed up by change_pte_range()
> but there is a window of opportunity for weirdness to happen. Similarly,
> if a huge page is shrunk and split during a protection update but before
> pmd_numa is cleared then a pte_numa can be left behind.
> 
> Instead of adding complexity trying to deal with the case, this patch
> will not mark PTEs NUMA when splitting a huge page. NUMA hinting faults
> will not be triggered which is marginal in comparison to the complexity
> in dealing with the corner cases during THP split.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

I think it deserves a comment to avoid re-introducing NUMA type
transferring.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
