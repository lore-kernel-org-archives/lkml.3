Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbaGET0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:26:43 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55486 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756136AbaGET0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:26:42 -0400
Date: Sat, 5 Jul 2014 20:26:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: pawandeep oza <oza.contri.linux.kernel@gmail.com>
Cc: akpm@linux-foundation.org, holt@sgi.com, mingo@kernel.org,
        sboyd@codeaurora.org, k.khlebnikov@samsung.com,
        u.kleine-koenig@pengutronix.de,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.or, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] machine_power_off: not only local_irq_disable but also
	do disable preemption
Message-ID: <20140705192634.GT21766@n2100.arm.linux.org.uk>
References: <CAA-nRyoO_NmrD8aRa3OyVXz4b133Fxi0=biGXTzSPDuSuNJJxQ@mail.gmail.com> <20140705181015.GQ21766@n2100.arm.linux.org.uk> <CAA-nRyp5pPC2qZs7RhAXJdXaK_k4fKNZuq=yRTSTPLQsgPxqxQ@mail.gmail.com> <20140705190105.GR21766@n2100.arm.linux.org.uk> <CAA-nRyo2Ts3o_B1jMS8vvLJanf13u=u2WyoqnL8bCF5svOOCew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA-nRyo2Ts3o_B1jMS8vvLJanf13u=u2WyoqnL8bCF5svOOCew@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 12:34:14AM +0530, pawandeep oza wrote:
> no this is not a generic code bug, because only in this scenerio, problem
> might happen.
> because other core is plugged out and now there is no chance that it can
> release the spin_lock it would have held previously.
> 
> so this core must run with preemption and interrupt disabled.
> 
> this is only applicable  for shutdown, not for any other scenerio.

No.  See my reply I just sent.  Preempting when local interrupts
disabled is a bug.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
