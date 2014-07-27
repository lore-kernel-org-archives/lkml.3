Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaG0K3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 06:29:14 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:62458 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaG0K3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 06:29:12 -0400
Message-ID: <1406456949.5115.169.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Sun, 27 Jul 2014 12:29:09 +0200
In-Reply-To: <CA+80gGZ=raShFq9du3a_67=eLgx8DdEW+hUY377MiLHtKW23ZQ@mail.gmail.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	 <1406365137.5091.152.camel@marge.simpson.net>
	 <CA+80gGZRxXfabODZoFMoBju=j+7+Ne8sUYaKBPzo4c9kTjL8_g@mail.gmail.com>
	 <1406433735.5115.38.camel@marge.simpson.net>
	 <CA+80gGZ=raShFq9du3a_67=eLgx8DdEW+hUY377MiLHtKW23ZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 02:09 -0700, Sergey Oboguev wrote: 
> On Sat, Jul 26, 2014 at 9:02 PM, Mike Galbraith
> <umgwanakikbuti@gmail.com> wrote:
> > On Sat, 2014-07-26 at 11:30 -0700, Sergey Oboguev wrote:
> >> On Sat, Jul 26, 2014 at 1:58 AM, Mike Galbraith
> >> <umgwanakikbuti@gmail.com> wrote:
> >> > On Fri, 2014-07-25 at 12:45 -0700, Sergey Oboguev wrote:
> >> >> [This is a repost of the message from few day ago, with patch file
> >> >> inline instead of being pointed by the URL.]
> >> >>
> >> >> This patch is intended to improve the support for fine-grain parallel
> >> >> applications that may sometimes need to change the priority of their threads at
> >> >> a very high rate, hundreds or even thousands of times per scheduling timeslice.
> >> >>
> >> >> These are typically applications that have to execute short or very short
> >> >> lock-holding critical or otherwise time-urgent sections of code at a very high
> >> >> frequency and need to protect these sections with "set priority" system calls,
> >> >> one "set priority" call to elevate current thread priority before entering the
> >> >> critical or time-urgent section, followed by another call to downgrade thread
> >> >> priority at the completion of the section. Due to the high frequency of
> >> >> entering and leaving critical or time-urgent sections, the cost of these "set
> >> >> priority" system calls may raise to a noticeable part of an application's
> >> >> overall expended CPU time. Proposed "deferred set priority" facility allows to
> >> >> largely eliminate the cost of these system calls.
> >> >
> >> > So you essentially want to ship preempt_disable() off to userspace?
> >> >
> >>
> >> Only to the extent preemption control is already exported to the userspace and
> >> a task is already authorized to control its preemption by its RLIMIT_RTPRIO,
> >> RLIMIT_NICE and capable(CAP_SYS_NICE).
> >>
> >> DPRIO does not amplify a taks's capability to elevate its priority and block
> >> other tasks, it just reduces the computational cost of frequest
> >> sched_setattr(2) calls.
> 
> > You are abusing realtime
> 
> I am unsure why you would label priority ceiling for locks and priority
> protection for other forms of time-urgent sections as an "abuse".

Ok, maybe "abuse" is too strong.  I know there are reasons why people do
what they do, even when it may look silly to me.  I didn't like what I
saw in case you couldn't tell, but lucky you, you're not selling it to
me, you're selling it to maintainers.  I CCd them, so having voiced my
opinion, I'll shut up and listen.

-Mike

