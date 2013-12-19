Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab3LSLR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:17:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:64632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab3LSLR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:17:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="427155295"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow tracing units
In-Reply-To: <20131219103134.GD30183@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com> <20131217161126.GL13532@twins.programming.kicks-ass.net> <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com> <20131218133439.GR21999@twins.programming.kicks-ass.net> <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com> <20131218141125.GT21999@twins.programming.kicks-ass.net> <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com> <20131218150900.GU21999@twins.programming.kicks-ass.net> <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com> <20131219103134.GD30183@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 19 Dec 2013 13:17:51 +0200
Message-ID: <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, Dec 19, 2013 at 09:53:44AM +0200, Alexander Shishkin wrote:
>> Yes and some implementations of PT have the same issue, but you can do a
>> sufficiently large high order allocation and map it to userspace and
>> still no copying (or parsing/decoding) in kernel space required.
>
> What's sufficiently large? The largest we could possibly allocate is
> something like 4k^11 which is 8M or so. That's not all that big given
> you keep saying it generates in the order of 100 MB/s.

One chunk is 8M. You can have as many as the buddy allocator permits you
to have. When you get a PMI, you simply switch one chunk for another and
on the tracing goes.

> Also, 'some implementations', that sounds like a fail right there. Why
> are there already different implementations, and some which such stupid
> design, of something this new?
>
> How about just saying NO to the ones that requires physically contiguous
> allocations?

No reason to leave those out, because they are still extremely useful
for tracing and fit perfectly fine in a model with two buffers.

Regards,
--
Alex
