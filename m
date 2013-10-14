Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3JNNdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:33:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56711 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3JNNc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:32:59 -0400
Date: Mon, 14 Oct 2013 15:32:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: mingo@kernel.org, pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/7] Power-aware scheduling v2
Message-ID: <20131014133234.GM3081@twins.programming.kicks-ass.net>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 06:19:10PM +0100, Morten Rasmussen wrote:
> Hi,
> 
> I have revised the previous power scheduler proposal[1] trying to address as
> many of the comments as possible. The overall idea was discussed at LPC[2,3].
> The revised design has removed the power scheduler and replaced it with a high
> level power driver interface. An interface that allows the scheduler to query
> the power driver for information and provide hints to guide power management
> decisions in the power driver.
> 
> The power driver is going to be a unified platform power driver that can
> replace cpufreq and cpuidle drivers. Generic power policies will be optional
> helper functions called from the power driver. Platforms may choose to
> implement their own policies as part of their power driver.
> 
> This RFC series prototypes a part of the power driver interface (cpu capacity
> hints) and shows how they can be used from the scheduler. More extensive use of
> the power driver hints and queries is left for later. The focus for now is the
> power driver interface. The patch series includes a power driver/cpufreq
> governor that can use existing cpufreq drivers as backend. It has been tested
> (not thoroughly) on ARM TC2. The cpufreq governor power driver implementation
> is rather horrible, but it illustrates how the power driver interface can be
> used. Native power drivers is on the todo list.
> 
> The power driver interface is still missing quite a few calls to handle: Idle,
> adding extra information to the sched_domain hierarchy to guide scheduling
> decisions (packing), and possibly scaling of tracked load to compensate for
> frequency changes and asymmetric systems (big.LITTLE).
> 
> This set is based on 3.11. I have done ARM TC2 testing based on linux-linaro
> 2013.08[4] to get cpufreq support for TC2.

What I'm missing is a general overview of why what and how.

In particular; how does this proposal lead to power savings. Is there a
mathematical model that supports this framework? Something where if you
give it a task set with global utilisation < 1 (ie. there's idle time),
it results in less power used.

Also, how does this proposal deal with cpufreq's fundamental broken
approach to SMP? Afaict nothing considers the effect of one cpu upon
another -- something which isn't true at all.

In fact, I don't see anything except a random bunch of hooks without an
over-all picture of how to get less power used.
