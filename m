Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab3G3JKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:10:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3G3JKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:10:36 -0400
Date: Tue, 30 Jul 2013 11:10:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/10] Improve numa scheduling by consolidating tasks
Message-ID: <20130730091021.GM3008@twins.programming.kicks-ass.net>
References: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
 <20130730081755.GF3008@twins.programming.kicks-ass.net>
 <20130730082001.GG3008@twins.programming.kicks-ass.net>
 <20130730090345.GA22201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730090345.GA22201@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 02:33:45PM +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2013-07-30 10:20:01]:
> 
> > On Tue, Jul 30, 2013 at 10:17:55AM +0200, Peter Zijlstra wrote:
> > > On Tue, Jul 30, 2013 at 01:18:15PM +0530, Srikar Dronamraju wrote:
> > > > Here is an approach that looks to consolidate workloads across nodes.
> > > > This results in much improved performance. Again I would assume this work
> > > > is complementary to Mel's work with numa faulting.
> > > 
> > > I highly dislike the use of task weights here. It seems completely
> > > unrelated to the problem at hand.
> > 
> > I also don't particularly like the fact that it's purely process based.
> > The faults information we have gives much richer task relations.
> > 
> 
> With just pure fault information based approach, I am not seeing any
> major improvement in tasks/memory consolidation. I still see memory
> spread across different nodes and tasks getting ping-ponged to different
> nodes. And if there are multiple unrelated processes, then we see a mix
> of tasks of different processes in each of the node.

The fault thing isn't finished. Mel explicitly said it doesn't yet have
inter-task relations. And you run everything in a VM which is like a big
nasty mangler for anything sane.
