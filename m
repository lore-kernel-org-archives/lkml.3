Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaHIT0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 15:26:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaHIT0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 15:26:35 -0400
Date: Sat, 9 Aug 2014 21:24:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [sched] Out of memory: Kill process 2999 (rc) score 9 or
	sacrifice child
Message-ID: <20140809192417.GA32704@redhat.com>
References: <20140809143034.GA28345@localhost> <20140809184616.GQ9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809184616.GQ9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Peter Zijlstra wrote:
>
> That would suggest we're failing to do the TASK_DEAD thing properly, and
> ARGH! bloody obvious why, see the this_rq() comment right before the
> finish_task_switch() call in context_switch().

Heh ;) and a similar comment in __schedule() after context_switch().

rq->dead_task or something similar should work I guess, but i should be
nullified before finish_lock_switch()...

Oleg.

