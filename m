Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaFYFJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:09:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbaFYFJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:09:44 -0400
Message-ID: <53AA5977.7030704@redhat.com>
Date: Wed, 25 Jun 2014 01:09:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, peterz@infradead.com,
        mgorman@suse.de, mingo@kernel.org
Subject: Re: [PATCH 9/7] sched,numa: remove task_h_load from task_numa_compare
References: <1403538095-31256-1-git-send-email-riel@redhat.com> <20140624151454.2a05082e@annuminas.surriel.com> <20140625050735.GB28774@twins.programming.kicks-ass.net>
In-Reply-To: <20140625050735.GB28774@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/25/2014 01:07 AM, Peter Zijlstra wrote:
> On Tue, Jun 24, 2014 at 03:14:54PM -0400, Rik van Riel wrote:
>> The function effective_load already makes the calculations that 
>> task_h_load makes. Making them twice can throw off the
>> calculations, and is generally a bad idea.
>> 
>> Signed-off-by: Rik van Riel <riel@redhat.com> --- 
>> kernel/sched/fair.c | 4 ++-- 1 file changed, 2 insertions(+), 2
>> deletions(-)
>> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c index
>> 1aaa3b4..318a275 100644 --- a/kernel/sched/fair.c +++
>> b/kernel/sched/fair.c @@ -1227,7 +1227,7 @@ static void
>> task_numa_compare(struct task_numa_env *env, dst_load =
>> env->dst_stats.load;
>> 
>> /* Calculate the effect of moving env->p from src to dst. */ -
>> load = task_h_load(env->p); +	load = env->p->se.load.weight; tg =
>> task_group(env->p); src_load += effective_load(tg, env->src_cpu,
>> -load, -load); dst_load += effective_load(tg, env->dst_cpu, load,
>> load); @@ -1251,7 +1251,7 @@ static void task_numa_compare(struct
>> task_numa_env *env,
>> 
>> if (cur) { /* Cur moves in the opposite direction. */ -		load =
>> task_h_load(cur); +		load = cur->se.load.weight; tg =
>> task_group(cur); src_load += effective_load(tg, env->src_cpu,
>> load, load); dst_load += effective_load(tg, env->dst_cpu, -load,
>> -load);
> 
> Shall I merge this into patch 3?

Please do, I guess that's where it belongs.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTqll3AAoJEM553pKExN6D9EcIAJA28G/oKfeDBPlt7p29vgGa
xHBVRH9a9qGTyhyqxqXzlSvqBvoaEXED6mZq0nHqvDUgC5HyQ6LD4bWCfgFj1xKH
oFTB4R5r9ef13lzPb4RlYJUvLO6MfDNyzs/Ekb+qO3+LmkSrim00nkZyKrAYeIOf
JnsAcrlavR5hnlEM6oBNPfhpqOhj8JI0v8MKm4IPm20ib4bEeYn0zwLwG06keo24
fa4mCr1Kd17wyPg8zx7nJ2UN5ZwVs0+SQ3JXWrFGhNawFFneBYi1n9UPwD+wPWuF
5rupd35m64XmAdBXbs3vR03HehX2tQ6k710WRdcg021IMFQIFa5+9ZbG5xGZFT0=
=NRBb
-----END PGP SIGNATURE-----
