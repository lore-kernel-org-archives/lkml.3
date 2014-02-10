Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaBJPvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:51:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38481 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaBJPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:51:49 -0500
Message-ID: <52F8F55A.2090903@ti.com>
Date: Mon, 10 Feb 2014 10:50:50 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <daniel.lezcano@linaro.org>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <tglx@linutronix.de>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>, <joshc@codeaurora.org>
Subject: Re: [PATCH v6 0/3] Introduce clocksource driver for Keystone platform
References: <1392027058-11680-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1392027058-11680-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Monday 10 February 2014 05:10 AM, Ivan Khoronzhuk wrote:
> Add a broadcast timer64 based clockevent driver for keystone arch.
> This driver uses timer in 64-bit general purpose mode as clock event
> device.
> 
> Documentation:
>     http://www.ti.com/lit/ug/sprugv5a/sprugv5a.pdf
> 
> Based on
> git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
> keystone/master
> 
> v5..v6:
> 	added function to encapsulate __iowmb().
> 
> v4..v5:
> 	used __iowmb() insted of wmb()
> 
> v3..v4:
> 	rebased on latest of linux-keystone.git keystone/master
> 
> v2..v3:
> - clocksource: timer-keystone: introduce clocksource driver for
> 	changed "u64" type to "unsigned long" for hz_period as more appropriate
> 	hz_period rounded up by DIV_ROUND_UP(rate, HZ)
> 	corrected comments
> 
> v1..v2:
> - clocksource: timer-keystone: introduce clocksource driver for
> 	renamed timer on "timer-keystone"
> 	in keystone_timer_interrupt() evet pointer is passed via "dev_id"
> 	used __relaxed variants of writel/readl and added explicit barriers
> 	added "keystone_timer_disable()" for using in keystone_set_mode()
> 	keystone_timer_config() is not used for disabling the timer any more
> 	in case of an unsupported mode the keystone_timer_config() returns -1.
> 	used request_irq() instead of setup_irq()
> 	assigned irq for event_device in event_dev->irq
> 	calculated timer.hz_period for CLOCK_EVT_MODE_PERIODIC at init
> 	deleted spare call of keystone_timer_config() in keystone_timer_init()
> 
> Ivan Khoronzhuk (3):
>   clocksource: timer-keystone: introduce clocksource driver for Keystone
>   clocksource: keystone: add bindings for keystone timer
>   arm: dts: keystone: add keystone timer entry
> 
Can you queue the first two patches from the series ?
I will queue the dts patch via my tree.

Regards,
Santosh


