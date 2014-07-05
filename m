Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaGESKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 14:10:35 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55420 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755396AbaGESKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 14:10:34 -0400
Date: Sat, 5 Jul 2014 19:10:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: pawandeep oza <oza.contri.linux.kernel@gmail.com>
Cc: akpm@linux-foundation.org, holt@sgi.com, mingo@kernel.org,
        sboyd@codeaurora.org, k.khlebnikov@samsung.com,
        u.kleine-koenig@pengutronix.de, nicolas.pitre@linaro.org,
        linux-arm-kernel@lists.infradead.or, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] machine_power_off: not only local_irq_disable but also
	do disable preemption
Message-ID: <20140705181015.GQ21766@n2100.arm.linux.org.uk>
References: <CAA-nRyoO_NmrD8aRa3OyVXz4b133Fxi0=biGXTzSPDuSuNJJxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA-nRyoO_NmrD8aRa3OyVXz4b133Fxi0=biGXTzSPDuSuNJJxQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 10:44:41PM +0530, pawandeep oza wrote:
>  process calls sys_reboot and that process then stops other CPUs while those
>  CPUs are within a spin_lock() region we can potentially encounter a
> deadlock
>  scenario like below.
> 
>     CPU 0                   CPU 1
>     -----                   -----
>                             spin_lock(my_lock)
>     smp_send_stop()
>      <send IPI>             handle_IPI()
>                              disable_preemption/irqs
>                               while(1);
>      <PREEMPT>
>     spin_lock(my_lock) <--- Waits forever

Please explain how that <PREEMPT> occurs with IRQs already disabled.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
