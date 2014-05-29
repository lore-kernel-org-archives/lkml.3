Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbaE2KPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:15:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40669 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982AbaE2KPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:15:06 -0400
Date: Thu, 29 May 2014 11:14:41 +0100
From: Will Deacon <will.deacon@arm.com>
To: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH] arm64: kernel: initialize broadcast hrtimer based clock
 event device
Message-ID: <20140529101441.GM29812@arm.com>
References: <1401355381-11446-1-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401355381-11446-1-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:23:01AM +0100, Lorenzo Pieralisi wrote:
> On platforms implementing CPU power management, the CPUidle subsystem
> can allow CPUs to enter idle states where local timers logic is lost on power
> down. To keep the software timers functional the kernel relies on an
> always-on broadcast timer to be present in the platform to relay the
> interrupt signalling the timer expiries.
> 
> For platforms implementing CPU core gating that do not implement an always-on
> HW timer or implement it in a broken way, this patch adds code to initialize
> the kernel software broadcast hrtimer upon boot. It relies on a dynamically
> chosen CPU to be always powered-up. This CPU then relays the timer interrupt
> to CPUs in deep-idle states through its HW local timer device.
> 
> On systems with power management capabilities but no functional HW broadcast
> tick device, the hrtimer based clock event device allows the kernel to
> enter high-resolution timer mode, which improves system latencies and saves
> dynamic power.
> 
> The side effect of having a CPU always-on has implications on power management
> platform capabilities and makes CPUidle suboptimal, since at least a CPU is
> kept always in a shallow idle state by the kernel to relay timer interrupts,
> but at least leaves the kernel with a functional system with some working power
> management capabilities.
> 
> The hrtimer based clock event device has lowest possible rating so that,
> if a platform contains a functional HW clock event device with broadcast
> capabilities, that device is always chosen as a tick broadcast device instead
> of the software based one, now present by default.
> 
> Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

Thanks Lorenzo,

  Acked-by: Will Deacon <will.deacon@arm.com>

With this patch applied, cyclictest starts reporting sane numbers and I
no longer see latency-related failures in LTP when it does things like
test timeouts and nanosleep()s.

Will
