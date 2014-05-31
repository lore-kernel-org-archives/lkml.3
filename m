Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaEaFQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 01:16:42 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:38969 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaEaFQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 01:16:40 -0400
Date: Sat, 31 May 2014 01:16:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@unimore.it>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140531051635.GA19925@mtj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <538926F6.7080409@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538926F6.7080409@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Fri, May 30, 2014 at 06:48:54PM -0600, Jens Axboe wrote:
> What I really like about the implementation is, as Tejun highlights, that
> the algorithm is detailed and characterized. Nobody ever wrote any detailed
> documentation on CFQ - I think the closest is a talk I gave at LCA in 2007
> or so. That said, the devil is _always_ in the details when it comes to nice
> algorithms. When theory meets practice, then the little tweaks and tunings
> required to not drop 10% there or 20% here is when it gets ugly. And that's
> where CFQ has the history going for it, at least. Which is another reason

That's the thing I like about the new paper.  It looks like the
original BFQ was the naive ideal implementation but the new paper
basically takes most, if not all, heuristics implemented in cfq,
properly characterizes them and applies the improved versions.  The
end result, AFAICS, really is an evolution of cfq with the core
round-robin + preemption scheduler replaced by something a lot firmer.
It doesn't really lose much of what cfq has accumulated over time.

> for turning patch #2 into a series of changes for CFQ instead. We need to
> end up with something where we can potentially bisect our way down to
> whatever caused any given regression. The worst possible situation is "CFQ
> works fine for this workload, but BFQ does not" or vice versa. Or hangs, or
> whatever it might be.

It's likely that there will be some workloads out there which may be
affected adversely, which is true for any change really but with both
the core scheduling and heuristics properly characterized at least
finding a reasonable trade-off should be much less of a crapshoot and
the expected benefits seem to easily outweigh the risks as long as we
can properly sequence the changes.

Thanks.

-- 
tejun
