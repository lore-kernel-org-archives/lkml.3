Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3LSHyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:54:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:27341 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3LSHyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:54:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="446822367"
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
In-Reply-To: <20131218150900.GU21999@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com> <20131217161126.GL13532@twins.programming.kicks-ass.net> <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com> <20131218133439.GR21999@twins.programming.kicks-ass.net> <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com> <20131218141125.GT21999@twins.programming.kicks-ass.net> <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com> <20131218150900.GU21999@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 19 Dec 2013 09:53:44 +0200
Message-ID: <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Dec 18, 2013 at 04:22:36PM +0200, Alexander Shishkin wrote:
>> > Still confused, if you cannot copy it into one buffer, then why can you
>> > copy it into a second buffer?
>> 
>> It's not copied, hardware writes directly into that second buffer.
>
> Where's the PT documentation? I can't find it in the SDM and your ISA
> extensions link is a generic Intel website which is friggin useless
> (like all corporate websites strive to be).

[1]

> Your actual PT patch doesn't describe how the things works either, and
> while I could go read the code, I'm too lazy.
>
> The thing is; why can't you zero-copy whatever buffer the hardware
> writes into, into the normal buffer?

I'm not sure I understand. You mean, have the buffer split between perf
data and trace data?

> Machinery like that would also be useful to zero-copy bits out of the
> buffer right into the page-cache.

Please elaborate.

>> I've done the same with BTS now (as Ingo suggested) and it also benefits
>> from this approach.
>
> The problem with DS is that it needs physically contiguous pages is it
> not? So you cannot really allocate a large buffer, and you end up
> needing to copy or swizzle stuff.

Yes and some implementations of PT have the same issue, but you can do a
sufficiently large high order allocation and map it to userspace and
still no copying (or parsing/decoding) in kernel space required.

[1] http://download-software.intel.com/sites/default/files/managed/71/2e/319433-017.pdf

Regards,
--
Alex
