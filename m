Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3BFSqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:46:45 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34037 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3BFSqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:46:44 -0500
Date: Wed, 6 Feb 2013 10:46:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] stop_machine: check work->done while handling
 enqueued works
Message-ID: <20130206184638.GA2875@htj.dyndns.org>
References: <CAJd=RBD=yMa1-iAm_i71U+KKRNYmXDTb6yZzW5aVAGHQ+zD8Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBD=yMa1-iAm_i71U+KKRNYmXDTb6yZzW5aVAGHQ+zD8Sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 08:36:01PM +0800, Hillf Danton wrote:
> To advoid invalid reference, updating work result is moved to
> cpu_stop_signal_done().

Can you please elaborate "why" in addition to "what"?  Do we actually
have a bug here, is it meant to be an independent cleanup, or is it
something which is necessary for later patches in the series?  What
are we achieving here?

>  /* signal completion unless @done is NULL */
> -static void cpu_stop_signal_done(struct cpu_stop_done *done, bool executed)
> +static void cpu_stop_signal_done(struct cpu_stop_done *done, bool
> executed, int ret)

Patch is corrupt.

> @@ -279,8 +281,6 @@ repeat:
>  		preempt_disable();
> 
>  		ret = fn(arg);
> -		if (ret)
> -			done->ret = ret;

If this is meant as a pure cleanup, I'm not sure it's an improvement.
You own your cpu_stop_done until you call cpu_stop_signal_done() on
it, so I don't think there's anything wrong with the current code.
The new code is different, not necessarily better.

Thanks.

-- 
tejun
