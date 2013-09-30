Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3I3SGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:06:20 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54226 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3I3SGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:06:18 -0400
MIME-Version: 1.0
In-Reply-To: <52499875.4060101@sr71.net>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
 <20130930100249.GB2425@suse.de> <52499875.4060101@sr71.net>
From: Ning Qu <quning@google.com>
Date: Mon, 30 Sep 2013 11:05:57 -0700
Message-ID: <CACz4_2d89zn9mgkoYpmQam_3ymGYDZ_DyTPHaM-yyLbnPddOAQ@mail.gmail.com>
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1, everything
 but mmap()
To: Dave Hansen <dave@sr71.net>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I agree. For our case, we have tens of GB files and thp with page
cache does improve the number as expected.

And compared to hugetlbfs (static huge page), it's more flexible and
beneficial to the system wide ....


Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Mon, Sep 30, 2013 at 8:27 AM, Dave Hansen <dave@sr71.net> wrote:
> On 09/30/2013 03:02 AM, Mel Gorman wrote:
>> I am afraid I never looked too closely once I learned that the primary
>> motivation for this was relieving iTLB pressure in a very specific
>> case. AFAIK, this is not a problem in the vast majority of modern CPUs
>> and I found it very hard to be motivated to review the series as a result.
>> I suspected that in many cases that the cost of IO would continue to dominate
>> performance instead of TLB pressure. I also found it unlikely that there
>> was a workload that was tmpfs based that used enough memory to be hurt
>> by TLB pressure. My feedback was that a much more compelling case for the
>> series was needed but this discussion all happened on IRC unfortunately.
>
> FWIW, I'm mostly intrigued by the possibilities of how this can speed up
> _software_, and I'm rather uninterested in what it can do for the TLB.
> Page cache is particularly painful today, precisely because hugetlbfs
> and anonymous-thp aren't available there.  If you have an app with
> hundreds of GB of files that it wants to mmap(), even if it's in the
> page cache, it takes _minutes_ to just fault in.  One example:
>
>         https://lkml.org/lkml/2013/6/27/698
