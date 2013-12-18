Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3LROWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:22:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:20337 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab3LROWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:22:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="426639466"
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
In-Reply-To: <20131218141125.GT21999@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com> <20131217161126.GL13532@twins.programming.kicks-ass.net> <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com> <20131218133439.GR21999@twins.programming.kicks-ass.net> <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com> <20131218141125.GT21999@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 18 Dec 2013 16:22:36 +0200
Message-ID: <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Dec 18, 2013 at 04:01:04PM +0200, Alexander Shishkin wrote:
>> > Why don't you start by explaining _why_ you need a second stream to
>> > begin with?
>> 
>> Oh, I'm sure I've explained it earlier ([1], [2])
>
> See, I didn't read 0 because that information gets lost and patches
> should be self explanatory, and i didn't get to the Intel driver yet
> because well, I got stuck in the generic code.

Sure. The general concept is more important than the actual driver at
this point anyway.

>> but why not. The data
>> in the second stream is generated at a rate which is hundreds of
>> megabytes per second per core. Decoding this data is ~1000 times slower
>> than generating it. Ergo, can't be done in kernel, needs to be exported
>> as-is to userspace for later retreival and decoding. Doing it via perf
>> stream means an extra copy, which at these rates is a waste. Ergo, a
>> second buffer.
>
> Still confused, if you cannot copy it into one buffer, then why can you
> copy it into a second buffer?

It's not copied, hardware writes directly into that second buffer.

I've done the same with BTS now (as Ingo suggested) and it also benefits
from this approach.

Regards,
--
Alex
