Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3EVPbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:31:42 -0400
Received: from www.sr71.net ([198.145.64.142]:52755 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab3EVPbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:31:40 -0400
Message-ID: <519CE4DB.9070303@sr71.net>
Date: Wed, 22 May 2013 08:31:39 -0700
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
Subject: Re: [PATCHv4 09/39] thp, mm: introduce mapping_can_have_hugepages()
 predicate
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-10-git-send-email-kirill.shutemov@linux.intel.com> <519BCACD.4020106@sr71.net> <20130522135112.32C3EE0090@blue.fi.intel.com>
In-Reply-To: <20130522135112.32C3EE0090@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 06:51 AM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>> Also, what happens if "transparent_hugepage_flags &
>> (1<<TRANSPARENT_HUGEPAGE_PAGECACHE)" becomes false at runtime and you
>> have some already-instantiated huge page cache mappings around?  Will
>> things like mapping_align_mask() break?
> 
> We will not touch existing huge pages in existing VMAs. The userspace can
> use them until they will be unmapped or split. It's consistent with anon
> THP pages.
> 
> If anybody mmap() the file after disabling the feature, we will not
> setup huge pages anymore: transparent_hugepage_enabled() check in
> handle_mm_fault will fail and the page fill be split.
> 
> mapping_align_mask() is part of mmap() call path, so there's only chance
> that we will get VMA aligned more strictly then needed. Nothing to worry
> about.

Could we get a little blurb along those lines somewhere?  Maybe even in
your docs that you've added to Documentation/.  Oh, wait, you don't have
any documentation? :)

You did add a sysfs knob, so you do owe us some docs for it.

"If the THP-cache sysfs tunable is disabled, huge pages will no longer
be mapped with new mmap()s, but they will remain in place in the page
cache.  You might still see some benefits from read/write operations,
etc..."
