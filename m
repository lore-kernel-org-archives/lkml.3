Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaBSCW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:22:28 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44720 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaBSCW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:22:26 -0500
Date: Tue, 18 Feb 2014 18:22:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: riel@redhat.com
cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        peterz@infradead.org, chegu_vinod@hp.com, aarcange@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH -mm 2/3] mm,numa: reorganize change_pmd_range
In-Reply-To: <1392761566-24834-3-git-send-email-riel@redhat.com>
Message-ID: <alpine.DEB.2.02.1402181822010.20791@chino.kir.corp.google.com>
References: <1392761566-24834-1-git-send-email-riel@redhat.com> <1392761566-24834-3-git-send-email-riel@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, riel@redhat.com wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> Reorganize the order of ifs in change_pmd_range a little, in
> preparation for the next patch.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Reported-by: Xing Gang <gang.xing@hp.com>
> Tested-by: Chegu Vinod <chegu_vinod@hp.com>

Acked-by: David Rientjes <rientjes@google.com>

> ---
>  mm/mprotect.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 769a67a..6006c05 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,6 +118,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
>  		unsigned long this_pages;
>  
>  		next = pmd_addr_end(addr, end);
> +		if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
> +				continue;
>  		if (pmd_trans_huge(*pmd)) {
>  			if (next - addr != HPAGE_PMD_SIZE)
>  				split_huge_page_pmd(vma, addr, pmd);

Extra tab there, though.
