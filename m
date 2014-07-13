Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaGMWs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 18:48:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14818 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbaGMWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 18:48:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1880LN3tYDy5crmr4dLVoiXJCCxudiWgTI=
X-DKIM: OpenDKIM Filter v2.0.1 titan F16595AA041
Date: Sun, 13 Jul 2014 18:48:31 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>, Barry Song <baohua@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Larry Bassel <larry.bassel@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v2 02/15] ARM: pass IRQ domain to the core IRQ handler
Message-ID: <20140713224831.GJ13108@titan.lakedaemon.net>
References: <1404827141-30381-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404827141-30381-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc,

On Tue, Jul 08, 2014 at 02:45:40PM +0100, Marc Zyngier wrote:
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
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> Sending the right patch this time, with the missing includes that would
> otherwise break the build...
> 
>  arch/arm/include/asm/irq.h |  2 ++
>  arch/arm/kernel/irq.c      | 25 +++++++++++++++++++++----
>  2 files changed, 23 insertions(+), 4 deletions(-)

Please place in Russell's patch tracker,

Acked-by: Jason Cooper <jason@lakedaemon.net>

Once it lands in a release, we'll apply the rest.  Please send me a
gentle reminder ;-)

thx,

Jason.
