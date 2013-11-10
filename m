Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab3KJERd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 23:17:33 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48977 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589Ab3KJERa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 23:17:30 -0500
MIME-Version: 1.0
In-Reply-To: <20131107090459.3be09ee4@gandalf.local.home>
References: <CAAVeFuJWKwAQ338R86O3WMarFDP2ZJDayLddGio9uXiXPsuyFA@mail.gmail.com>
 <20131107090459.3be09ee4@gandalf.local.home>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 10 Nov 2013 13:17:09 +0900
Message-ID: <CAAVeFuKzain=pJ7dpKWnZyaCa9BncTXOO2CM-YwS=9jCC466-Q@mail.gmail.com>
Subject: Re: Is there a notification mechanism for enabled/disabled trace events?
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven, thanks for your reply!

On Thu, Nov 7, 2013 at 11:04 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 7 Nov 2013 17:42:54 +0900
> Alexandre Courbot <gnurou@gmail.com> wrote:
>
>> Hi everyone,
>>
>> Trace events can be enabled through debugfs by e.g. writing '1' into
>> their enable node. This is a very useful feature as some tracing
>> functions can introduce overhead and we only want them active when
>> needed.
>>
>> There is one additional thing that I would need though, which is to be
>> notified when a given trace event is enabled or disabled.
>>
>> Here is why: I have a power monitoring hardware that can report how
>> much power is currently used by the system. Having this information
>> correlated with other traces (cpufreq, cpuidle, ...) is very useful ;
>> it can be done by repeatedly scheduling a work that probes the power
>> usage and traces it. The job should only be running when the power
>> monitoring trace event is enabled, but AFAIK there is no way to be
>> notified when it is enabled or disabled. So here are a few questions:
>
> I'm a little confused by this. Your power monitoring is only enabled
> when someone enables the power tracepoints? Why not have the user start
> monitoring and have it enable the tracepoints itself?

Mostly, for convenience reasons. There are quite a few user-space
tools that configure and control kernel tracing more conveniently,
using the trace events debugfs interface. Having a separate control to
enable current probing would add one step to the setup, and I wondered
if I could not reuse what exists already.

>> 1) Is there such a notification mechanism for trace events that I have missed?
>
> That you missed? Can you elaborate here.

I was just wondering if what I was looking for already existed - which
seems to be the case.

>> 2) If not, is there any objection to having one? I'd say my use-case
>> is not so uncommon and others would certainly benefit from it.
>>
>> 3) What would be the right place to have it? ftrace_event_reg() looks
>> like a good place to call a notifier chain, however I'm not sure where
>> the notifier head should be stored, due to my poor understanding of
>> ftrace.
>
> There is a way to hard code a notifier for tracepoints, look at how
> TRACE_EVENT_FN() is used (include/trace/events/syscalls.h)
>
> But having a generic notifier may not be too hard or invasive to
> implement.

TRACE_EVENT_FN() is actually what I was looking for! Using it and a
few registration functions for drivers to be notified when the event's
status changes, it is quite easy to achieve what I wanted.

With that in mind, it is probably not worth to make the trace events
bigger by adding a generic notification mechanism to them, unless more
potential users show up.

Thanks!
Alex.
