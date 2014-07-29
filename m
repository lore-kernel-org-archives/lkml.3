Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaG2O2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:28:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13938 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751143AbaG2O2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:28:35 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Barry Song <baohua@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Alexander Shiyan <shc_work@mail.ru>,
        Larry Bassel <larry.bassel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 00/15] arm/arm64: fix use of irq_find_mapping outside of legal RCU context
In-Reply-To: <53C04B3E.20908@codeaurora.org> (Christopher Covington's message
	of "Fri, 11 Jul 2014 21:38:22 +0100")
Organization: ARM Ltd
References: <1404825038-547-1-git-send-email-marc.zyngier@arm.com>
	<53C04B3E.20908@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Tue, 29 Jul 2014 15:28:25 +0100
Message-ID: <87mwbskzna.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11 2014 at  9:38:22 pm BST, Christopher Covington <cov@codeaurora.org> wrote:
> Hi Mark,
>
> On 07/08/2014 09:10 AM, Marc Zyngier wrote:
>> A number of irqchip drivers are directly calling irq_find_mapping,
>> which may use a rcu_read_lock call when walking the radix tree.
>
> If this happens to be easy for you to determine: do direct callers of
> irq_find_host such as irq_create_of_mapping have a similar problem with
> irq_domain_mutex?

Definitely not from this problem. irq_find_host doesn't use RCU at all,
so it shouldn't be an issue.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
