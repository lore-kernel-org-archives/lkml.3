Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3CUR6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:58:48 -0400
Received: from www.sr71.net ([198.145.64.142]:51769 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab3CUR6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:58:46 -0400
Message-ID: <514B4A9F.5090004@sr71.net>
Date: Thu, 21 Mar 2013 10:59:59 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
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
Subject: Re: [PATCHv2, RFC 12/30] thp, mm: add event counters for huge page
 alloc on write to a file
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-13-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-13-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -71,6 +71,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		THP_FAULT_FALLBACK,
>  		THP_COLLAPSE_ALLOC,
>  		THP_COLLAPSE_ALLOC_FAILED,
> +		THP_WRITE_ALLOC,
> +		THP_WRITE_FAILED,
>  		THP_SPLIT,
>  		THP_ZERO_PAGE_ALLOC,
>  		THP_ZERO_PAGE_ALLOC_FAILED,

I think these names are a bit terse.  It's certainly not _writes_ that
are failing and "THP_WRITE_FAILED" makes it sound that way.  Also, why
do we need to differentiate these from the existing anon-hugepage vm
stats?  The alloc_pages() call seems to be doing the exact same thing in
the end.  Is one more likely to succeed than the other?
