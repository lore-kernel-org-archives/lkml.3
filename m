Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422736Ab3CVSUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:20:43 -0400
Received: from www.sr71.net ([198.145.64.142]:34316 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422649Ab3CVSUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:20:42 -0400
Message-ID: <514CA325.3010104@sr71.net>
Date: Fri, 22 Mar 2013 11:29:57 -0700
From: Dave <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
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
Subject: Re: [PATCHv2, RFC 18/30] thp, mm: truncate support for transparent
 huge page cache
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-19-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-19-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> @@ -280,6 +291,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  			if (index > end)
>  				break;
>  
> +			VM_BUG_ON(PageTransHuge(page));
>  			lock_page(page);
>  			WARN_ON(page->index != index);
>  			wait_on_page_writeback(page);

This looks to be during the second truncate pass where things are
allowed to block.  What's the logic behind it not being possible to
encounter TransHugePage()s here?
