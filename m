Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaA3PZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:25:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52953 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaA3PZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:25:34 -0500
Date: Thu, 30 Jan 2014 16:25:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 6/6] cpu/idle.c: move to sched/idle.c
Message-ID: <20140130152500.GB5002@laptop.programming.kicks-ass.net>
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org>
 <1391017513-12995-7-git-send-email-nicolas.pitre@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391017513-12995-7-git-send-email-nicolas.pitre@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 12:45:13PM -0500, Nicolas Pitre wrote:
> Integration of cpuidle with the scheduler requires that the idle loop be
> closely integrated with the scheduler proper. Moving cpu/idle.c into the
> sched directory will allow for a smoother integration, and eliminate a
> subdirectory which contained only one source file.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> ---
>  kernel/Makefile              | 1 -
>  kernel/cpu/Makefile          | 1 -
>  kernel/sched/Makefile        | 2 +-
>  kernel/{cpu => sched}/idle.c | 0
>  4 files changed, 1 insertion(+), 3 deletions(-)
>  delete mode 100644 kernel/cpu/Makefile
>  rename kernel/{cpu => sched}/idle.c (100%)

> --- a/kernel/sched/Makefile
> +++ b/kernel/sched/Makefile
> @@ -11,7 +11,7 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
>  CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
>  endif
>  
> -obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
> +obj-y += core.o proc.o clock.o cputime.o idle_task.o idle.o fair.o rt.o stop_task.o
>  obj-y += wait.o completion.o
>  obj-$(CONFIG_SMP) += cpupri.o
>  obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
> diff --git a/kernel/cpu/idle.c b/kernel/sched/idle.c
> similarity index 100%
> rename from kernel/cpu/idle.c
> rename to kernel/sched/idle.c

This is not a valid patch for PATCH(1). Please try again.
