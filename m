Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaCNOLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:11:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:13624 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbaCNOLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:11:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,655,1389772800"; 
   d="scan'208";a="472359480"
Date: Fri, 14 Mar 2014 07:10:43 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140314141043.GF3793@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140217143340.GR27965@twins.programming.kicks-ass.net>
 <20140218023659.GV12219@tassilo.jf.intel.com>
 <20140314103832.GQ27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314103832.GQ27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I really don't want the multi-buffer nonsense proposed. 

> An event gets
> _1_ buffer, that's it.

But we already have multi buffer. Just profile multiple CPUs
Then you have one buffer per CPU that need to be combined.

This just has two buffers per CPU.

> That also means that if someone redirect another event into this buffer,
> it needs to just work.

All the tools already handle multiple buffers (for multi CPUs).
So they don't need it.

> And because its a perf buffer, people expect it to look like one. So
> we've got 'wrap' it.

Flushing TLBs from NMIs or irq work or any interrupt context is just
a non starter.

The start/stop hardware and create gigantic gaps was also pretty bad
and would completely change the perf format too

It seem to me you're trying to solve a non-problem.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
