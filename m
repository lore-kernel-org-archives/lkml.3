Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaCNNdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:33:40 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:45734 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbaCNNdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:33:39 -0400
Date: Fri, 14 Mar 2014 15:33:11 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Evans <je@fb.com>
Subject: Re: [RFC 3/6] mm: support madvise(MADV_FREE)
Message-ID: <20140314133311.GA6316@node.dhcp.inet.fi>
References: <1394779070-8545-1-git-send-email-minchan@kernel.org>
 <1394779070-8545-4-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394779070-8545-4-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 03:37:47PM +0900, Minchan Kim wrote:
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c1b7414c7bef..9b048cabce27 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -933,10 +933,16 @@ void page_address_init(void);
>   * Please note that, confusingly, "page_mapping" refers to the inode
>   * address_space which maps the page from disk; whereas "page_mapped"
>   * refers to user virtual address space into which the page is mapped.
> + *
> + * PAGE_MAPPING_LZFREE bit is set along with PAGE_MAPPING_ANON bit
> + * and then page->mapping points to an anon_vma. This flag is used
> + * for lazy freeing the page instead of swap.
>   */
>  #define PAGE_MAPPING_ANON	1
>  #define PAGE_MAPPING_KSM	2
> -#define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
> +#define PAGE_MAPPING_LZFREE	4
> +#define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM | \
> +				 PAGE_MAPPING_LZFREE)

Is it safe to use third bit in pointer everywhere?

-- 
 Kirill A. Shutemov
