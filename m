Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaFEOYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:24:32 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:49604 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFEOYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:24:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140605141425.GB3588@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-6-git-send-email-eranian@google.com>
	<20140605134841.GL3213@twins.programming.kicks-ass.net>
	<CAHzUATjSd0Cio25RvwNaph0vFZYQB-pKBt=xz7C=_MhZvpFXxQ@mail.gmail.com>
	<20140605141150.GL6758@twins.programming.kicks-ass.net>
	<20140605141425.GB3588@twins.programming.kicks-ass.net>
Date: Thu, 5 Jun 2014 17:24:30 +0300
Message-ID: <CAHzUATgi3eRKs4V4KEsQTiiUAE_vLYOebGT501CRp9F9eim21w@mail.gmail.com>
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug workaround
From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 5:14 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jun 05, 2014 at 04:11:50PM +0200, Peter Zijlstra wrote:
>> > > x86_schedule_event()
>> > >   ->start_scheduling()
>> > >     spin_lock()
>> > >   ->get_event_constraints()
>> > >     intel_get_excl_constraints()
>> > >       kmalloc(.gfp=GFP_KERNEL)
>> > >
>> > > How can that ever work?
>>
>> > Are you saying it is illegal to call kmalloc() from
>> > this context?
>>
>> Nobody will come and arrest you for it, so no. Broken though. GFP_KERNEL
>> will attempt to sleep to wait for reclaim, and you're holding a
>> spinlock.

Ok, got it.

>
> Furthermore, even GFP_ATOMIC shouldn't be used because these are/should
> be raw_spinlocks and the zone->lock is a regular spinlock.
>
> So please look into the preallocation thing.

We will preallocate.
