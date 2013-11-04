Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3KDOUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:20:09 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58782 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3KDOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:20:07 -0500
Date: Mon, 4 Nov 2013 15:20:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm: cache largest vma
Message-ID: <20131104142001.GE9299@localhost.localdomain>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
 <20131103101234.GB5330@gmail.com>
 <1383538810.2373.22.camel@buesod1.americas.hpqcorp.net>
 <20131104070500.GE13030@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104070500.GE13030@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 08:05:00AM +0100, Ingo Molnar wrote:
> 
> * Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > Btw, do you suggest using a high level tool such as perf for getting 
> > this data or sprinkling get_cycles() in find_vma() -- I'd think that the 
> > first isn't fine grained enough, while the later will probably variate a 
> > lot from run to run but the ratio should be rather constant.
> 
> LOL - I guess I should have read your mail before replying to it ;-)
> 
> Yes, I think get_cycles() works better in this case - not due to 
> granularity (perf stat will report cycle granular just fine), but due to 
> the size of the critical path you'll be measuring. You really want to 
> extract the delta, because it's probably so much smaller than the overhead 
> of the workload itself.
> 
> [ We still don't have good 'measure overhead from instruction X to 
>   instruction Y' delta measurement infrastructure in perf yet, although
>   Frederic is working on such a trigger/delta facility AFAIK. ]

Yep, in fact Jiri took it over and he's still working on it. But yeah, once
that get merged, we should be able to measure instructions or cycles inside
any user or kernel function through kprobes/uprobes or function graph tracer.

> 
> Thanks,
> 
> 	Ingo
