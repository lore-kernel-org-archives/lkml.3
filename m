Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaJXNsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:48:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbaJXNsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:48:08 -0400
Date: Fri, 24 Oct 2014 15:48:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141024134800.GC21513@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20141022144543.GV12706@worktop.programming.kicks-ass.net>
 <87tx2t27yb.fsf@ashishki-desk.ger.corp.intel.com>
 <20141024115131.GY21513@worktop.programming.kicks-ass.net>
 <87wq7pd5sw.fsf@ashishki-desk.ger.corp.intel.com>
 <20141024130228.GM3219@twins.programming.kicks-ass.net>
 <87tx2td2rt.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx2td2rt.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 04:18:46PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:

> Ah, I see what you mean. The main point of this whole reserved region
> proposal is that one shouldn't have to update one's kernel to enable new
> PT packets by doing -e intel_pt/config=0xf00d/, if one is CAP_SYS_ADMIN.
> 
> > No need to probe in that case. That is the same thing we do for all
> > unenumerated model specific things.
> 
> They are, actually, enumerated, we just want to be able to enable them
> before they are. If the driver is aware of feature X, it can test for it
> in CPUID and allow/disallow it based on that.

If you've got hardware that 'exposes' functionality not enumerated in
CPUID you have the capability of modifying the kernel.

And while it might seem like a cute feature when you have early
hardware, that is no reason to make the code horrible. Either just patch
your firmware such that CPUID reports the right bits for your hardware
or frob the kernel.


