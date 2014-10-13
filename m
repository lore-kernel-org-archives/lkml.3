Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaJMPOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:14:18 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55350 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaJMPOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:14:17 -0400
MIME-Version: 1.0
In-Reply-To: <1413187299.5232.44.camel@marge.simpson.net>
References: <1413008458.5939.4.camel@localhost.localdomain>
	<1413187299.5232.44.camel@marge.simpson.net>
Date: Mon, 13 Oct 2014 21:14:14 +0600
Message-ID: <CADZ9YHiqyGGMRJFvghbkDO7iP=7niEnpOt_Cp8sMwLn+iA8ivA@mail.gmail.com>
Subject: Re: [ANNOUNCE] BLD-3.17 release.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/14, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> On Sat, 2014-10-11 at 12:20 +0600, Rakib Mullick wrote:
>> BLD (The Barbershop Load Distribution Algorithm) patch for Linux 3.17
>
> I had a curiosity attack, played with it a little.
>
Thanks for showing your interest!

> My little Q6600 box could be describes as being "micro-numa", with two
> pathetic little "nodes" connected by the worst interconnect this side of
> tin cans and string.  Communicating tasks sorely missed sharing cache.
>
> tbench
> 3.18.0-master
> Throughput 287.411 MB/sec  1 clients  1 procs  max_latency=1.614 ms
> 1.000
> Throughput 568.631 MB/sec  2 clients  2 procs  max_latency=1.942 ms
> 1.000
> Throughput 1069.75 MB/sec  4 clients  4 procs  max_latency=18.494 ms
> 1.000
> Throughput 1040.99 MB/sec  8 clients  8 procs  max_latency=17.364 ms
> 1.000
>
> 3.18.0-master-BLD                                                        vs
> master
> Throughput 261.986 MB/sec  1 clients  1 procs  max_latency=11.943 ms
> .911
> Throughput 264.461 MB/sec  2 clients  2 procs  max_latency=11.884 ms
> .465
> Throughput 476.191 MB/sec  4 clients  4 procs  max_latency=11.497 ms
> .445
> Throughput 558.236 MB/sec  8 clients  8 procs  max_latency=9.008 ms
> .536
>
>
> TCP_RR 4 unbound clients
> 3.18.0-master
> TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1
> (127.0.0.1) port 0 AF_INET
> Local /Remote
> Socket Size   Request  Resp.   Elapsed  Trans.
> Send   Recv   Size     Size    Time     Rate
> bytes  Bytes  bytes    bytes   secs.    per sec
>
> 16384  87380  1        1       30.00    72436.65
> 16384  87380  1        1       30.00    72438.55
> 16384  87380  1        1       30.00    72213.18
> 16384  87380  1        1       30.00    72493.48
>                                sum     289581.86     1.000
>
> 3.18.0-master-BLD
> TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1
> (127.0.0.1) port 0 AF_INET
> Local /Remote
> Socket Size   Request  Resp.   Elapsed  Trans.
> Send   Recv   Size     Size    Time     Rate
> bytes  Bytes  bytes    bytes   secs.    per sec
>
> 16384  87380  1        1       30.00    29014.09
> 16384  87380  1        1       30.00    28804.53
> 16384  87380  1        1       30.00    28999.40
> 16384  87380  1        1       30.00    28901.84
>                                sum     115719.86      .399 vs master
>
>
Okay. From the numbers above it's apparent that BLD isn't doing good,
atleast for the
kind of system that you have been using. I didn't had a chance to ran
it on any kind of
NUMA systems, for that reason on Kconfig, I've marked it as "Not
suitable for NUMA", yet.
Part of the reason is, I didn't manage to try it out myself and other
reason is, it's easy to
get things wrong if schedule domains are build improperly. I'm not
sure what was the
sched configuration in your case. BLD assumes (or kindof bliendly
believes systems
default sched domain topology) on wakeup tasks are cache hot and so
don't put those
task's on other sched domains, but if that isn't the case then perhaps
it'll miss out on
balancing oppourtunity, in that case CPU utilization will be improper.

Can you please share the perf stat of netperf runs? So, far I have
seen reduced context
switch numbers with -BLD with a drawback of huge increase of CPU
migration numbers.
But, the kind of systems I ran so far, it deemed too much CPU movement
didn't cost much.
But, it could be wrong for NUMA systems.

Thanks,
Rakib
