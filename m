Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaJ1FcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:32:23 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55783 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaJ1FcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:32:19 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        dave@stgolabs.net, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
References: <20141020215633.717315139@infradead.org>
	<20141021162340.GA5508@gmail.com>
	<20141021170948.GA25964@node.dhcp.inet.fi>
	<20141021175603.GI3219@twins.programming.kicks-ass.net>
	<5448DB05.5050803@cn.fujitsu.com>
	<20141023110438.GQ21513@worktop.programming.kicks-ass.net>
	<20141024075423.GA24479@gmail.com>
	<20141024131440.GZ21513@worktop.programming.kicks-ass.net>
Date: Tue, 28 Oct 2014 14:32:16 +0900
In-Reply-To: <20141024131440.GZ21513@worktop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Fri, 24 Oct 2014 15:14:40 +0200")
Message-ID: <87mw8g7o9r.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, 24 Oct 2014 15:14:40 +0200, Peter Zijlstra wrote:
> On Fri, Oct 24, 2014 at 09:54:23AM +0200, Ingo Molnar wrote:
>> 
>> * Peter Zijlstra <peterz@infradead.org> wrote:
>> > Its what I thought initially, I tried doing perf record with and
>> > without, but then I ran into perf diff not quite working for me and I've
>> > yet to find time to kick that thing into shape.
>> 
>> Might be the 'perf diff' regression fixed by this:
>> 
>>   9ab1f50876db perf diff: Add missing hists__init() call at tool start
>> 
>> I just pushed it out into tip:master.
>
> I was on tip/master, so unlikely to be that as I was likely already
> having it.
>
> perf-report was affected too, for some reason my CONFIG_DEBUG_INFO=y
> vmlinux wasn't showing symbols (and I double checked that KASLR crap was
> disabled, so that wasn't confusing stuff either).
>
> When I forced perf-report to use kallsyms it works, however perf-diff
> doesn't have that option.
>
> So there's two issues there, 1) perf-report failing to generate useful
> output and 2) per-diff lacking options to force it to behave.

Did the perf-report fail to show any (kernel) symbols or are they wrong
symbols?  Maybe it's related to this:

https://lkml.org/lkml/2014/9/22/78

Thanks,
Namhyung
