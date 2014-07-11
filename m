Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaGKUio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:38:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53618 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaGKUia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:38:30 -0400
Message-ID: <53C04B3E.20908@codeaurora.org>
Date: Fri, 11 Jul 2014 16:38:22 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Barry Song <baohua@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Alexander Shiyan <shc_work@mail.ru>,
        Larry Bassel <larry.bassel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 00/15] arm/arm64: fix use of irq_find_mapping outside
 of legal RCU context
References: <1404825038-547-1-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1404825038-547-1-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 07/08/2014 09:10 AM, Marc Zyngier wrote:
> A number of irqchip drivers are directly calling irq_find_mapping,
> which may use a rcu_read_lock call when walking the radix tree.

If this happens to be easy for you to determine: do direct callers of
irq_find_host such as irq_create_of_mapping have a similar problem with
irq_domain_mutex?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
