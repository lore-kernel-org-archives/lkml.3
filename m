Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3IIN6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:58:11 -0400
Received: from bizpsie4.9services.com ([84.96.93.162]:51146 "EHLO
	bizpsie4.9services.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3IIN6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:58:09 -0400
X-VRSPAM-SCORE: -100.00
Message-ID: <522DD3E8.8070804@efixo.com>
Date: Mon, 09 Sep 2013 15:58:00 +0200
From: Emmanuel Deloget <emmanuel.deloget@efixo.com>
Reply-To: emmanuel.deloget@efixo.com
Organization: Efixo
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "[ML] linux-kernel" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: /proc/$PID/sched does not take PID namespace into account
References: <5225F0A9.5040100@efixo.com> <20130909110141.GM31370@twins.programming.kicks-ass.net>
In-Reply-To: <20130909110141.GM31370@twins.programming.kicks-ass.net>
Content-Type: multipart/mixed;
 boundary="------------040909030004080901050805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040909030004080901050805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

On 09/09/2013 13:01, Peter Zijlstra wrote:
> On Tue, Sep 03, 2013 at 04:22:33PM +0200, Emmanuel Deloget wrote:
>> The issue (if this is really an issue) lies in kernel/sched/debug.c,
>> function proc_sched_show_task(). The code says [1]:
>>
>>     SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid,
>>                         get_nr_threads(p));
>>
>> I see a few options:
>>
>> * either it's a bug and it should be corrected (I'm not sure how to
>>   do it; the printed PID should reflect the current PID namespace
>>   and I don't how how to get this information).
> I suppose something like the below ought to work? -- completely
> untested, please confirm.

Thanks !

I'll test that as soon as possible and I'll report to you.

Best regards,

-- Emmanuel Deloget

>
> ---
> Subject: sched, debug: Use PID namespaces
>
> Emmanuel reported that /proc/sched_debug didn't report the right PIDs
> when using namespaces, cure this.
>
> Reported-by: Emmanuel Deloget <emmanuel.deloget@efixo.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/debug.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index e076bdd..e30bf44 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -124,7 +124,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
>  		SEQ_printf(m, " ");
>  
>  	SEQ_printf(m, "%15s %5d %9Ld.%06ld %9Ld %5d ",
> -		p->comm, p->pid,
> +		p->comm, task_pid(p),,
>  		SPLIT_NS(p->se.vruntime),
>  		(long long)(p->nvcsw + p->nivcsw),
>  		p->prio);
> @@ -289,7 +289,7 @@ do {									\
>  	P(nr_load_updates);
>  	P(nr_uninterruptible);
>  	PN(next_balance);
> -	P(curr->pid);
> +	P(task_pid(curr));
>  	PN(clock);
>  	P(cpu_load[0]);
>  	P(cpu_load[1]);
> @@ -492,7 +492,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
>  {
>  	unsigned long nr_switches;
>  
> -	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid,
> +	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, task_pid(p),
>  						get_nr_threads(p));
>  	SEQ_printf(m,
>  		"---------------------------------------------------------"
> .
>


-- 

--------------040909030004080901050805
Content-Type: text/x-vcard; charset=utf-8;
 name="emmanuel_deloget.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="emmanuel_deloget.vcf"

begin:vcard
fn:Emmanuel Deloget
n:Deloget;Emmanuel
org:efixo / SFR;DATA
adr;quoted-printable:;;67 mont=C3=A9e de St Menet;MARSEILLE;;13011;FRANCE
email;internet:emmanuel.deloget@efixo.com
title:Team Leader
tel;work:04 88 15 50 77
url:www.sfr.fr
version:2.1
end:vcard


--------------040909030004080901050805--
