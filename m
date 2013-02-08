Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab3BHIVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:21:30 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58128 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790Ab3BHIV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:21:29 -0500
X-AuditID: 9c930179-b7c24ae00000119c-0b-5114b5877e8d
From: Namhyung Kim <namhyung@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] stop_machine: check work->done while handling enqueued works
References: <CAJd=RBD4ZJN7uXQ5xY1GF14j_DydDQEpuZNct-UiNXTBARpQSQ@mail.gmail.com>
Date: Fri, 08 Feb 2013 17:21:27 +0900
In-Reply-To: <CAJd=RBD4ZJN7uXQ5xY1GF14j_DydDQEpuZNct-UiNXTBARpQSQ@mail.gmail.com>
	(Hillf Danton's message of "Fri, 8 Feb 2013 11:39:56 +0800")
Message-ID: <87txpnqkqg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hillf,

On Fri, 8 Feb 2013 11:39:56 +0800, Hillf Danton wrote:
> The comment just above cpu_stop_signal_done() says it is uncertain that
> the input @done is valid, and the works enqueued through the function
> stop_one_cpu_nowait() do carry no done, thus we have to check if it is
> valid when updating work result.

The only user of stop_one_cpu_nowait() is the scheduler active balancer
and active_load_balance_cpu_stop() always returns 0.  But I think this
change makes its sense and the code evolves, so:

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>
> --- a/kernel/stop_machine.c	Thu Feb  7 20:03:10 2013
> +++ b/kernel/stop_machine.c	Fri Feb  8 11:07:40 2013
> @@ -279,7 +279,7 @@ repeat:
>  		preempt_disable();
>
>  		ret = fn(arg);
> -		if (ret)
> +		if (ret && done != NULL)
>  			done->ret = ret;
>
>  		/* restore preemption and check it's still balanced */
> --
