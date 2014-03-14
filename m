Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaCNONa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:13:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:10672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaCNON2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:13:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,655,1389772800"; 
   d="scan'208";a="472360835"
Date: Fri, 14 Mar 2014 07:13:00 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140314141300.GG3793@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140217143340.GR27965@twins.programming.kicks-ass.net>
 <530529FC.6080704@intel.com>
 <87siqqtlv6.fsf@ashishki-desk.ger.corp.intel.com>
 <20140310172440.GG13302@tassilo.jf.intel.com>
 <20140314104415.GS27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314104415.GS27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The other big problem is scalability. Even if it was somehow possible
> > to make this scheme work the IPIs for flushing would kill performance 
> > on any multi threaded client.  Given perf is not multi-threaded today, but
> > it doesn't seem a good idea to design the interface assuming no client ever
> > will be.
> 
> Well any mmap()ed interface that wants to swap buffers will have this
> same problem.

There's no need to swap buffers in a sane design. The perf ring buffer
or the ftrace buffer don't need this. There's no need for a PT buffer
to do so either. 

> 
> You can restrict the TLB flushing to the threads that poll() on the
> relevant events. This just means other threads will see old/partial
> data, but that shouldn't be a problem as they shouldn't be looking in
> the first place.

Then we get incoherent processes. You're not serious about that are you?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
