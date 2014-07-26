Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaGZSak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 14:30:40 -0400
Received: from mail-qa0-f66.google.com ([209.85.216.66]:53065 "EHLO
	mail-qa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaGZSaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 14:30:39 -0400
MIME-Version: 1.0
In-Reply-To: <1406365137.5091.152.camel@marge.simpson.net>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<1406365137.5091.152.camel@marge.simpson.net>
Date: Sat, 26 Jul 2014 11:30:38 -0700
Message-ID: <CA+80gGZRxXfabODZoFMoBju=j+7+Ne8sUYaKBPzo4c9kTjL8_g@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 1:58 AM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Fri, 2014-07-25 at 12:45 -0700, Sergey Oboguev wrote:
>> [This is a repost of the message from few day ago, with patch file
>> inline instead of being pointed by the URL.]
>>
>> This patch is intended to improve the support for fine-grain parallel
>> applications that may sometimes need to change the priority of their threads at
>> a very high rate, hundreds or even thousands of times per scheduling timeslice.
>>
>> These are typically applications that have to execute short or very short
>> lock-holding critical or otherwise time-urgent sections of code at a very high
>> frequency and need to protect these sections with "set priority" system calls,
>> one "set priority" call to elevate current thread priority before entering the
>> critical or time-urgent section, followed by another call to downgrade thread
>> priority at the completion of the section. Due to the high frequency of
>> entering and leaving critical or time-urgent sections, the cost of these "set
>> priority" system calls may raise to a noticeable part of an application's
>> overall expended CPU time. Proposed "deferred set priority" facility allows to
>> largely eliminate the cost of these system calls.
>
> So you essentially want to ship preempt_disable() off to userspace?
>

Only to the extent preemption control is already exported to the userspace and
a task is already authorized to control its preemption by its RLIMIT_RTPRIO,
RLIMIT_NICE and capable(CAP_SYS_NICE).

DPRIO does not amplify a taks's capability to elevate its priority and block
other tasks, it just reduces the computational cost of frequest
sched_setattr(2) calls.

>
> -Mike
>
>> Instead of executing a system call to elevate its thread priority, an
>> application simply writes its desired priority level to a designated memory
>> location in the userspace. When the kernel attempts to preempt the thread...

- Sergey
