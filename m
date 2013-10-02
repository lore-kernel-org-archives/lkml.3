Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3JBRt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:49:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33993 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186Ab3JBRtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:49:25 -0400
Date: Wed, 2 Oct 2013 18:48:41 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] sched_clock: fix postinit no sched_clock function check
Message-ID: <20131002174841.GH30298@mudshark.cambridge.arm.com>
References: <1380732928-13897-1-git-send-email-santosh.shilimkar@ti.com>
 <20131002170917.GB30298@mudshark.cambridge.arm.com>
 <524C5484.5000601@ti.com>
 <524C565C.8010709@codeaurora.org>
 <524C5786.2090008@ti.com>
 <524C5B10.20006@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524C5B10.20006@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 06:42:40PM +0100, Stephen Boyd wrote:
> On 10/02/13 10:27, Santosh Shilimkar wrote:
> > Really... I have not created patch out of fun.
> > Its broken on my keystone machine at least where the sched_clock is
> > falling back on jiffy based sched_clock even in presence of arch_timer
> > sched_clock.
> 
> How is that possible? sched_clock_func is only assigned by
> arch/arm/kernel/arch_timer.c when the architected timer is detected and
> sched_clock() in kernel/time/sched_clock.c calls that function pointer
> unconditionally. The only way I see this happening is if the architected
> timer rate is zero.
  ^^^^^^^^^^^^^^^^^^

*cough* CNTFRQ *cough*

:)

Will
