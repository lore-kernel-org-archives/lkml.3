Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaBRChC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:37:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:53689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbaBRChA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:37:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,864,1389772800"; 
   d="scan'208";a="457144260"
Date: Mon, 17 Feb 2014 18:36:59 -0800
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
Message-ID: <20140218023659.GV12219@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140217143340.GR27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217143340.GR27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not convinced it needs to be a PERF_RECORD_SAMPLE; but some
> PERF_RECORD_* type for sure. 

Adding a header shouldn't be a problem, it's merely wasting 4K.

> Also it must allow interleaving with other > events.

But can you describe a concrete use case where interleaving is better?

I'm not aware of any. Anything that could be usefully interleaved
can just be in the side band stream, and if you want a unified uncompressed 
stream you just run perf inject. The standard tools don't care for 
it as they have to reorder everything anyways to deal with multi
CPU reordering.

Your scheme is very complex and adds a lot of use restrictions 
over the current code, so there should be a good reason for it
at least.

Especially the TLB hac^wproposal sounds horrible to me, compared
to the straight forward zero copy ring buffer used today.

-Andi

