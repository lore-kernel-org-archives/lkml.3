Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaLEHe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:34:26 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52457 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaLEHeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:34:24 -0500
Date: Thu, 4 Dec 2014 23:34:25 -0800
From: Olof Johansson <olof@lixom.net>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>, robh+dt@kernel.org
Subject: Re: [PATCH v4] clocksource: arch_timer: Allow the device tree to
 specify uninitialized timer registers
Message-ID: <20141205073425.GF29274@quad.lixom.net>
References: <1412753627-28287-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412753627-28287-1-git-send-email-sonnyrao@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 12:33:47AM -0700, Sonny Rao wrote:
> From: Doug Anderson <dianders@chromium.org>
> 
> Some 32-bit (ARMv7) systems are architected like this:
> 
> * The firmware doesn't know and doesn't care about hypervisor mode and
>   we don't want to add the complexity of hypervisor there.
> 
> * The firmware isn't involved in SMP bringup or resume.
> 
> * The ARCH timer come up with an uninitialized offset (CNTVOFF)
>   between the virtual and physical counters.  Each core gets a
>   different random offset.
> 
> * The device boots in "Secure SVC" mode.
> 
> * Nothing has touched the reset value of CNTHCTL.PL1PCEN or
>   CNTHCTL.PL1PCTEN (both default to 1 at reset)
> 
> On systems like the above, it doesn't make sense to use the virtual
> counter.  There's nobody managing the offset and each time a core goes
> down and comes back up it will get reinitialized to some other random
> value.
> 
> This adds an optional property which can inform the kernel of this
> situation, and firmware is free to remove the property if it is going
> to initialize the CNTVOFF registers when each CPU comes out of reset.
> 
> Currently, the best course of action in this case is to use the
> physical timer, which is why it is important that CNTHCTL hasn't been
> changed from its reset value and it's a reasonable assumption given
> that the firmware has never entered HYP mode.
> 
> Note that it's been said that on ARMv8 systems the firmware and
> kernel really can't be architected as described above.  That means
> using the physical timer like this really only makes sense for ARMv7
> systems.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> ---
> Changes in v2:
> - Add "#ifdef CONFIG_ARM" as per Will Deacon
> 
> Changes in v3:
> - change property name to arm,cntvoff-not-fw-configured and specify
>   that the value of CNTHCTL.PL1PC(T)EN must still be the reset value
>   of 1 as per Mark Rutland
> 
> Changes in v4:
> - change property name to arm,cpu-registers-not-fw-configured and
>   specify that all cpu registers must have architected reset values
>   per Mark Rutland
> - change from "#ifdef CONFIG_ARM" to "if (IS_ENABLED(CONFIG_ARM))" per
>   Arnd Bergmann


Applied to next/drivers (and next/dt for rk3288 dependency). Thanks, all!


-Olof
