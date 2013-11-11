Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3KKVJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:09:36 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48272 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3KKVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:09:28 -0500
Date: Mon, 11 Nov 2013 22:09:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] mm: cache largest vma
Message-ID: <20131111210924.GA19284@gmail.com>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFwrtOaFtwGc6xyZH6-1j3f--AG1JS-iZM8-pZPnwRHBow@mail.gmail.com>
 <1383537862.2373.14.camel@buesod1.americas.hpqcorp.net>
 <20131104073640.GF13030@gmail.com>
 <1384143129.6940.32.camel@buesod1.americas.hpqcorp.net>
 <20131111120116.GA21291@gmail.com>
 <1384194271.6940.40.camel@buesod1.americas.hpqcorp.net>
 <20131111204702.GD18886@gmail.com>
 <1384203573.6940.67.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384203573.6940.67.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> > Or is access to varied in the Oracle case that it's missing the cache 
> > all the time, because the rbtree causes many cachemisses as the 
> > separate nodes are accessed during an rb-walk?
> 
> Similar to get_cycles(), is there anyway to quickly measure the amount 
> of executed instructions? Getting the IPC for the mmap_cache (this of 
> course is constant) and the treewalk could give us a nice overview of 
> the function's cost. I was thinking of stealing some perf-stat 
> functionality for this but didn't get around to it. Hopefully there's an 
> easier way...

There's no such easy method I'm afraid (Frederic's probe based trigger 
facility will give us that and more - but it's not ready yet) - but you 
could try profiling the workload for significant cache-misses:

  perf record -e cache-misses ...

I _think_ if it's really catastrophic cache-misses then the rbtree walk 
should light up on the perf radar like crazy.

Thanks,

	Ingo
