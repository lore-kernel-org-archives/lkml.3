Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3I3SIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:08:20 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:44816 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3I3SIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:08:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130930101029.GC2425@suse.de>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
 <20130930100249.GB2425@suse.de> <20130930101029.GC2425@suse.de>
From: Ning Qu <quning@google.com>
Date: Mon, 30 Sep 2013 11:07:57 -0700
Message-ID: <CACz4_2cYVzuSFmQ-jpdWe0DXtHBm4QGoWEYD=x6fWmMEUR8nzw@mail.gmail.com>
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1, everything
 but mmap()
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suppose sysv shm and tmpfs share the same code base now, so both of
them will benefit from thp page cache?

And for Kirill's previous patchset (till v4), it contains mmap support
as well. I suppose the patchset got splitted into smaller group so
it's easier to review ....

Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Mon, Sep 30, 2013 at 3:10 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Mon, Sep 30, 2013 at 11:02:49AM +0100, Mel Gorman wrote:
>> On Tue, Sep 24, 2013 at 04:37:40PM -0700, Andrew Morton wrote:
>> > On Mon, 23 Sep 2013 15:05:28 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
>> >
>> > > It brings thp support for ramfs, but without mmap() -- it will be posted
>> > > separately.
>> >
>> > We were never going to do this :(
>> >
>> > Has anyone reviewed these patches much yet?
>> >
>>
>> I am afraid I never looked too closely once I learned that the primary
>> motivation for this was relieving iTLB pressure in a very specific
>> case. AFAIK, this is not a problem in the vast majority of modern CPUs
>> and I found it very hard to be motivated to review the series as a result.
>> I suspected that in many cases that the cost of IO would continue to dominate
>> performance instead of TLB pressure. I also found it unlikely that there
>> was a workload that was tmpfs based that used enough memory to be hurt
>> by TLB pressure. My feedback was that a much more compelling case for the
>> series was needed but this discussion all happened on IRC unfortunately.
>>
>
> Oh, one last thing I forgot. While tmpfs-based workloads were not likely to
> benefit I would expect that sysV shared memory workloads would potentially
> benefit from this.  hugetlbfs is still required for shared memory areas
> but it is not a problem that is addressed by this series.
>
> --
> Mel Gorman
> SUSE Labs
