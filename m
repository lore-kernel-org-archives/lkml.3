Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab3B0PKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:10:45 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:42216 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760111Ab3B0PKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:10:43 -0500
Date: Wed, 27 Feb 2013 07:10:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rickard.andersson@stericsson.com,
        fabio.baltieri@linaro.org
Subject: Re: [PATCH 1/3] workqueue: define mod_scheduled_delayed_work[_on]()
 helpers
Message-ID: <20130227151036.GC22383@htj.dyndns.org>
References: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 04:59:10PM +0530, Viresh Kumar wrote:
>  int execute_in_process_context(work_func_t fn, struct execute_work *);
> @@ -465,6 +466,11 @@ static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
>  long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
>  #endif /* CONFIG_SMP */
>  
> +#define mod_scheduled_delayed_work_on(cpu, dwork, delay)	\
> +	mod_delayed_work_on(cpu, system_wq, dwork, delay)
> +#define mod_scheduled_delayed_work(dwork, delay)		\
> +	mod_delayed_work(system_wq, dwork, delay)

So, the intention is to just let people use system_wq.  We no longer
have single system-wide workqueue and we don't wanna add different
variants matching each system wq.  schedule_work() and friends were
already there so I'm leaving those alone but I don't really want to
add another set of rather meaningless wrappers.  Please just use
system_wq with mode_delayed_work*().

Thanks.

-- 
tejun
