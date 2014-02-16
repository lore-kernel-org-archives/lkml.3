Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924AbaBPF0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 00:26:32 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59159 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaBPF0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 00:26:30 -0500
Date: Sat, 15 Feb 2014 21:25:39 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Weijie Yang <weijie.yang.kh@gmail.com>
cc: Hugh Dickins <hughd@google.com>, Weijie Yang <weijie.yang@samsung.com>,
        riel@redhat.com, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [RFC PATCH] mm/vmscan: remove two un-needed mem_cgroup_page_lruvec()
 call
In-Reply-To: <CAL1ERfO4yYMRBO8XEM0oCwBb6NOqZRVGq648ncerM9XuyPPJkw@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1402152121180.13768@eggly.anvils>
References: <000001cf2ac7$9abf23b0$d03d6b10$%yang@samsung.com> <alpine.LSU.2.11.1402151953180.10073@eggly.anvils> <CAL1ERfO4yYMRBO8XEM0oCwBb6NOqZRVGq648ncerM9XuyPPJkw@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Feb 2014, Weijie Yang wrote:
> On Sun, Feb 16, 2014 at 12:00 PM, Hugh Dickins <hughd@google.com> wrote:
> > On Sun, 16 Feb 2014, Weijie Yang wrote:
> >
> >> In putback_inactive_pages() and move_active_pages_to_lru(),
> >> lruvec is already an input parameter and pages are all from this lruvec,
> >> therefore there is no need to call mem_cgroup_page_lruvec() in loop.
> >>
> >> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> >
> > Looks plausible but I believe it's incorrect.  The lruvec passed in
> > is the one we took the pages from, but there's a small but real chance
> > that the page has become uncharged meanwhile, and should now be put back
> > on the root_mem_cgroup's lruvec instead of the original memcg's lruvec.
> 
> Hi Hugh,
> 
> Thanks for your review.
> Frankly speaking, I am not very sure about it, that is why I add a RFC tag here.
> So,  do we need update the reclaim_stat meanwhile as we change the lruvec?

No, it's not worth bothering about, it's only for stats and this is an
unlikely case; whereas wrong memcg can be a significant correctness issue.

Hugh
