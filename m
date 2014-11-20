Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbaKTXzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:55:36 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47676 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734AbaKTXza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:55:30 -0500
MIME-Version: 1.0
In-Reply-To: <20141120233920.GC25393@htj.dyndns.org>
References: <alpine.DEB.2.11.1411192251120.3909@nanos> <20141119225615.GA11386@lerouge>
 <alpine.DEB.2.11.1411200002330.3909@nanos> <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org> <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org> <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org> <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
 <20141120233920.GC25393@htj.dyndns.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Nov 2014 15:55:09 -0800
Message-ID: <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 3:39 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Nov 20, 2014 at 03:08:03PM -0800, Andy Lutomirski wrote:
>> > So, for now, all we need is adding nmi check in percpu accessors,
>> > right?
>> >
>>
>> What's the issue with nmi?  Page faults are supposed to nest correctly
>> inside nmi, right?
>
> Thought they couldn't.  Looking at the trace that Frederic linked, it
> looks like straight-out tracing function recursion due to an
> unexpected fault while holding a lock.  I don't think this can be
> annotated from percpu accessor side.  There's nothing special about
> the context.  :(

That doesn't appear to have anything to with nmi though, right?

Wouldn't this issue be fixed by moving the vmalloc_fault check into
do_page_fault before exception_enter?

--Andy
