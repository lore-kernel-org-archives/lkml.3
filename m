Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbaGYJFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:05:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:55130 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759797AbaGYJFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:44 -0400
Date: Fri, 25 Jul 2014 11:05:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel J Blueman <daniel@numascale.com>
cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Hillf Danton <dhillf@gmail.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
        Steffen Persvold <sp@numascale.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.14] core onlining/hotplug regression
In-Reply-To: <53D20C2E.3070902@numascale.com>
Message-ID: <alpine.DEB.2.10.1407251059130.23352@nanos>
References: <53D20C2E.3070902@numascale.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Daniel J Blueman wrote:
> On a larger x86 system with 1728 cores, 3.15(.6) asserts on
> smpboot_thread_fn's td->cpu != smp_processor_id() consistently after ~1500
> cores are online.
> 
> Reverting the only directly related changes I could find [1,2] doesn't help.
> Debugging indicates there is a race where the created thread is quickly
> migrated to core 0 when this occurs, since smp_processor_id returns 0 in these
> cases. Thomas introduced a thread parked state to fix related issues a year
> back. Linux 3.14(.13) boots just nice.

Weird. Commits [1,2] are definitely not the culprits.
 
> Full boot output is at:
> https://resources.numascale.com/linux-315-thread-mig.txt

Not really helpful, as we don't see what causes it. We just see the
wreckage.
 
> Any theories so far? I'll start bisecting when I have full access to the
> system again in a week and I'll do some more debugging with intermittent
> access before then.

One thing you could try is enabling tracing.

    "ftrace=function ftrace_dump_on_oops"

It'll take a looooong time to spill out the traces, but that should
give us the root cause precisely.

Thanks,

	tglx


