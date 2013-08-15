Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3HONke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:40:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab3HONkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:40:33 -0400
Date: Thu, 15 Aug 2013 15:40:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Tebulin <tebulin@googlemail.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug] Reproducible data corruption on i5-3340M: Please revert
 53a59fc67!
Message-ID: <20130815134031.GC27864@dhcp22.suse.cz>
References: <52050382.9060802@gmail.com>
 <520BB225.8030807@gmail.com>
 <20130814174039.GA24033@dhcp22.suse.cz>
 <CA+55aFwAz7GdcB6nC0Th42y8eAM591sKO1=mYh5SWgyuDdHzcA@mail.gmail.com>
 <20130814182756.GD24033@dhcp22.suse.cz>
 <CA+55aFxB6Wyj3G3Ju8E7bjH-706vi3vysuATUZ13h1tdYbCbnQ@mail.gmail.com>
 <520C9E78.2020401@gmail.com>
 <CA+55aFy2D2hTc_ina1DvungsCL4WU2OTM=bnVb8sDyDcGVCBEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy2D2hTc_ina1DvungsCL4WU2OTM=bnVb8sDyDcGVCBEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-08-13 05:02:31, Linus Torvalds wrote:
> On Thu, Aug 15, 2013 at 2:25 AM, Ben Tebulin <tebulin@googlemail.com> wrote:
> >
> > I just cherry-picked e6c495a96ce0 into 3.9.11 and 3.7.10.
> > Unfortunately this does _not resolve_ my issue (too good to be true) :-(
> 
> Ho humm. I've found at least one other bug, but that one only affects
> hugepages. Do you perhaps have transparent hugepages enabled? But even
> then it looks quite unlikely.

__unmap_hugepage_range is hugetlb not THP if you had that one in mind.
And yes, it doesn't set the range which sounds buggy.

> I'll think about this some more. I'm not happy with how that
> particular whole TLB flushing hack was done, but I need to sleep on
> this.

I am looking into it as well, but there are high prio things which
preempt me a lot :/

Thanks for looking into it.
-- 
Michal Hocko
SUSE Labs
