Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab3LEAwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:52:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43960 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab3LEAwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:52:44 -0500
Date: Thu, 5 Dec 2013 00:52:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Neil Zhang <zhangwm@marvell.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        haojian.zhuang@gmail.com, LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: gic_arch_extn (Was: [PATCH v3] irqchip: mmp: add dt
	support for wakeup)
Message-ID: <20131205005216.GA4360@n2100.arm.linux.org.uk>
References: <1386159214-31483-1-git-send-email-zhangwm@marvell.com> <alpine.DEB.2.02.1312042234190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312042347350.30673@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312042347350.30673@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 01:41:53AM +0100, Thomas Gleixner wrote:
> @all who feel responsible for gic_arch_extn
> 
> On Wed, 4 Dec 2013, Thomas Gleixner wrote:
> > I'm going to reply in a separate mail on this, because you have
> > brought this to my attention, but you are not responsible in the first
> > place for this brainfart.
> 
> Who came up with that gic_arch_extn concept in the first place?

If you'd spend more time reviewing IRQ patches then maybe you'd catch
this at review time.  So please stop your rediculous whinging when
most of the problem is your own lack of time.

If you must know, it was introduced by TI to work around the power
management shortcomings of the architecture mandated GIC.  No it doesn't
get called for IPIs, but it damned well needs to be called for normal
IRQs.

At the point it was created, it wasn't clear whether this also applied
to local IRQs.  Since I *no* *longer* have visibility of what SoC stuff
is doing with it, of course it's not going to get fixed when a common
pattern emerges.

So... congratulations, you've found something which can be improved,
which has come to light as the code has evolved and a better
understanding of what is required has been discovered.
