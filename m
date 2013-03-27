Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3C0NPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:15:37 -0400
Received: from 8bytes.org ([85.214.48.195]:47483 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab3C0NPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:15:36 -0400
Date: Wed, 27 Mar 2013 14:15:32 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130327131532.GL30540@8bytes.org>
References: <20130324115556.GA4866@pd.tnic>
 <20130324155924.GB4866@pd.tnic>
 <20130326183452.GC27518@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326183452.GC27518@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar 27 14:15:34 2013
X-DSPAM-Confidence: 0.9984
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5152f0f623671320318495
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 07:34:52PM +0100, Borislav Petkov wrote:
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 7b4a55d41efc..f3bb3384a106 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4455,8 +4455,11 @@ static void perf_event_task_event(struct perf_task_event *task_event)
>  next:
>  		put_cpu_ptr(pmu->pmu_cpu_context);
>  	}
> +
> +	preempt_disable();
>  	if (task_event->task_ctx)
>  		perf_event_task_ctx(task_event->task_ctx, task_event);
> +	preempt_enable();
>  
>  	rcu_read_unlock();
>  }

What makes me wonder here is that the code is preemptible in an
rcu_read_locked section. As far as I know preemption needs to be
disabled while holding the rcu_read_lock().


	Joerg


