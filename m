Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaJBQVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:21:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbaJBQVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:21:47 -0400
Message-ID: <542D7AFF.5040003@redhat.com>
Date: Thu, 02 Oct 2014 12:19:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Dave Jones <davej@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
References: <1412256558-9995-1-git-send-email-mgorman@suse.de> <1412256558-9995-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1412256558-9995-5-git-send-email-mgorman@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 09:29 AM, Mel Gorman wrote:
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

Acked-by: Rik van Riel <riel@redhat.com>

