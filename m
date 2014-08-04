Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaHDKAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:00:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51447 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752123AbaHDKAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:00:52 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Alexander Shiyan <shc_work@mail.ru>, Barry Song <baohua@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Larry Bassel <larry.bassel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH 02/15] ARM: pass IRQ domain to the core IRQ handler
In-Reply-To: <20140802075118.GV30282@n2100.arm.linux.org.uk> (Russell King's
	message of "Sat, 2 Aug 2014 08:51:18 +0100")
Organization: ARM Ltd
References: <1404825038-547-1-git-send-email-marc.zyngier@arm.com>
	<1404825038-547-3-git-send-email-marc.zyngier@arm.com>
	<20140802075118.GV30282@n2100.arm.linux.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 04 Aug 2014 11:00:38 +0100
Message-ID: <87k36oh8vt.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sat, Aug 02 2014 at  8:51:18 am BST, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Tue, Jul 08, 2014 at 02:10:25PM +0100, Marc Zyngier wrote:
>> Calling irq_find_mapping from outside a irq_{enter,exit} section is
>> unsafe and produces ugly messages if CONFIG_PROVE_RCU is enabled:
>> If coming from the idle state, the rcu_read_lock call in irq_find_mapping
>> will generate an an unpleasant warning.
>> 
>> A solution is to add a new handle_domain_irq entry point into
>> the arm code that the interrupt controller code can call.
>> This new function takes an irq_domain, and calls into irq_find_domain
>> inside the irq_{enter,exit} block.
>> 
>> Interrupt controllers can then be updated to use the new mechanism.
>
> I merged this last night, and this says it all...
>
> Subject: rmk build: 244 warnings 49 failures (rmk/v3.16-rc3-70-gc1ed1df)
>
> arch/arm/kernel/irq.c:81:3: error: implicit declaration of function 'irq_find_mapping' [-Werror=implicit-function-declaration]
>
> So I'm dropping it.

Ouch. Sorry about that. Seems like I only tested this with a config that
has CONFIG_IRQ_DOMAIN set. I'll respin in after the merge window.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
