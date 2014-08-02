Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaHBHvc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 03:51:32 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33328 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750879AbaHBHvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 03:51:31 -0400
Date: Sat, 2 Aug 2014 08:51:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Alexander Shiyan <shc_work@mail.ru>, Barry Song <baohua@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Larry Bassel <larry.bassel@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH 02/15] ARM: pass IRQ domain to the core IRQ handler
Message-ID: <20140802075118.GV30282@n2100.arm.linux.org.uk>
References: <1404825038-547-1-git-send-email-marc.zyngier@arm.com> <1404825038-547-3-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404825038-547-3-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 02:10:25PM +0100, Marc Zyngier wrote:
> Calling irq_find_mapping from outside a irq_{enter,exit} section is
> unsafe and produces ugly messages if CONFIG_PROVE_RCU is enabled:
> If coming from the idle state, the rcu_read_lock call in irq_find_mapping
> will generate an an unpleasant warning.
> 
> A solution is to add a new handle_domain_irq entry point into
> the arm code that the interrupt controller code can call.
> This new function takes an irq_domain, and calls into irq_find_domain
> inside the irq_{enter,exit} block.
> 
> Interrupt controllers can then be updated to use the new mechanism.

I merged this last night, and this says it all...

Subject: rmk build: 244 warnings 49 failures (rmk/v3.16-rc3-70-gc1ed1df)

arch/arm/kernel/irq.c:81:3: error: implicit declaration of function 'irq_find_mapping' [-Werror=implicit-function-declaration]

So I'm dropping it.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
