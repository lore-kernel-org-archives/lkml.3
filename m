Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3F1PLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:11:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53474 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3F1PLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:11:00 -0400
Date: Fri, 28 Jun 2013 17:10:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] sched: Favour moving tasks towards the preferred node
Message-ID: <20130628151048.GB6626@twins.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-6-git-send-email-mgorman@suse.de>
 <20130627161127.GZ28407@twins.programming.kicks-ass.net>
 <20130628134535.GX1875@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628134535.GX1875@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 02:45:35PM +0100, Mel Gorman wrote:

> > Also, until I just actually _read_ that function; I assumed it would
> > compare p->numa_faults[src_nid] and p->numa_faults[dst_nid]. Because
> > even when the dst_nid isn't the preferred nid; it might still have more
> > pages than where we currently are.
> > 
> 
> I tested something like this and also tested it when only taking shared
> accesses into account but it performed badly in some cases.  I've included
> the last patch I tested below for reference but dropped it until I figured
> out why it performed badly. I guessed it was due to increased bouncing
> due to shared faults but didn't prove it.

Oh, interesting. Yeah it would be good to figure out why that gave
funnies.
