Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3I3IxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:53:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab3I3IxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:53:03 -0400
Date: Mon, 30 Sep 2013 09:52:59 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/63] mm: Close races between THP migration and PMD numa
 clearing
Message-ID: <20130930084735.GA2425@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
 <1380288468-5551-12-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1380288468-5551-12-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 02:26:56PM +0100, Mel Gorman wrote:
> @@ -1732,9 +1732,9 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
>  	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
>  	entry = pmd_mkhuge(entry);
>  
> -	page_add_new_anon_rmap(new_page, vma, haddr);
> -
> +	pmdp_clear_flush(vma, address, pmd);
>  	set_pmd_at(mm, haddr, pmd, entry);
> +	page_add_new_anon_rmap(new_page, vma, haddr);
>  	update_mmu_cache_pmd(vma, address, &entry);
>  	page_remove_rmap(page);
>  	/*

pmdp_clear_flush should have used haddr

-- 
Mel Gorman
SUSE Labs
