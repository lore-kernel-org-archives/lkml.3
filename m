Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841Ab3JPSsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:48:47 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:61393 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761360Ab3JPSsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:48:45 -0400
MIME-Version: 1.0
In-Reply-To: <20131016120951.B5012E0090@blue.fi.intel.com>
References: <20131015001304.GH3432@hippobay.mtv.corp.google.com>
 <20131015110146.7E8BEE0090@blue.fi.intel.com> <CACz4_2fiF+vaAbFixgGF+Uxn0av4H8y-aMQdyi3yYs5pdS2WBA@mail.gmail.com>
 <20131016120951.B5012E0090@blue.fi.intel.com>
From: Ning Qu <quning@google.com>
Date: Wed, 16 Oct 2013 11:48:24 -0700
Message-ID: <CACz4_2eAots8Xk3C8Vosqc24vs28OtsD4LecsH19MjWeQaw+2Q@mail.gmail.com>
Subject: Re: [PATCH 07/12] mm, thp, tmpfs: handle huge page in
 shmem_undo_range for truncate
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Wed, Oct 16, 2013 at 5:09 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Ning Qu wrote:
>> > Again. Here and below ifdef is redundant: PageTransHugeCache() is zero
>> > compile-time and  thp case will be optimize out.
>>
>> The problem is actually from HPAGE_CACHE_INDEX_MASK, it is marked as
>> build bug when CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE is false. So we
>> either wrap some logic inside a inline function, or we have to be like
>> this .. Or we don't treat the HPAGE_CACHE_INDEX_MASK as a build bug?
>
> HPAGE_CACHE_INDEX_MASK shouldn't be a problem.
> If it's wrapped into 'if PageTransHugeCache(page)' or similar it will be
> eliminated by compiler if thp-pc disabled and build bug will not be
> triggered.
>
Yes, you are totally right about this. I have remove all the ifdef for
CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE now. Thanks!

>>
>> >
>> > And do we really need a copy of truncate logic here? Is there a way to
>> > share code?
>> >
>> The truncate between tmpfs and general one is similar but not exactly
>> the same (no readahead), so share the whole function might not be a
>> good choice from the perspective of tmpfs? Anyway, there are other
>> similar functions in tmpfs, e.g. the one you mentioned for
>> shmem_add_to_page_cache. It is possible to share the code, I am just
>> worried it will make the logic more complicated?
>
> I think introducing thp-pc is good opportunity to refactor all these code.
>
> --
>  Kirill A. Shutemov
