Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3EFTdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:33:00 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:33781 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab3EFTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130506153517.GA3501@linux.vnet.ibm.com>
References: <20130505110351.GA4768@gmail.com>
	<CA+55aFzPHkCH7CVZ4tkaF91+=GLZAxxncTq0J9d6AKpSPqovZw@mail.gmail.com>
	<20130505212511.GC3659@linux.vnet.ibm.com>
	<20130506092537.GA8879@gmail.com>
	<20130506153517.GA3501@linux.vnet.ibm.com>
Date: Mon, 6 May 2013 12:32:58 -0700
X-Google-Sender-Auth: da_ERBeZvM-JjzJsYfdkrbdxvc4
Message-ID: <CA+55aFxYRDZvisB7iZ5a-bcp5_2pkvcC9Opk6=yJtjfK57EWTw@mail.gmail.com>
Subject: Re: [GIT PULL, RFC] Full dynticks, CONFIG_NO_HZ_FULL feature
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Fr?d?ric Weisbecker" <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 8:35 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>> I think Linus might have referred to my 'future plans' entry:

Indeed. I feel that HPC is entirely irrelevant to anybody,
*especially* HPC benchmarks. In real life, even HPC doesn't tend to
have the nice behavior their much-touted benchmarks have.

So as long as the NOHZ is for HPC-style loads, then quite frankly, I
don't feel it is worth it. The _only_ thing that makes it worth it is
that "future plans" part where it would actually help real loads.

>>
>> Interesting that HZ=1000 caused 8% overhead there. On a regular x86 server
>> PC I've measured the HZ=1000 overhead to pure user-space execution to be
>> around 1% (sometimes a bit less, sometimes a bit more).
>>
>> But even 1% is worth it.
>
> I believe that the difference is tick skew

Quite possibly it is also virtualization.

The VM people are the one who complain the loudest about how certain
things make their performance go down the toilet. And interrupts tend
to be high on that list, and unless you have hardware support for
virtual timer interrupts I can easily see a factor of four cost or
more.

And the VM people then flail around wildly to always blame everybody
else. *Anybody* else than the VM overhead itself.

It also depends a lot on architecture. The ia64 people had much bigger
problems with the timer interrupt than x86 ever did. Again, they saw
this mainly on the HPC benchmarks, because the benchmarks were
carefully tuned to have huge-page support and were doing largely
irrelevant things like big LINPACK runs, and the timer irq ended up
blowing their carefully tuned caches and TLB's out.

Never mind that nobody sane ever *cared*. Afaik, no real HPC load has
anything like that behavior, much less anything else. But they had
numbers to prove how bad it was, and it was a load with very stable
numbers.

Combine the two (bad HPC benchmarks and VM), and you can make an
argument for just about anything. And people have.

I am personally less than impressed with some of the benchmarks I've
seen, if it wasn't clear.

            Linus
