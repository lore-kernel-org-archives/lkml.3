Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3CRRdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:33:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59761 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3CRRdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:33:44 -0400
Date: Mon, 18 Mar 2013 13:33:39 -0400 (EDT)
Message-Id: <20130318.133339.2056938599662437643.davem@davemloft.net>
To: viresh.kumar@linaro.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V3 4/7] PHYLIB: queue work on any cpu
From: David Miller <davem@davemloft.net>
In-Reply-To: <9a366f17b93a5e18777360481c94e6db763b45b7.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<cover.1363617402.git.viresh.kumar@linaro.org>
	<9a366f17b93a5e18777360481c94e6db763b45b7.1363617402.git.viresh.kumar@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Mar 2013 10:33:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 18 Mar 2013 20:53:26 +0530

> Phylib uses workqueues for multiple purposes. There is no real dependency of
> scheduling these on the cpu which scheduled them.
> 
> On a idle system, it is observed that and idle cpu wakes up many times just to
> service this work. It would be better if we can schedule it on a cpu which isn't
> idle to save on power.
> 
> By idle cpu (from scheduler's perspective) we mean:
> - Current task is idle task
> - nr_running == 0
> - wake_list is empty
> 
> This patch replaces the schedule_work() and schedule_delayed_work() routines
> with their queue_[delayed_]work_on_any_cpu() siblings with system_wq as
> parameter.
> 
> These routines would look for the closest (via scheduling domains) non-idle cpu
> (non-idle from schedulers perspective). If the current cpu is not idle or all
> cpus are idle, work will be scheduled on local cpu.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

This will need to be applied to whatever tree adds these new interfaces,
and for that:

Acked-by: David S. Miller <davem@davemloft.net>
