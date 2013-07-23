Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3GWMeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:34:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117Ab3GWMeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:34:02 -0400
Date: Tue, 23 Jul 2013 08:33:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: Re: [PATCH 8/8] watchdog: Remove hack to make full dynticks working
Message-ID: <20130723123331.GE126784@redhat.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-9-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374539466-4799-9-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 02:31:06AM +0200, Frederic Weisbecker wrote:
> A perf event can be used without forcing the tick to
> stay alive if it doesn't use a frequency but a sample
> period and if it doesn't throttle (raise storm of events).
> 
> Since the lockup detector neither use a perf event frequency
> nor should ever throttle due to its high period, it can now
> run concurrently with the full dynticks feature.

Thanks.  Dumb question, I keep wondering if the lockup detector would be
better or worse off if it used the perf event frequency as opposed to
using a sample period?  The idea is it could follow the varying cpu
frequencies better (and probably simplify some of the code too).

Acked-by: Don Zickus <dzickus@redhat.com>


> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Anish Singh <anish198519851985@gmail.com>
> ---
>  kernel/watchdog.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 1241d8c..51c4f34 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -553,14 +553,6 @@ void __init lockup_detector_init(void)
>  {
>  	set_sample_period();
>  
> -#ifdef CONFIG_NO_HZ_FULL
> -	if (watchdog_user_enabled) {
> -		watchdog_user_enabled = 0;
> -		pr_warning("Disabled lockup detectors by default for full dynticks\n");
> -		pr_warning("You can reactivate it with 'sysctl -w kernel.watchdog=1'\n");
> -	}
> -#endif
> -
>  	if (watchdog_user_enabled)
>  		watchdog_enable_all_cpus();
>  }
> -- 
> 1.7.5.4
> 
