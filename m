Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbaDVUEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:04:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaDVUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:04:53 -0400
Date: Tue, 22 Apr 2014 22:04:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugfix] sched: fix possible invalid memory access caused by CPU
 hot-addition
Message-ID: <20140422200449.GF11096@twins.programming.kicks-ass.net>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
 <20140422081515.GF11182@twins.programming.kicks-ass.net>
 <20140422130151.83bc4539364ca660c68de859@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422130151.83bc4539364ca660c68de859@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:01:51PM -0700, Andrew Morton wrote:
> On Tue, 22 Apr 2014 10:15:15 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, Apr 22, 2014 at 01:27:15PM +0800, Jiang Liu wrote:
> > > When calling kzalloc_node(size, flags, node), we should first check
> > > whether node is onlined, otherwise it may cause invalid memory access
> > > as below.
> > 
> > But this is only for memory less node crap, right? 
> 
> um, why are memoryless nodes crap?

Why wouldn't they be? Having CPUs with no local memory seems decidedly
suboptimal.
