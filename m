Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3E1Tb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:31:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36114 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3E1TbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:31:25 -0400
Message-ID: <51A505DB.2090409@oracle.com>
Date: Tue, 28 May 2013 15:30:35 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130527 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com> <1368674141-10796-3-git-send-email-sasha.levin@oracle.com> <20130522091718.GE18810@twins.programming.kicks-ass.net>
In-Reply-To: <20130522091718.GE18810@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 05:17 AM, Peter Zijlstra wrote:
> On Wed, May 15, 2013 at 11:15:34PM -0400, Sasha Levin wrote:
>> --- /dev/null
>> +++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
>> @@ -0,0 +1,55 @@
>> +#ifndef _LIBLOCKDEP_LOCKDEP_H_
>> +#define _LIBLOCKDEP_LOCKDEP_H_
>> +
>> +#include <sys/prctl.h>
>> +#include <sys/syscall.h>
>> +#include <string.h>
>> +#include <limits.h>
>> +#include <linux/utsname.h>
>> +
>> +
>> +#define MAX_LOCK_DEPTH 2000UL
>> +
>> +#include "../../../include/linux/lockdep.h"
>> +
>> +struct task_struct {
>> +	u64 curr_chain_key;
>> +	int lockdep_depth;
>> +	unsigned int lockdep_recursion;
>> +	struct held_lock held_locks[MAX_LOCK_DEPTH];
>> +	gfp_t lockdep_reclaim_gfp;
>> +	int pid;
>> +	char comm[17];
>> +};
> 
> Whee that's a totally awesome MAX_LOCK_DEPTH.. :-)
> 
> Should we not also extend the other static allocations, or have you not
> yet ran into them? I would suspect that without proper classes we're
> bound to run out of class and link storage quite quickly.

I've changed MAX_LOCK_DEPTH just because I've actually hit it. I haven't
got around to hitting anything else, but I guess we could preemptively
send them hight.

What values would make sense here?


Thanks,
Sasha

