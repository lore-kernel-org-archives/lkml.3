Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308Ab3BLO6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:58:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23496 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760611Ab3BLOxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:09 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Hq88nb4cjGAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=7MGjZ8EY_YsA:10 a=oCcaPWc0AAAA:8 a=RCuGY_fSp0TYJ8-1oDwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360680788.21867.9.camel@gandalf.local.home>
Subject: Re: [PATCH v2] sched: fix wrong rq's runnable_avg update with rt
 task
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        efault@gmx.de
Date: Tue, 12 Feb 2013 09:53:08 -0500
In-Reply-To: <1360675434-4259-1-git-send-email-vincent.guittot@linaro.org>
References: <1360675434-4259-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 14:23 +0100, Vincent Guittot wrote:
> 	.set_curr_task          = set_curr_task_idle,
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index fc88644..9707092 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -877,6 +877,7 @@ extern const struct sched_class idle_sched_class;
>  
>  extern void trigger_load_balance(struct rq *rq, int cpu);
>  extern void idle_balance(int this_cpu, struct rq *this_rq);
> +extern void idle_exit(int this_cpu, struct rq *this_rq);
>  
>  #else	/* CONFIG_SMP */
>  
> @@ -884,6 +885,10 @@ static inline void idle_balance(int cpu, struct rq *rq)
>  {
>  }
>  
> +static inline void idle_exit(int this_cpu, struct rq *this_rq)
> +{
> +}
> +

Is this part needed? I don't see it ever called when !CONFIG_SMP.

-- Steve

>  #endif
>  
>  extern void sysrq_sched_debug_show(void);


