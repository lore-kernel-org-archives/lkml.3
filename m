Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaA0MsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 07:48:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55186 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaA0MsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 07:48:04 -0500
Date: Mon, 27 Jan 2014 13:47:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/9] setting the table for integration of cpuidle with
 the scheduler
Message-ID: <20140127124731.GA4941@twins.programming.kicks-ass.net>
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 01:08:15AM -0500, Nicolas Pitre wrote:
> As everyone should know by now, we want to integrate the cpuidle
> governor with the scheduler for a more efficient idling of CPUs.
> In order to help the transition, this small patch series moves the
> existing interaction with cpuidle from architecture code to generic
> core code.  No functional change should have occurred yet.
> 
> The ARM, PPC, SH and X86 architectures are concerned.  Small cleanups
> to ARM and ARM64 are also included. I don't know yet the best path for
> those patches to get into mainline, but it is probably best if they
> stay together. So ACKs from architecture maintainers would be greatly
> appreciated.
> 
> 
>  arch/arm/kernel/process.c                       | 21 +++---------
>  arch/arm/kernel/setup.c                         |  7 ++++
>  arch/arm64/kernel/process.c                     |  5 ---
>  arch/arm64/kernel/setup.c                       |  7 ++++
>  arch/powerpc/platforms/pseries/processor_idle.c |  5 +++
>  arch/powerpc/platforms/pseries/setup.c          | 34 ++++++++-----------
>  arch/sh/kernel/idle.c                           |  4 +--
>  arch/x86/kernel/process.c                       |  5 +--
>  include/linux/cpu.h                             |  1 -
>  kernel/Makefile                                 |  1 -
>  kernel/cpu/Makefile                             |  1 -
>  kernel/sched/Makefile                           |  2 +-
>  kernel/{cpu => sched}/idle.c                    |  6 ++--
>  13 files changed, 44 insertions(+), 55 deletions(-)

Thomas, any objections to this? It looks like a sensible thing to do.
