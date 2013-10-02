Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3JBRKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:10:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33169 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205Ab3JBRKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:10:03 -0400
Date: Wed, 2 Oct 2013 18:09:17 +0100
From: Will Deacon <will.deacon@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched_clock: fix postinit no sched_clock function check
Message-ID: <20131002170917.GB30298@mudshark.cambridge.arm.com>
References: <1380732928-13897-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380732928-13897-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 05:55:28PM +0100, Santosh Shilimkar wrote:
> The sched_clock code uses 2 levels of function pointers, sched_clock_func()
> and read_sched_clock() but the no sched_clock check in postinit() just
> checks read_sched_clock().
> 
> This leads to kernel falling back to jiffy based sched clock even in
> presence of sched_clock_func() which is not desirable.
> 
> Fix the postinit() check to avoid the issue. Probably the issue is hidden
> so far on most of the arm SOCs because of already existing sched_clock
> registrations apart from arch_timer sched_clock. One can reproduce the
> issue by just have arch_timer as sched_clock

Isn't this just an issue with the arch timer driver not calling
setup_sched_clock? Instead, we munge around with sched_clock_func directly,
which doesn't appear to be the way anybody else deals with this.

I'm not sure of the history though, so perhaps there's a reason for this...

Will
