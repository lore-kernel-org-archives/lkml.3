Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3EUIyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:54:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32874 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab3EUIyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:54:05 -0400
Date: Tue, 21 May 2013 09:53:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: compiling issue, need
 'EXPORT_SYMBOL_GPL(read_current_timer)'
Message-ID: <20130521085325.GB10453@mudshark.cambridge.arm.com>
References: <5199C725.8050102@asianux.com>
 <168084c28e8ba5124c05553e97463172@localhost>
 <20130520095606.GH31359@mudshark.cambridge.arm.com>
 <519AF2DC.2040200@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519AF2DC.2040200@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 05:06:52AM +0100, Chen Gang wrote:
> On 05/20/2013 05:56 PM, Will Deacon wrote:
> > Should be ok once the arch timer driver has moved exclusively to virtual
> > time. I'm also not sure we even need to implement read_current_timer() --
> > it's only used for delay-loop calibration, which we don't need for the
> > arch timer.
> > 
> 
> For whether we need implement read_current_timer():
> 
>   many platforms have implemented it (openrisc, arm, sparc, hexagon, avr32, x86).
>   it is called by init/calibrate.c when 'ARCH_HAS_READ_CURRENT_TIMER' is defined.
>   since arm64 can implement it, better to provide it as an architect features to let outside use.

No, that code is not needed on arm64 because we calibrate the delay loop
statically using a known timer frequency.

> For the implementation of read_current_timer():
> 
>   it has to face various configurations
>     (e.g. CONFIG_ARM_ARCH_TIMER, arch_timer_read_zero, arch_counter_get_cntvct, arch_counter_get_cntpct)
>   so better still use variable instead of.
>     (excuse me, I do not know what is 'CNTVCT_EL0', is it like a constant number ?)

cntvct_el0 is a system register, which provides the virtual counter value.

> For the implementation of get_cycles()
> 
>   if read_current_timer() is provided,
>   better to let get_cycles() to call it, instead of implement once again.

You can implement it as a macro if you like, I'm just suggesting that we
might not need read_current_timer after all.

Will
