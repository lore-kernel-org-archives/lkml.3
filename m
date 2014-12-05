Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaLEHaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:30:04 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51264 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaLEHaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:30:00 -0500
Date: Thu, 4 Dec 2014 23:30:00 -0800
From: Olof Johansson <olof@lixom.net>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5] clocksource: arch_timer: Fix code to use physical
 timers when requested
Message-ID: <20141205073000.GE29274@quad.lixom.net>
References: <1416812564-26465-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416812564-26465-1-git-send-email-sonnyrao@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 11:02:44PM -0800, Sonny Rao wrote:
> This is a bug fix for using physical arch timers when
> the arch_timer_use_virtual boolean is false.  It restores the
> arch_counter_get_cntpct() function after removal in
> 
> 0d651e4e "clocksource: arch_timer: use virtual counters"
> 
> We need this on certain ARMv7 systems which are architected like this:
> 
> * The firmware doesn't know and doesn't care about hypervisor mode and
>   we don't want to add the complexity of hypervisor there.
> 
> * The firmware isn't involved in SMP bringup or resume.
> 
> * The ARCH timer come up with an uninitialized offset between the
>   virtual and physical counters.  Each core gets a different random
>   offset.
> 
> * The device boots in "Secure SVC" mode.
> 
> * Nothing has touched the reset value of CNTHCTL.PL1PCEN or
>   CNTHCTL.PL1PCTEN (both default to 1 at reset)
> 
> One example of such as system is RK3288 where it is much simpler to
> use the physical counter since there's nobody managing the offset and
> each time a core goes down and comes back up it will get reinitialized
> to some other random value.
> 
> Fixes: 0d651e4e65e9 ("clocksource: arch_timer: use virtual counters")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Acked-by: Olof Johansson <olof@lixom.net>

Applied to a topic branch in arm-soc so we can include it in next/dt and
next/drivers as appropriate for rk3288.


Thanks, all!


-Olof
