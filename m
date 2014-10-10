Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaJJK4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:56:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44968 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaJJK4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:56:22 -0400
Date: Fri, 10 Oct 2014 12:56:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@arm.com>, Kirill V Tkhai <tkhai@yandex.ru>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/deadline: do not try to push tasks if pinned task
 switches to dl
Message-ID: <20141010105614.GA3343@worktop.programming.kicks-ass.net>
References: <1412908997-15396-1-git-send-email-wanpeng.li@linux.intel.com>
 <20141010101016.GJ10832@worktop.programming.kicks-ass.net>
 <5437B462.4050102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5437B462.4050102@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 06:26:42PM +0800, Wanpeng Li wrote:
> 
> 于 10/10/14, 6:10 PM, Peter Zijlstra 写道:
> >On Fri, Oct 10, 2014 at 10:43:17AM +0800, Wanpeng Li wrote:
> >>As Kirill mentioned(https://lkml.org/lkml/2013/1/29/118):
> >>| If rq has already had 2 or more pushable tasks and we try to add a
> >>| pinned task then call of push_rt_task will just waste a time.
> >>
> >>Just switched pinned task is not able to be pushed. If the rq had had
> >>several dl tasks before they have already been considered as candidates
> >>to be pushed (or pulled). This patch does the same behavior as rt class
> >>which introduced by commit 104479 (sched/rt: Do not try to push tasks
> >>if pinned task switches to RT).
> >Checkpatch rightly complains:
> >
> >ERROR: Please use 12 or more chars for the git commit ID like: 'commit 10447917551e ("sched/rt: Do not try to push tasks if pinned task switches to RT")'
> >#12:
> >which introduced by commit 104479 (sched/rt: Do not try to push tasks
> 
> I also got this warning before send out the patch, however, I check 6 chars
> is enough for this commit. Anyway, I will send a newer version later.

It is currently, it might not be in the future. I've already had hash
collisions with 8 char hashes. And the fact thats it in the changelog
means it can (and therefore) will be referenced at some point in the
future. If by that point there is a collision...
