Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBQQII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:08:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:61711 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaBQQIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:08:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,861,1384329600"; 
   d="scan'208";a="476575555"
Date: Mon, 17 Feb 2014 08:07:34 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 07/11] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20140217160734.GU12219@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-8-git-send-email-alexander.shishkin@linux.intel.com>
 <20140217144436.GS27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217144436.GS27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So MAX_ORDER is 11, which gives us (11+12) 23bit or 8M max allocations, right?
> 
> Given this TOPA stuff is completely fucked in the first release, that's
> about all we can get it, right?
> 
> Now given you said 100s MB/s data rate for this itrace stuff, we're at
> ~0.1s traces. And that's in the very best case where we can actually get
> 8M.
> 
> Is that a workable amount

The PMI handler switches to a new buffer to allow longer traces
in memory.  It just costs one PMI.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
