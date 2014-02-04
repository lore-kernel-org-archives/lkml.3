Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbaBDQzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:55:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41573 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbaBDQzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:55:45 -0500
Message-ID: <52F11B5C.40407@ti.com>
Date: Tue, 4 Feb 2014 18:54:52 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <santosh.shilimkar@ti.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <daniel.lezcano@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>
Subject: Re: [PATCH v4 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
References: <1391513453-21140-1-git-send-email-ivan.khoronzhuk@ti.com> <1391513453-21140-2-git-send-email-ivan.khoronzhuk@ti.com> <alpine.DEB.2.02.1402041715220.24986@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402041715220.24986@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was so in v1. But it was decided to use explicit memory barriers,
because we're always sure the memory barriers are there and that
they're properly documented. Also in this case I don't need to add
keystone readl/writel relaxed function variants and to use mixed calls of
writel/writel_relaxed functions.

See:
http://www.spinics.net/lists/arm-kernel/msg294941.html

On 02/04/2014 06:24 PM, Thomas Gleixner wrote:
> On Tue, 4 Feb 2014, Ivan Khoronzhuk wrote:
>> +	keystone_timer_writel(off, TCR);
>> +	/* here we have to be sure the timer has been disabled */
>> +	wmb();
> We have explicit writew_relaxed and writew. Why open coding the
> barriers?
>
> Thanks,
>
> 	tglx

-- 
Regards,
Ivan Khoronzhuk

