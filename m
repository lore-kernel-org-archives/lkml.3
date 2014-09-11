Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaIKRHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:07:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56073 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbaIKRHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:07:18 -0400
Date: Thu, 11 Sep 2014 18:07:16 +0100
From: Will Deacon <will.deacon@arm.com>
To: Doug Anderson <dianders@chromium.org>
Cc: "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
Message-ID: <20140911170716.GA6158@arm.com>
References: <1410452204-7277-1-git-send-email-dianders@chromium.org>
 <20140911164710.GW6158@arm.com>
 <CAD=FV=WECbZ4L=-C+F9K6kfiPUi7ar3a4a7Upq2TqDYYPGoOrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WECbZ4L=-C+F9K6kfiPUi7ar3a4a7Upq2TqDYYPGoOrA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 05:59:53PM +0100, Doug Anderson wrote:
> On Thu, Sep 11, 2014 at 9:47 AM, Will Deacon <will.deacon@arm.com> wrote:
> > I'd say `Only supported for ARM' to better match what we've done. Probably
> > also worth mentioning that this relies on the hypervisor/firmware having set
> > CNTHCTL.PL1PCEN and CNTHCTL.EL1PCTEN (but assumedly made a mess of CNTVOFF
> > ;) if you want to boot on the non-secure side (e.g. as a guest).
> 
> Note that the reset value of CNTHCTL.PL1PCEN and CNTHCTL.PL1PCTEN are
> both 1 in my version of the ARM ARM.  On the other hand CNTVOFF is
> documented to have an UNKNOWN reset value.  If only ARM had guaranteed
> that CNTVOFF started out as 0 (which seems like it would have been
> sensible) we wouldn't be in this mess.  :-/

I'm afraid we went the opposite way -- in ARMv8 there are a tiny handful
of EL3 registers that are well-defined out of reset, then the rest of the
system is UNKNOWN. The hardware guys prefer that and it can also be useful
for very low-level debugging (system crashes, do a reset, read out the
state).

Will
