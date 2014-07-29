Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaG2MR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:17:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:36153 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaG2MR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:17:56 -0400
Date: Tue, 29 Jul 2014 14:17:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 09/10] nohz: Switch nohz full timekeeper to dynticks idle
 on top of sysidle detection
Message-ID: <20140729121753.GZ3935@laptop>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
 <1406569056-30217-10-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406569056-30217-10-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 07:37:35PM +0200, Frederic Weisbecker wrote:

> @@ -745,7 +747,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  		 * if there are full dynticks CPUs around
>  		 */
>  		if (tick_do_timer_cpu == cpu)
> -			return false;
> +			return rcu_sys_is_idle();
>  	}

I still feel its entirely upside down to rely on RCU for this...
