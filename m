Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaIRHsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:48:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:32908 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983AbaIRHsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:48:50 -0400
Date: Thu, 18 Sep 2014 08:48:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linaro-kernel@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        patches@linaro.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.17-rc4 v7 4/6] irqchip: gic: Add support for IPI FIQ
Message-ID: <20140918074839.GZ12361@n2100.arm.linux.org.uk>
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org> <1410970218-28847-5-git-send-email-daniel.thompson@linaro.org> <20140917185138.GX12361@n2100.arm.linux.org.uk> <5419EB27.2040405@linaro.org> <20140917210712.GY12361@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917210712.GY12361@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:07:13PM +0100, Russell King - ARM Linux wrote:
> On Wed, Sep 17, 2014 at 01:12:23PM -0700, Daniel Thompson wrote:
> > I may have missed something but this sounds like the expected behaviour
> > to me.
> > 
> > Without AckCtl set (GIC_CPU_CTRL bit 2) then it is not possible to
> > acknowledge group 1 interrupts from secure mode. Thus in the
> > circumstances described above I would expect the system to wedge in the
> > interrupt handler because IRQ is raised but the software is not able to
> > acknowledge it.
> 
> Setting AckCtl (0x07) results in no change in behaviour - still crashes
> when it tries to calibrate the timer.
> 
> > I think there may also problems with leaving CBPR unset. Leaving CBPR
> > unset certainly causes a change of behaviour compared to an all group0
> > setup.
> 
> Also tried setting that (0x17), but still the same.

Another data point: SDP4430 boots fine with 0x17.

The Versatile Express has GIC ID/TYPER register values of:

GICC IDR: 0x3901043b GICD TYPER: 0x0000fc62

The SDP4430 has:

GICC IDR: 0x3901043b GICD TYPER: 0x0000fc24

so they should in theory be identical GICs, and should behave identically,
but they don't.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
