Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaBYLiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:38:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38772 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaBYLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:38:53 -0500
Date: Tue, 25 Feb 2014 12:38:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com, dave.martin@arm.com,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/7] perf: kill perf_event_context_type
Message-ID: <20140225113848.GO9987@twins.programming.kicks-ass.net>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-4-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392054264-23570-4-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:44:20PM +0000, Mark Rutland wrote:
> Currently perf_event_context::type is used to determine whether a
> context is cpu-bound or task-bound. However perf_event_context::task can
> be used to determine this just as cheaply, and requires no additional
> initialisation.
> 
> This patch removes perf_event_context::type, and modifies existing users
> to check check perf_event_context::task instead. The now unused enum
> perf_event_context_type is removed.

> @@ -7130,7 +7129,7 @@ SYSCALL_DEFINE5(perf_event_open,
>  		 * task or CPU context:
>  		 */
>  		if (move_group) {
> -			if (group_leader->ctx->type != ctx->type)
> +			if (group_leader->ctx->task != ctx->task)
>  				goto err_context;
>  		} else {
>  			if (group_leader->ctx != ctx)

That's not an equivalent statement. ctx->task (t1) != ctx->task (t2)
while they're still both of the same type.

Now I don't think you'll ever end up with different tasks in this case
so it might still work out; but you don't mention this and I'd have to
like think to make sure.
