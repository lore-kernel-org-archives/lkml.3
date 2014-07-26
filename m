Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbaGZI7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:59:05 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:42386 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaGZI7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:59:01 -0400
Message-ID: <1406365137.5091.152.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Sat, 26 Jul 2014 10:58:57 +0200
In-Reply-To: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 12:45 -0700, Sergey Oboguev wrote: 
> [This is a repost of the message from few day ago, with patch file
> inline instead of being pointed by the URL.]
> 
> This patch is intended to improve the support for fine-grain parallel
> applications that may sometimes need to change the priority of their threads at
> a very high rate, hundreds or even thousands of times per scheduling timeslice.
> 
> These are typically applications that have to execute short or very short
> lock-holding critical or otherwise time-urgent sections of code at a very high
> frequency and need to protect these sections with "set priority" system calls,
> one "set priority" call to elevate current thread priority before entering the
> critical or time-urgent section, followed by another call to downgrade thread
> priority at the completion of the section. Due to the high frequency of
> entering and leaving critical or time-urgent sections, the cost of these "set
> priority" system calls may raise to a noticeable part of an application's
> overall expended CPU time. Proposed "deferred set priority" facility allows to
> largely eliminate the cost of these system calls.

So you essentially want to ship preempt_disable() off to userspace?

(smiles wickedly, adds CCs)

-Mike

> Instead of executing a system call to elevate its thread priority, an
> application simply writes its desired priority level to a designated memory
> location in the userspace. When the kernel attempts to preempt the thread...

