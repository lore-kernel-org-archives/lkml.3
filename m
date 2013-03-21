Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab3CURSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:18:51 -0400
Received: from www.sr71.net ([198.145.64.142]:51473 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab3CURSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:18:49 -0400
Message-ID: <514B4142.7040000@sr71.net>
Date: Thu, 21 Mar 2013 10:20:02 -0700
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
Subject: Re: [PATCHv2, RFC 10/30] thp, mm: locking tail page is a bug
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-11-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-11-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> index 0ff3403..38fdc92 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -669,6 +669,7 @@ void __lock_page(struct page *page)
>  {
>  	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
>  
> +	VM_BUG_ON(PageTail(page));
>  	__wait_on_bit_lock(page_waitqueue(page), &wait, sleep_on_page,
>  							TASK_UNINTERRUPTIBLE);
>  }

Could we get a bit more of a description here in a comment or in the
patch summary about this?  It makes some sense to me that code shouldn't
be mucking with the tail pages, but I'm curious what your logic is here,
too.  I'm sure you've thought about it a lot more than I have.
