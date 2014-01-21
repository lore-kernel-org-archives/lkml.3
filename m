Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaAULw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:52:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbaAULw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:52:27 -0500
Date: Tue, 21 Jan 2014 11:52:23 +0000
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: Re: [PATCH 1/6] numa,sched,mm: remove p->numa_migrate_deferred
Message-ID: <20140121115223.GF4963@suse.de>
References: <1390245667-24193-1-git-send-email-riel@redhat.com>
 <1390245667-24193-2-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1390245667-24193-2-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 02:21:02PM -0500, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Excessive migration of pages can hurt the performance of workloads
> that span multiple NUMA nodes.  However, it turns out that the
> p->numa_migrate_deferred knob is a really big hammer, which does
> reduce migration rates, but does not actually help performance.
> 
> Now that the second stage of the automatic numa balancing code
> has stabilized, it is time to replace the simplistic migration
> deferral code with something smarter.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Chegu Vinod <chegu_vinod@hp.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>

When I added a tracepoint to track deferred migration I was surprised how
often it triggered for some workloads. I agree that we want to do something
better because it was a crutch albeit a necessary one at the time.

Note that the knob was not about performance as such, it was about avoiding
worst-case behaviour. We should keep an eye out for bugs that look like
excessive migration on workloads that are not converging.  Reintroducing this
hammer would be a last resort for working around the problem.

Finally, the sysctl is documented in Documentation/sysctl/kernel.txt and
this patch should also remove it.

Functionally, the patch looks fine and it's time to reinvestigate if
it's necessary so assuming the documentation gets removed;

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
