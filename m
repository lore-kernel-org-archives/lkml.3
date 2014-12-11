Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbaLKDeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:34:21 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50876 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529AbaLKDeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:34:20 -0500
Message-ID: <1418268856.5263.46.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/fair: change where we report sched stats
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: bmaurer@fb.com, rkroll@fb.com, kernel-team@fb.com, mingo@redhat.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 11 Dec 2014 04:34:16 +0100
In-Reply-To: <5488BFC5.3080001@fb.com>
References: <1418149315-30173-1-git-send-email-jbacik@fb.com>
	 <1418192604.5312.28.camel@marge.simpson.net> <5488BFC5.3080001@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 16:48 -0500, Josef Bacik wrote: 
> On 12/10/2014 01:23 AM, Mike Galbraith wrote:
> > On Tue, 2014-12-09 at 13:21 -0500, Josef Bacik wrote:
> >
> >> This patch moves stat stuff to after the schedule, right as we are waking up,
> >
> > But sleep/block ends when the task is awakened/enqueued, not when it
> > gets the CPU.  You're adding scheduling latency, breaking accounting.
> >
> 
> Yes I'm aware of that.  I don't care if the delay time is slightly 
> higher than normal, I care about knowing exactly why we were sleeping to 
> begin with.  I suppose I could leave the accounting part where it is and 
> then just fire the tracepoint when it's put on the CPU so we get the 
> best of both worlds, but honestly I don't feel like adding the extra 
> scheduling latency into the accounting is that big of a deal.  Thanks,

I think sleep/iowait should remain what they are, sleep/iowait end at
wakeup.  I don't think waker trace is useless either for that matter.
Who/when ends a sleep period is just as much a part of the picture as
what triggered that sleep.  Waker scheduling latency, thumb twiddling
etc. extend sleep.

Shrug, maintainer call.  I don't recall ever having any difficulty
determining why a task went to sleep, so don't get it.

-Mike

