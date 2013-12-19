Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3LSObA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:31:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:24049 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab3LSOa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:30:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="446996223"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow tracing units
In-Reply-To: <20131219123955.GA18186@gmail.com>
References: <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com> <20131218133439.GR21999@twins.programming.kicks-ass.net> <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com> <20131218141125.GT21999@twins.programming.kicks-ass.net> <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com> <20131218150900.GU21999@twins.programming.kicks-ass.net> <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com> <20131219103134.GD30183@twins.programming.kicks-ass.net> <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com> <20131219112812.GY21999@twins.programming.kicks-ass.net> <20131219123955.GA18186@gmail.com>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 19 Dec 2013 16:30:53 +0200
Message-ID: <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Thu, Dec 19, 2013 at 01:17:51PM +0200, Alexander Shishkin wrote:
>> > Peter Zijlstra <peterz@infradead.org> writes:
>> > 
>> > > On Thu, Dec 19, 2013 at 09:53:44AM +0200, Alexander Shishkin wrote:
>> > >> Yes and some implementations of PT have the same issue, but you can do a
>> > >> sufficiently large high order allocation and map it to userspace and
>> > >> still no copying (or parsing/decoding) in kernel space required.
>> > >
>> > > What's sufficiently large? The largest we could possibly allocate is
>> > > something like 4k^11 which is 8M or so. That's not all that big given
>> > > you keep saying it generates in the order of 100 MB/s.
>> > 
>> > One chunk is 8M. You can have as many as the buddy allocator permits you
>> > to have. When you get a PMI, you simply switch one chunk for another and
>> > on the tracing goes.
>> 
>> This document you referred me to looks to specify something with a
>> proper s/g implementation; called ToPA. There doesn't appear to be a
>> limit to the linked entries and you can specify a size per entry, and I
>> don't see anywhere why 4k would be bad.
>> 
>> That said, I'm still reading..
>> 
>> > > Also, 'some implementations', that sounds like a fail right there. Why
>> > > are there already different implementations, and some which such stupid
>> > > design, of something this new?
>> > >
>> > > How about just saying NO to the ones that requires physically contiguous
>> > > allocations?
>> > 
>> > No reason to leave those out, because they are still extremely useful
>> > for tracing and fit perfectly fine in a model with two buffers.
>> 
>> Maybe; but lets start with the sane hardware. Then we'll look at the 
>> amount of pain needed to support these broken pieces of crap and 
>> decide later.
>> 
>> So drop all support for crappy hardware now.
>
> Absolutely agreed ...
>
> The thing is, BTS itself is rarely used (and not primarily because 
> it's slow, but because its tooling and thus its utility is poor), so 
> the last thing we want is another piece of broken hardware with a 
> quirky software interface to it that tooling has trouble utilizing.

Or the interface and implementation of BTS support in the kernel
discourage its use and that is why it is so rarely used.

What I'm proposing is a unified interface for trace units to export
their traces and not only the "non-crappy" ones, in a way that won't
discourage its use from day one.

So I'd like to steer away from the ways in which hardware can be broken
and talk about a usable interface, to begin with.

Regargs,
--
Alex
