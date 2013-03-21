Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab3CUIAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:00:55 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58833 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3CUIAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:00:53 -0400
Message-ID: <514ABE2C.1090901@gmail.com>
Date: Thu, 21 Mar 2013 16:00:44 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 00/16] Transparent huge page cache
References: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 05:24 PM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Here's first steps towards huge pages in page cache.
>
> The intend of the work is get code ready to enable transparent huge page
> cache for the most simple fs -- ramfs.
>
> It's not yet near feature-complete. It only provides basic infrastructure.
> At the moment we can read, write and truncate file on ramfs with huge pages in
> page cache. The most interesting part, mmap(), is not yet there. For now
> we split huge page on mmap() attempt.
>
> I can't say that I see whole picture. I'm not sure if I understand locking
> model around split_huge_page(). Probably, not.
> Andrea, could you check if it looks correct?

Is there any thp performance test benchmark? For anonymous pages or file 
pages.

>
> Next steps (not necessary in this order):
>   - mmap();
>   - migration (?);
>   - collapse;
>   - stats, knobs, etc.;
>   - tmpfs/shmem enabling;
>   - ...
>
> Kirill A. Shutemov (16):
>    block: implement add_bdi_stat()
>    mm: implement zero_huge_user_segment and friends
>    mm: drop actor argument of do_generic_file_read()
>    radix-tree: implement preload for multiple contiguous elements
>    thp, mm: basic defines for transparent huge page cache
>    thp, mm: rewrite add_to_page_cache_locked() to support huge pages
>    thp, mm: rewrite delete_from_page_cache() to support huge pages
>    thp, mm: locking tail page is a bug
>    thp, mm: handle tail pages in page_cache_get_speculative()
>    thp, mm: implement grab_cache_huge_page_write_begin()
>    thp, mm: naive support of thp in generic read/write routines
>    thp, libfs: initial support of thp in
>      simple_read/write_begin/write_end
>    thp: handle file pages in split_huge_page()
>    thp, mm: truncate support for transparent huge page cache
>    thp, mm: split huge page on mmap file page
>    ramfs: enable transparent huge page cache
>
>   fs/libfs.c                  |   54 +++++++++---
>   fs/ramfs/inode.c            |    6 +-
>   include/linux/backing-dev.h |   10 +++
>   include/linux/huge_mm.h     |    8 ++
>   include/linux/mm.h          |   15 ++++
>   include/linux/pagemap.h     |   14 ++-
>   include/linux/radix-tree.h  |    3 +
>   lib/radix-tree.c            |   32 +++++--
>   mm/filemap.c                |  204 +++++++++++++++++++++++++++++++++++--------
>   mm/huge_memory.c            |   62 +++++++++++--
>   mm/memory.c                 |   22 +++++
>   mm/truncate.c               |   12 +++
>   12 files changed, 375 insertions(+), 67 deletions(-)
>

