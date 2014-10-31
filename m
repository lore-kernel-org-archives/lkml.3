Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbaJaWnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbaJaWnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:43:07 -0400
Date: Fri, 31 Oct 2014 23:42:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peter@hurleysoftware.com,
        rjw@rjwysocki.net, torvalds@linux-foundation.org, tglx@linutronix.de,
        eparis@redhat.com, umgwanakikbuti@gmail.com, marcel@holtmann.org,
        ebiederm@xmission.com, davem@davemloft.net, fengguang.wu@intel.com
Subject: Re: [PATCH 7/7] sched: Use WARN_ONCE for the might_sleep()
	TASK_RUNNING test
Message-ID: <20141031224237.GA29704@redhat.com>
References: <20141031111037.936236584@infradead.org> <20141031111549.857381983@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031111549.857381983@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31, Peter Zijlstra wrote:
>
> In some cases this can trigger a true flood of output.
>
> Requested-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  kernel/sched/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7301,7 +7301,7 @@ void __might_sleep(const char *file, int
>  	 * since we will exit with TASK_RUNNING make sure we enter with it,
>  	 * otherwise we will destroy state.
>  	 */
> -	if (WARN(current->state != TASK_RUNNING,
> +	if (WARN_ONCE(current->state != TASK_RUNNING,

Agreed, but sorry for off-topic, can't resist.

Sometimes I hate WARN_ONCE() because you can't reproduce the problem
once again without reboot.

Perhaps WARN_ON_RATELIMIT() should be used more often (not sure about
this particular case). Or, perhaps, we can add a special section for
these "__warned" variables and add, say, sysctl which clears that
section ?

Oleg.

