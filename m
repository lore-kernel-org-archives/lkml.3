Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab3GVRJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:09:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54952 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501Ab3GVRJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:09:10 -0400
Date: Mon, 22 Jul 2013 18:08:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v4 0/5] Memory mapped architected timers
Message-ID: <20130722170817.GB4833@e106331-lin.cambridge.arm.com>
References: <1374191972-18015-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374191972-18015-1-git-send-email-sboyd@codeaurora.org>
Thread-Topic: [PATCH v4 0/5] Memory mapped architected timers
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Jul 19, 2013 at 12:59:27AM +0100, Stephen Boyd wrote:
> This patchset adds support for memory mapped architected timers. We
> don't have any other global broadcast timer in our system, so we use the
> mmio timer during low power modes. The first patch changes the register
> accessor to an enum per Thomas' request. The second patch is the binding.
> The next two patches lay some groundwork so that the last patch is simpler.
> The final patch adds support for mmio timers.
> 
> Patches are based on v3.11-rc1.

Be aware that as of v3.11-rc2 this doesn't cleanly apply, as the
__cpuinit removal broke the final patch's context in a couple of places.
It would be nice to get rid of the new cpuinit additions too...

With that cleaned up locally, I've gave this a spin on tc2 and a
Foundation model to test the cp15/system timers, hotplugging CPUs and
running a basic test (`time sleep 5`). That all seems to work.

Unfortunately I have no way of testing the memory-mapped timer support,
but I trust you've tested that locally.

For the series:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> 
> Updates since v3:
>  * Rebased onto v3.11-rc1
>  * New patch to use compiler warnings instead of BUILD_BUG_ON()
> 
> Updates since v2:
>  * Rebased onto v3.10-rc1
> 
> Updates since v1:
>  * Assigned counter reading function and commented why for arm64
>  * Updated DT binding to replace frame-id with frame-number and use status
>    property
> 
> 
> Stephen Boyd (5):
>   clocksource: arch_timer: Make register accessors less error-prone
>   Documentation: Add memory mapped ARM architected timer binding
>   clocksource: arch_timer: Pass clock event to set_mode callback
>   clocksource: arch_timer: Push the read/write wrappers deeper
>   clocksource: arch_timer: Add support for memory mapped timers
> 
>  .../devicetree/bindings/arm/arch_timer.txt         |  59 ++-
>  arch/arm/include/asm/arch_timer.h                  |  14 +-
>  arch/arm64/include/asm/arch_timer.h                |  23 +-
>  drivers/clocksource/arm_arch_timer.c               | 446 +++++++++++++++++----
>  include/clocksource/arm_arch_timer.h               |  10 +-
>  5 files changed, 455 insertions(+), 97 deletions(-)
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
