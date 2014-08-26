Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaHZSqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:46:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38446 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaHZSql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:46:41 -0400
Message-ID: <53FCD60E.1030009@codeaurora.org>
Date: Tue, 26 Aug 2014 11:46:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux@openrisc.net" <linux@openrisc.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "tony@atomide.com" <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "jonas@southpole.se" <jonas@southpole.se>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "baohua@kernel.org" <baohua@kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "khilman@linaro.org" <khilman@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "larry.bassel@linaro.org" <larry.bassel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "stefan.kristiansson@saunalahti.fi" 
	<stefan.kristiansson@saunalahti.fi>,
        "vkale@apm.com" <vkale@apm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        Vladimir Murzin <Vladimir.Murzin@arm.com>
Subject: Re: [PATCH v2 01/26] genirq: add irq_domain-aware core IRQ handler
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com> <1409047421-27649-2-git-send-email-marc.zyngier@arm.com> <53FCC714.3090206@codeaurora.org> <53FCCCC7.9070801@arm.com>
In-Reply-To: <53FCCCC7.9070801@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/14 11:07, Marc Zyngier wrote:
> Digging into my email, one of the traces looked like this:
>
> stack backtrace:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1+ #135
> Call trace:
> [<ffffffc0000882cc>] dump_backtrace+0x0/0x12c
> [<ffffffc000088408>] show_stack+0x10/0x1c
> [<ffffffc0004ee5f0>] dump_stack+0x74/0xc4
> [<ffffffc0000edfbc>] lockdep_rcu_suspicious+0xe8/0x124
> [<ffffffc00010218c>] irq_find_mapping+0x16c/0x198
> [<ffffffc00008130c>] gic_handle_irq+0x38/0xcc
>
> Most drivers call irq_find_mapping outside of irq_enter()/irq_exit(), as
> this is in handle_IRQ().
>

Ah ok. This is the multi-irq handler case? Has this been broken since
v3.2 at least for the gic users? Now that we call irq_enter()/irq_exit()
a lot more code runs, including things like updating jiffies when
interrupts arrive and invoking softirq? Do we only call irq_exit() on
the IPI path otherwise?

Are there any plans to send this back to stable trees? Not calling
irq_enter()/irq_exit() when we get an interrupt seems like a big problem.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

