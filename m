Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3EUUys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:54:48 -0400
Received: from www.sr71.net ([198.145.64.142]:45129 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3EUUyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:54:47 -0400
Message-ID: <519BDF15.4080301@sr71.net>
Date: Tue, 21 May 2013 13:54:45 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 18/39] thp, mm: add event counters for huge page alloc
 on write to a file
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-19-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1368321816-17719-19-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index d4b7a18..584c71c 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -71,6 +71,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		THP_FAULT_FALLBACK,
>  		THP_COLLAPSE_ALLOC,
>  		THP_COLLAPSE_ALLOC_FAILED,
> +		THP_WRITE_ALLOC,
> +		THP_WRITE_ALLOC_FAILED,
>  		THP_SPLIT,
>  		THP_ZERO_PAGE_ALLOC,
>  		THP_ZERO_PAGE_ALLOC_FAILED,
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 7945285..df8dcda 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -821,6 +821,8 @@ const char * const vmstat_text[] = {
>  	"thp_fault_fallback",
>  	"thp_collapse_alloc",
>  	"thp_collapse_alloc_failed",
> +	"thp_write_alloc",
> +	"thp_write_alloc_failed",
>  	"thp_split",
>  	"thp_zero_page_alloc",
>  	"thp_zero_page_alloc_failed",

I guess these new counters are _consistent_ with all the others.  But,
why do we need a separate "_failed" for each one of these?  While I'm
nitpicking, does "thp_write_alloc" mean allocs or _successful_ allocs?
I had to look at the code to tell.

I thihk it's probably safe to combine this patch with the next one.
Breaking them apart just makes it harder to review.  If _anything_,
this, plus the use of the counters should go in to a different patch
from the true code changes in "mm: allocate huge pages in
grab_cache_page_write_begin()".
