Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab3DRJkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:40:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:43272 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3DRJkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:40:35 -0400
Date: Thu, 18 Apr 2013 11:40:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Bohan <mbohan@codeaurora.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] hrtimer: Consider preemption when migrating hrtimer
 cpu_bases
In-Reply-To: <1365628068-32738-2-git-send-email-mbohan@codeaurora.org>
Message-ID: <alpine.LFD.2.02.1304181138290.21884@ionos>
References: <1365628068-32738-1-git-send-email-mbohan@codeaurora.org> <1365628068-32738-2-git-send-email-mbohan@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Michael Bohan wrote:

> When switching to a new cpu_base in switch_hrtimer_base(), we
> briefly enable preemption by unlocking the cpu_base lock in two
> places. During this interval it's possible for the running thread
> to be swapped to a different CPU.
> 
> Consider the following example:
> 
> CPU #0                                 CPU #1
> ----                                   ----
> hrtimer_start()                        ...
>  lock_hrtimer_base()
>  switch_hrtimer_base()
>   this_cpu = 0;
>   target_cpu_base = 0;
>   raw_spin_unlock(&cpu_base->lock)
> <migrate to CPU 1>

Errm. switch_hrtimer_base() is called with interrupts disabled and
they stay disabled, so how exactly is the task going to be migrated?

Thanks,

	tglx
