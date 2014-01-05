Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaAER7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:59:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:19936 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaAER7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:59:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,608,1384329600"; 
   d="scan'208";a="453935135"
Date: Sun, 5 Jan 2014 09:59:49 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: Re: [PATCH RFC v2 0/4] perf: IRQ-bound performance events
Message-ID: <20140105175949.GC27909@tassilo.jf.intel.com>
References: <cover.1388858996.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1388858996.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 07:22:32PM +0100, Alexander Gordeev wrote:
> Hello,
> 
> This is version 2 of RFC "perf: IRQ-bound performance events". That is an
> introduction of IRQ-bound performance events - ones that only count in a
> context of a hardware interrupt handler. Ingo suggested to extend this
> functionality to softirq and threaded handlers as well:

Did you measure the overhead in workloads that do a lot of interrupts?
I assume two WRMSR could be a significant part of the cost of small interrupts.

For counting at least it would be likely a lot cheaper to just RDPMC
and subtract manually.

The cache miss example below is certainly misleading, as cache misses
by interrupts are often a "debt", that is they are forced on whoever
is interrupted. I don't think that is a good use of this.

I guess it can be useful for cycles.

-Andi
