Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3KESrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:47:53 -0500
Received: from www.sr71.net ([198.145.64.142]:50180 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab3KESrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:47:52 -0500
Message-ID: <52793D27.8050607@sr71.net>
Date: Tue, 05 Nov 2013 10:47:03 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dave.jiang@intel.com,
        Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org,
        dhillf@gmail.com
Subject: Re: [PATCH 2/2] mm: thp: give transparent hugepage code a separate
 copy_page
References: <20131028221618.4078637F@viggo.jf.intel.com> <20131028221620.042323B3@viggo.jf.intel.com> <20131028221126.GA29431@shutemov.name>
In-Reply-To: <20131028221126.GA29431@shutemov.name>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 03:11 PM, Kirill A. Shutemov wrote:
> On Mon, Oct 28, 2013 at 03:16:20PM -0700, Dave Hansen wrote:
>> void copy_huge_page(struct page *dst, struct page *src)
>> {
>>         struct hstate *h = page_hstate(src);
>>         if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
>> ...
>>
>> This patch creates a copy_high_order_page() which can
>> be used on THP pages.
> 
> We already have copy_user_huge_page() and copy_user_gigantic_page() in
> generic code (mm/memory.c). I think copy_gigantic_page() and
> copy_huge_page() should be moved there too.

That would be fine I guesss... in another patch. :)

> BTW, I think pages_per_huge_page in copy_user_huge_page() is redunand:
> compound_order(page) should be enough, right?

The way it is now, the compiler can optimize for the !HUGETLBFS case.
Also, pages_per_huge_page() works for gigantic pages.  compound_order()
wouldn't work for those.

