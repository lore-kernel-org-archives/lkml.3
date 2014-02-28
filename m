Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaB1LcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:32:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53143 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaB1LcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:32:17 -0500
Date: Fri, 28 Feb 2014 12:32:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Mel Gorman <mgorman@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Subject: Re: [patch] rt,sched,numa: Move task_numa_free() to
 __put_task_struct(), which -rt offloads
Message-ID: <20140228113209.GK27965@twins.programming.kicks-ass.net>
References: <1393568591.6018.27.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393568591.6018.27.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 07:23:11AM +0100, Mike Galbraith wrote:
> 
> Bad idea:
> [  908.026136]  [<ffffffff8150ad6a>] rt_spin_lock_slowlock+0xaa/0x2c0
> [  908.026145]  [<ffffffff8108f701>] task_numa_free+0x31/0x130
> [  908.026151]  [<ffffffff8108121e>] finish_task_switch+0xce/0x100
> [  908.026156]  [<ffffffff81509c0a>] thread_return+0x48/0x4ae
> [  908.026160]  [<ffffffff8150a095>] schedule+0x25/0xa0
> [  908.026163]  [<ffffffff8150ad95>] rt_spin_lock_slowlock+0xd5/0x2c0
> [  908.026170]  [<ffffffff810658cf>] get_signal_to_deliver+0xaf/0x680
> [  908.026175]  [<ffffffff8100242d>] do_signal+0x3d/0x5b0
> [  908.026179]  [<ffffffff81002a30>] do_notify_resume+0x90/0xe0
> [  908.026186]  [<ffffffff81513176>] int_signal+0x12/0x17
> [  908.026193]  [<00007ff2a388b1d0>] 0x7ff2a388b1cf
> 
> Signed-off-by: Mike Galbraith <bitbucket@online.de>

Fair enough; thanks!
