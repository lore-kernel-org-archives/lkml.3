Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaE1Xwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:52:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44515 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaE1Xwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:52:50 -0400
Message-ID: <538676A7.6090306@oracle.com>
Date: Wed, 28 May 2014 19:52:07 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
References: <5370EBE9.6@oracle.com> <20140514162943.GR30445@twins.programming.kicks-ass.net> <53739A9A.5010703@oracle.com> <20140514163535.GS30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140514163535.GS30445@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 12:35 PM, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 12:32:26PM -0400, Sasha Levin wrote:
>> > -----BEGIN PGP SIGNED MESSAGE-----
>> > Hash: SHA1
>> > 
>> > On 05/14/2014 12:29 PM, Peter Zijlstra wrote:
>>> > > On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
>>>> > >> Hi all,
>>>> > >> 
>>>> > >> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel I've stumbled on the following spew. Maybe related to the very recent change in freeing on task exit?
>>>> > >> 
>>>> > >> [ 2509.827261] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC [ 2509.830379] Dumping ftrace buffer: [ 2509.830379]    (ftrace buffer empty) [ 2509.830379] Modules linked in: [ 2509.830379] CPU: 47 PID: 43306 Comm: trinity-c126 Tainted: G        W     3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
>>> > > 
>>> > > Any particular trinity setup? And would you happen to have the seed of that run?
>> > 
>> > Nothing special about trinity options. 400 threads and blacklisting some of the
>> > destructive syscalls (umount, reboot, etc).
>> > 
>> > I don't have the seed, but that problem did reproduce again tonight so I can test
>> > out debug code if you have something in mind.
> Nah, I drew a pretty big blank, which is why I wanted to see if I could
> reproduce. If you could share your trinity cmdline I'd be much obliged.
> While I did manage to clone (the repo moved since last time) and build
> it, I'm not really that handy with it and want to avoid destroying my
> machine if possible ;-)

Anything I could do to help out with this? It reproduces pretty easily on my
configuration so I'd be happy to test out whatever might help.


Thanks,
Sasha
