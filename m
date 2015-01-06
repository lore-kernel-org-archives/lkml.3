Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbbAFKft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:35:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:53275 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbbAFKfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:35:48 -0500
Date: Tue, 6 Jan 2015 11:35:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/fair: Fix RCU stall upon ENOMEM at
 sched_create_group().
Message-ID: <20150106103533.GO29390@twins.programming.kicks-ass.net>
References: <201412252210.GCC30204.SOMVFFOtQJFLOH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412252210.GCC30204.SOMVFFOtQJFLOH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 10:10:45PM +0900, Tetsuo Handa wrote:
> >From 052595ab1a1d1c5668d9de61395c9cc17694597e Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Thu, 25 Dec 2014 15:51:21 +0900
> Subject: [PATCH] sched/fair: Fix RCU stall upon ENOMEM at sched_create_group().
> 
> When alloc_fair_sched_group() in sched_create_group() failed,
> free_sched_group() is called, and free_fair_sched_group() is called by
> free_sched_group(). Since destroy_cfs_bandwidth() is called by
> free_fair_sched_group() without calling init_cfs_bandwidth(),
> RCU stall occurs at hrtimer_cancel().
> 

Thanks
