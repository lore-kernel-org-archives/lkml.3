Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751Ab3E2LMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:12:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51348 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965579Ab3E2LMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:12:00 -0400
Date: Wed, 29 May 2013 13:11:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130529111152.GE12193@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-3-git-send-email-sasha.levin@oracle.com>
 <20130522091718.GE18810@twins.programming.kicks-ass.net>
 <51A505DB.2090409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A505DB.2090409@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 03:30:35PM -0400, Sasha Levin wrote:
> On 05/22/2013 05:17 AM, Peter Zijlstra wrote:
> > On Wed, May 15, 2013 at 11:15:34PM -0400, Sasha Levin wrote:
> >> --- /dev/null
> >> +++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
> >> @@ -0,0 +1,55 @@
> >> +#ifndef _LIBLOCKDEP_LOCKDEP_H_
> >> +#define _LIBLOCKDEP_LOCKDEP_H_
> >> +
> >> +#include <sys/prctl.h>
> >> +#include <sys/syscall.h>
> >> +#include <string.h>
> >> +#include <limits.h>
> >> +#include <linux/utsname.h>
> >> +
> >> +
> >> +#define MAX_LOCK_DEPTH 2000UL
> >> +
> >> +#include "../../../include/linux/lockdep.h"
> >> +
> >> +struct task_struct {
> >> +	u64 curr_chain_key;
> >> +	int lockdep_depth;
> >> +	unsigned int lockdep_recursion;
> >> +	struct held_lock held_locks[MAX_LOCK_DEPTH];
> >> +	gfp_t lockdep_reclaim_gfp;
> >> +	int pid;
> >> +	char comm[17];
> >> +};
> > 
> > Whee that's a totally awesome MAX_LOCK_DEPTH.. :-)
> > 
> > Should we not also extend the other static allocations, or have you not
> > yet ran into them? I would suspect that without proper classes we're
> > bound to run out of class and link storage quite quickly.
> 
> I've changed MAX_LOCK_DEPTH just because I've actually hit it. I haven't
> got around to hitting anything else, but I guess we could preemptively
> send them hight.
> 
> What values would make sense here?

Dunno, I suppose we can deal with that when we hit them ;-)
