Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaJNPGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:06:34 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:45038 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaJNPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:06:33 -0400
MIME-Version: 1.0
In-Reply-To: <1413223622.5146.68.camel@marge.simpson.net>
References: <1413008458.5939.4.camel@localhost.localdomain>
	<1413187299.5232.44.camel@marge.simpson.net>
	<CADZ9YHiqyGGMRJFvghbkDO7iP=7niEnpOt_Cp8sMwLn+iA8ivA@mail.gmail.com>
	<1413223622.5146.68.camel@marge.simpson.net>
Date: Tue, 14 Oct 2014 21:06:31 +0600
Message-ID: <CADZ9YHj2RAgZttgBXk6CEYGqe4h0QUwtw3Veuu2-Or1H-Sbe5Q@mail.gmail.com>
Subject: Re: [ANNOUNCE] BLD-3.17 release.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/14, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> On Mon, 2014-10-13 at 21:14 +0600, Rakib Mullick wrote:
>
>> Okay. From the numbers above it's apparent that BLD isn't doing good,
>> atleast for the
>> kind of system that you have been using. I didn't had a chance to ran
>> it on any kind of
>> NUMA systems, for that reason on Kconfig, I've marked it as "Not
>> suitable for NUMA", yet.
>
> (yeah, a NUMA box would rip itself to shreds)
>
>> Part of the reason is, I didn't manage to try it out myself and other
>> reason is, it's easy to
>> get things wrong if schedule domains are build improperly. I'm not
>> sure what was the
>> sched configuration in your case. BLD assumes (or kindof bliendly
>> believes systems
>> default sched domain topology) on wakeup tasks are cache hot and so
>> don't put those
>> task's on other sched domains, but if that isn't the case then perhaps
>> it'll miss out on
>> balancing oppourtunity, in that case CPU utilization will be improper.
>
> Even when you have only one socket with a big L3, you don't really want
> to bounce fast/light tasks around too frequently, L2 misses still hurt.
>
>> Can you please share the perf stat of netperf runs? So, far I have
>> seen reduced context
>> switch numbers with -BLD with a drawback of huge increase of CPU
>> migration numbers.
>
> No need, it's L2 misses.  Q6600 has no L3 to mitigate the miss pain.
>
I see.

>> But, the kind of systems I ran so far, it deemed too much CPU movement
>> didn't cost much.
>> But, it could be wrong for NUMA systems.
>
> You can most definitely move even very fast/light tasks too much within
> an L3, L2 misses can demolish throughput.  We had that problem.
>
So, L2 misses is the key here. So far I haven't tried to utilize
various sched domain flags, like. SD_SHARE_PKG_RESOURCE/_CPUPOWER etc.
Probably, integrating those might help? I'll take a look at those and
will try to see what happens, although testing will be problematic.

Thanks,
Rakib.
