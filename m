Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792Ab3GWRqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:46:18 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:50305 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab3GWRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:46:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130723165739.GD27075@twins.programming.kicks-ass.net>
References: <1374188619-19220-1-git-send-email-andi@firstfloor.org>
	<20130723083834.GS27075@twins.programming.kicks-ass.net>
	<20130723161334.GQ6123@two.firstfloor.org>
	<20130723165739.GD27075@twins.programming.kicks-ass.net>
Date: Tue, 23 Jul 2013 19:46:14 +0200
Message-ID: <CABPqkBSAQzcBaJ9mxRaK8k9F5whzA=H2J==heEi81moF_s00wQ@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Enable PEBS mode automatically for
 mem-{loads,stores} v3
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 6:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 23, 2013 at 06:13:34PM +0200, Andi Kleen wrote:
>> On Tue, Jul 23, 2013 at 10:38:34AM +0200, Peter Zijlstra wrote:
>> > On Thu, Jul 18, 2013 at 04:03:39PM -0700, Andi Kleen wrote:
>> > > From: Andi Kleen <ak@linux.intel.com>
>> > >
>> > > [The patch to enable this in the user tools has been sent separately]
>> > >
>> > > With the earlier patches to automatically try cpu// and add
>> > > a precise sys attribute, we can now enable PEBS for the mem-loads,
>> > > mem-stores events everywhere.
>> > >
>> > > This allows to use
>> > >
>> > > perf record -e mem-loads ...
>> > >
>> > > instead of
>> > >
>> > > perf record -e cpu/mem-loads/p ...
>> > >
>> > > Always use precise=2 even though it is costly pre-Haswell
>> >
>> > This Changelog fails to give a reason _why_ we'd want to do this.
>>
>> The first is much nicer to type and understand? Just in the spirit of
>> making perf easier to use.
>
> And here I was thinking that maybe these events don't make sense without
> pebs or so. But no, rather than giving an actual useful reason you'd
> have me look things up myself. *sigh*

The loads events using LATENCY_ABOVE_THRESHOLD do not count anything
without PEBS (that's for all processors pre-Haswell).

As for forcing precise=2, I think that is what people would expect,
i.e., point me
to the load/store instruction. Experts can still force precise=1 because I think
the parser uses the value of the last precise= instance.
