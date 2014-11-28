Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaK1ORJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:17:09 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41363 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaK1ORG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:17:06 -0500
Date: Fri, 28 Nov 2014 14:16:48 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v4] clocksource: arch_timer: Allow the device tree to
 specify uninitialized timer registers
Message-ID: <20141128141648.GB4249@localhost>
References: <1412753627-28287-1-git-send-email-sonnyrao@chromium.org>
 <5475CC66.6080600@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5475CC66.6080600@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 12:49:42PM +0000, Daniel Lezcano wrote:
> On 10/08/2014 09:33 AM, Sonny Rao wrote:
> > From: Doug Anderson <dianders@chromium.org>
> >
> > Some 32-bit (ARMv7) systems are architected like this:
> >
> > * The firmware doesn't know and doesn't care about hypervisor mode and
> >    we don't want to add the complexity of hypervisor there.
> >
> > * The firmware isn't involved in SMP bringup or resume.
> >
> > * The ARCH timer come up with an uninitialized offset (CNTVOFF)
> >    between the virtual and physical counters.  Each core gets a
> >    different random offset.
> >
> > * The device boots in "Secure SVC" mode.
> >
> > * Nothing has touched the reset value of CNTHCTL.PL1PCEN or
> >    CNTHCTL.PL1PCTEN (both default to 1 at reset)
> >
> > On systems like the above, it doesn't make sense to use the virtual
> > counter.  There's nobody managing the offset and each time a core goes
> > down and comes back up it will get reinitialized to some other random
> > value.
> >
> > This adds an optional property which can inform the kernel of this
> > situation, and firmware is free to remove the property if it is going
> > to initialize the CNTVOFF registers when each CPU comes out of reset.
> >
> > Currently, the best course of action in this case is to use the
> > physical timer, which is why it is important that CNTHCTL hasn't been
> > changed from its reset value and it's a reasonable assumption given
> > that the firmware has never entered HYP mode.
> >
> > Note that it's been said that on ARMv8 systems the firmware and
> > kernel really can't be architected as described above.  That means
> > using the physical timer like this really only makes sense for ARMv7
> > systems.
> >
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> > Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> 
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> I would be nice to have Catalin's ack.

FWIW:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
