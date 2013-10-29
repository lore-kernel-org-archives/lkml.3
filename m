Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3J2IZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:25:56 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56160 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3J2IZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:25:50 -0400
Date: Tue, 29 Oct 2013 09:25:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kevin Hilman <khilman@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Support arch_irq_work_raise() via self IPIs
Message-ID: <20131029082546.GA17514@localhost.localdomain>
References: <526DBEAA.4030707@linaro.org>
 <1382984701-2371-1-git-send-email-sboyd@codeaurora.org>
 <878uxcq1m7.fsf@linaro.org>
 <20131029060058.GD21983@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029060058.GD21983@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:00:58PM -0700, Stephen Boyd wrote:
> On 10/28, Kevin Hilman wrote:
> > Stephen Boyd <sboyd@codeaurora.org> writes:
> > 
> > > This will allow the scheduler tick to be restarted if we're in
> > > full NOHZ mode.
> > >
> > > Cc: Kevin Hilman <khilman@linaro.org>
> > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > 
> > Minor nit, but I'd prefer a more verbose changelog (I forget things
> > quickly and like to rely on changelogs for my memory.)  Probably worth
> > adding something like: "By default, irq_work is tied to the tick
> > processing (update_process_times()) but in full NOHZ mode, no tick means
> > no IRQ work.  In order for IRQ work to be done in full NOHZ mode, a
> > self-IPI is used to process IRQ work."
> > 
> > Other than the changelog nit, patch looks good, feel free to add
> > 
> > Reviewed-by: Kevin Hilman <khilman@linaro.org>
> > 
> > If Russell is OK with this, it can go to his patch system.
> > 
> 
> Fair enough. This is what I came up with. I'll send it off to the
> patch tracker in about 12 hours if nobody else has anymore
> comments.
> 
> ----8<-----
> ARM: Support arch_irq_work_raise() via self IPIs                                
> 
> By default, IRQ work is run from the tick interrupt (see
> irq_work_run() in update_process_times()). When we're in full
> NOHZ mode, restarting the tick requires the use of IRQ work and
> if the only place we run IRQ work is in the tick interrupt we
> have an unbreakable cycle. Implement arch_irq_work_raise() via
> self IPIs to break this cycle and get the tick started again.
> Note that we implement this via IPIs which are only available on
> SMP builds. This shouldn't be a problem because full NOHZ is only
> supported on SMP builds anyway.

Nice description!

Thanks!

> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Reviewed-by: Kevin Hilman <khilman@linaro.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
