Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbbAHFcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 00:32:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47533 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbbAHFcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 00:32:45 -0500
Message-ID: <1420694794.5279.33.camel@marge.simpson.net>
Subject: Re: sched_yield() call on Linux Kernel 2.6.39 is not behaving
 correct
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yogesh Ahire <yogesh02061983@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2015 06:26:34 +0100
In-Reply-To: <CAH86sKKCbZ7CYDEgAnpiVH+7TZNOjziUYOJSWHEpQyY3eUSniA@mail.gmail.com>
References: <CAH86sKKCbZ7CYDEgAnpiVH+7TZNOjziUYOJSWHEpQyY3eUSniA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 16:30 -0500, Yogesh Ahire wrote: 
> Hi All,
> 
> I have a system with multiple CPU cores.  I have multiple threads
> assigned to particular CPU. Among these threads the main thread calls
> sched_yield() if it has nothing to do, I am hoping that doing so will
> give chance to other threads to run. But the strange behavior of
> sched_yield() is , even if there are ready-to-runs tasks on this CPU
> waiting for their turn, the task which calls sched_yield() is always
> running ( get scheduled) and not giving chance to any other task to
> run. It is consuming 100% of CPU. Is sched_yield() is broken on 2.6
> Kernel?

Nope, your expectation is likely busted.  sched_yield() for a fair class
task is merely a resched check in CFS.  IFF there's a runnable task
that's more deserving by the CFS definition thereof, it'll initiate a
context switch, otherwise it's a non-free noop.  For realtime class
tasks, behavior is predictable, the scheduler WILL initiate a context
switch IFF there is a runnable task of >= yielding tasks priority on the
same CPU.  If you depend on a context switch happening in any other
circumstance, you're gonna be seriously disappointed.

-Mike

