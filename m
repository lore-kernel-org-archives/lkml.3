Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaGVPrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:47:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbaGVPrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:47:17 -0400
Message-ID: <53CE875F.5040007@redhat.com>
Date: Tue, 22 Jul 2014 11:46:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@parallels.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mingo@kernel.org,
        pjt@google.com
Subject: Re: [PATCH] sched: update last_balance only when actually balanced
References: <20140722022121.4589c63b@annuminas.surriel.com> <20140722120445.GB3935@laptop>
In-Reply-To: <20140722120445.GB3935@laptop>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/22/2014 08:04 AM, Peter Zijlstra wrote:

>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c index
>> 45943b2..4f7fee2 100644 --- a/kernel/sched/fair.c +++
>> b/kernel/sched/fair.c @@ -7187,7 +7187,9 @@ static void
>> rebalance_domains(struct rq *rq, enum cpu_idle_type idle) */ idle
>> = idle_cpu(cpu) ? CPU_IDLE : CPU_NOT_IDLE; } -			sd->last_balance
>> = jiffies; +			/* Only update if we actually balanced. */ +			if
>> (continue_balancing) +				sd->last_balance = jiffies; interval =
>> get_sd_balance_interval(sd, idle != CPU_IDLE); } if
>> (need_serialize)
> 
> Did you actually see any difference with this patch?
> 
> The reason I'm asking is that the sched_domains are per cpu, so
> the above assignment is only visible to that particular cpu, not
> other cpus.

It was past 2AM, it may have been a placebo effect :)

Back to the drawing board, to figure out why the load balancing code
is not working quite as expected...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTzodfAAoJEM553pKExN6DR3oH+wVSYjVu6eV1tzaDLw2xSvSl
rO8hC9GtIf3LX8NVp/UTVkQXt7wWDLcpV4f+AO9+ikB9Dk5YD9wfTF6vhZVrP8GV
Zjpd3HvO/H3RYomyDXLbocjZ97JsXBF7kxRWmYw0kixUIzhdt/sZKGc46aQXPnGy
BfcGcYYbBKeFr9rrYTTvHwN5XVB1ZMZBEWiH/6baXGgZ5V/rTdcZDw0VGXailpbn
eM5j33B9gCE6bYxD1uCrfZXdaO4BORCkiqfncpSVqLnl9k7B9HbY44bcbqht/qHy
B/F/7+imlvAfhwfQAhj8EYomaAT2GI8m6Ab7frxagJURJ1McU3r+2dgkkhsSqP8=
=QnLG
-----END PGP SIGNATURE-----
