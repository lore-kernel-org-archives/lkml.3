Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab3CYR1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:27:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44145 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794Ab3CYR07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:26:59 -0400
Date: Mon, 25 Mar 2013 17:26:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
Message-ID: <20130325172633.GP30923@n2100.arm.linux.org.uk>
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com> <20130321110646.GE15279@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321110646.GE15279@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 11:06:47AM +0000, Mark Rutland wrote:
> On TC2 this series leads to using the vexpress 24MHz clock as the sched clock
> in preference to the architected timer:
> 
>   Architected local timer running at 24.00MHz (virt).
>   Switching to timer-based delay loop
>   Registered arch_counter_get_cntvct+0x0/0x14 as sched_clock source
>   sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
>   Registered versatile_read_sched_clock+0x0/0x28 as sched_clock source
> 
> As they both have the same frequency, neither overrides the other, and
> whichever gets registered last is used as the sched_clock. As accesses
> to the architected timer are going to have a much lower overhead, this
> isn't very nice (and it could be better to use it even if it had a lower
> frequency).

I'll remind people that sched_clock() is supposed to be functional at
the point in the boot sequence where the call to sched_init() is called.
That is after setup_arch() and *before* time_init() is called.
