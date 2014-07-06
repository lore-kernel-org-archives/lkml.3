Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaGFPgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 11:36:01 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56302 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751280AbaGFPf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 11:35:59 -0400
Date: Sun, 6 Jul 2014 16:35:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: pawandeep oza <oza.contri.linux.kernel@gmail.com>
Cc: akpm@linux-foundation.org, holt@sgi.com, mingo@kernel.org,
        sboyd@codeaurora.org, k.khlebnikov@samsung.com,
        u.kleine-koenig@pengutronix.de,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.or, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] machine_power_off: not only local_irq_disable but also
	do disable preemption
Message-ID: <20140706153542.GU21766@n2100.arm.linux.org.uk>
References: <CAA-nRyoO_NmrD8aRa3OyVXz4b133Fxi0=biGXTzSPDuSuNJJxQ@mail.gmail.com> <20140705181015.GQ21766@n2100.arm.linux.org.uk> <CAA-nRyp5pPC2qZs7RhAXJdXaK_k4fKNZuq=yRTSTPLQsgPxqxQ@mail.gmail.com> <20140705190105.GR21766@n2100.arm.linux.org.uk> <CAA-nRyo2Ts3o_B1jMS8vvLJanf13u=u2WyoqnL8bCF5svOOCew@mail.gmail.com> <20140705192634.GT21766@n2100.arm.linux.org.uk> <CAA-nRyqHXCBCzKcK83UnS64f_wKcWObzui2xamt=ayVDKX9zEA@mail.gmail.com> <CAA-nRyo3T+JLpfE6M260Ws+Ddu4z3TS2fQy5sv_dETMTcYFscQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA-nRyo3T+JLpfE6M260Ws+Ddu4z3TS2fQy5sv_dETMTcYFscQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 08:20:36PM +0530, pawandeep oza wrote:
> just to add to this,
> this scenerio happened on the platform which I am working on,
> where interrupts were being re-enabled in rpm_callback path...because the

Can you explain how you get to the runtime callback paths from the
system reboot/shutdown handlers?

In any case, calling the plain _irq (rather than _irqsave) variants of
spinlocks when IRQs are already disabled is (another) bug.  The plain
_irq variants are not permitted when IRQs have been previously
disabled.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
