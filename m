Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaHZRms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:42:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60511 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaHZRmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:42:46 -0400
Message-ID: <53FCC714.3090206@codeaurora.org>
Date: Tue, 26 Aug 2014 10:42:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@openrisc.net, linux@arm.linux.org.uk,
        shawn.guo@freescale.com, kernel@pengutronix.de, tony@atomide.com,
        catalin.marinas@arm.com, will.deacon@arm.com, jonas@southpole.se,
        tglx@linutronix.de, jason@lakedaemon.net, shc_work@mail.ru,
        baohua@kernel.org, maxime.ripard@free-electrons.com,
        khilman@linaro.org, lorenzo.pieralisi@arm.com, larry.bassel@linaro.org,
        mark.rutland@arm.com, sudeep.holla@arm.com,
        stefan.kristiansson@saunalahti.fi, vkale@apm.com,
        schwidefsky@de.ibm.com, Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 01/26] genirq: add irq_domain-aware core IRQ handler
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com> <1409047421-27649-2-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1409047421-27649-2-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/14 03:03, Marc Zyngier wrote:
> Calling irq_find_mapping from outside a irq_{enter,exit} section is
> unsafe and produces ugly messages if CONFIG_PROVE_RCU is enabled:
> If coming from the idle state, the rcu_read_lock call in irq_find_mapping
> will generate an unpleasant warning:
>
> <quote>
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.16.0-rc1+ #135 Not tainted
> -------------------------------
> include/linux/rcupdate.h:871 rcu_read_lock() used illegally while idle!
>
> other info that might help us debug this:
>
> RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 0
> RCU used illegally from extended quiescent state!
> 1 lock held by swapper/0/0:
>  #0:  (rcu_read_lock){......}, at: [<ffffffc00010206c>]
> irq_find_mapping+0x4c/0x198

Do you have the whole stacktrace? I don't see where this is called
outside of irq_enter() from within the idle loop, but maybe I missed
something.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

