Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab3ASTZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 14:25:37 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:40701 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752178Ab3ASTZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 14:25:36 -0500
Message-ID: <50FAF36A.6000205@xenotime.net>
Date: Sat, 19 Jan 2013 11:26:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix compilation warning
References: <1354727440-20157-1-git-send-email-dinggnu@gmail.com> <CAM3j68rOMRdrovAkWdwfB477W+efMC1uGkbHNjz+kRz4LMaXag@mail.gmail.com>
In-Reply-To: <CAM3j68rOMRdrovAkWdwfB477W+efMC1uGkbHNjz+kRz4LMaXag@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/13 12:47, Cong Ding wrote:
> Is this patch still queued or...?
> 
> - cong

ping.
Can we get this patch or something similar merged, please?


> On Wed, Dec 5, 2012 at 6:10 PM, Cong Ding <dinggnu@gmail.com> wrote:
>> the following compilation warning is caused by Commit-ID:
>> c566e8e9e44b72b53091da20e2dedefc730f2ee2
>>
>> kernel/sched/debug.c: In function ‘print_cfs_rq’:
>> kernel/sched/debug.c:225:2: warning: format ‘%ld’ expects argument of type
>> ‘long int’, but argument 4 has type ‘long long int’ [-Wformat]
>> kernel/sched/debug.c:225:2: warning: format ‘%ld’ expects argument of type
>> ‘long int’, but argument 3 has type ‘long long int’ [-Wformat]
>>
>> where function atomic64_read returns long long int, but %ld was used in the
>> printf
>>
>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>> ---
>>  kernel/sched/debug.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
>> index 2cd3c1b..83ec463 100644
>> --- a/kernel/sched/debug.c
>> +++ b/kernel/sched/debug.c
>> @@ -222,7 +222,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>>                         cfs_rq->runnable_load_avg);
>>         SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
>>                         cfs_rq->blocked_load_avg);
>> -       SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
>> +       SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
>>                         atomic64_read(&cfs_rq->tg->load_avg));
>>         SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
>>                         cfs_rq->tg_load_contrib);
>> --


-- 
~Randy
