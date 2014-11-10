Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaKJMaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:30:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:57963 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKJMaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:30:02 -0500
Date: Mon, 10 Nov 2014 13:29:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 1/6] sched: idle: Add a weak arch_cpu_idle_poll
 function
Message-ID: <20141110122954.GM3337@twins.programming.kicks-ass.net>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
 <1415370687-18688-2-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415370687-18688-2-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 03:31:22PM +0100, Daniel Lezcano wrote:
> The poll function is called when a timer expired or if we force to poll when
> the cpu_idle_force_poll option is set.
> 
> The poll function does:
> 
>        local_irq_enable();
>        while (!tif_need_resched())
>                cpu_relax();
> 
> This default poll function suits for the x86 arch because its rep; nop;
> hardware power optimization. But on other archs, this optimization does not
> exists and we are not saving power. The arch specific bits may want to
> optimize this loop by adding their own optimization.

This doesn't make sense to me; should an arch not either implement an
actual idle driver or implement cpu_relax() properly, why allow for a
third weird option?
