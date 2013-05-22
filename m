Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3EVJRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:17:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38005 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3EVJRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:17:23 -0400
Date: Wed, 22 May 2013 11:17:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130522091718.GE18810@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-3-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368674141-10796-3-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:15:34PM -0400, Sasha Levin wrote:
> --- /dev/null
> +++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
> @@ -0,0 +1,55 @@
> +#ifndef _LIBLOCKDEP_LOCKDEP_H_
> +#define _LIBLOCKDEP_LOCKDEP_H_
> +
> +#include <sys/prctl.h>
> +#include <sys/syscall.h>
> +#include <string.h>
> +#include <limits.h>
> +#include <linux/utsname.h>
> +
> +
> +#define MAX_LOCK_DEPTH 2000UL
> +
> +#include "../../../include/linux/lockdep.h"
> +
> +struct task_struct {
> +	u64 curr_chain_key;
> +	int lockdep_depth;
> +	unsigned int lockdep_recursion;
> +	struct held_lock held_locks[MAX_LOCK_DEPTH];
> +	gfp_t lockdep_reclaim_gfp;
> +	int pid;
> +	char comm[17];
> +};

Whee that's a totally awesome MAX_LOCK_DEPTH.. :-)

Should we not also extend the other static allocations, or have you not
yet ran into them? I would suspect that without proper classes we're
bound to run out of class and link storage quite quickly.


