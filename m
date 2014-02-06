Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaBFOJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:09:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44435 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaBFOJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:09:27 -0500
Message-ID: <52F3975B.2080806@ti.com>
Date: Thu, 6 Feb 2014 16:08:27 +0200
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
Subject: Re: [PATCH v5 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
References: <1391608060-10760-1-git-send-email-ivan.khoronzhuk@ti.com> <1391608060-10760-2-git-send-email-ivan.khoronzhuk@ti.com> <alpine.DEB.2.02.1402052123560.24986@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402052123560.24986@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/05/2014 10:27 PM, Thomas Gleixner wrote:
> On Wed, 5 Feb 2014, Ivan Khoronzhuk wrote:
>> +	/* here we have to be sure the timer has been disabled */
> Sigh. This is not a proper explanation for a barrier, really. You want
> to explain what it serializes against what. i.e. you want to explain
> why you are using the relaxed functions and avoid a separate non
> relaxed variant in favour of an explicit barrier.
>
>> +	__iowmb();
> The proper thing is to have an inline function key_stone_barrier() and
> a full explanation of the issue in exactly that place instead of
> handwaving comments here and there.
>
> Thanks,
>
> 	tglx

I can add new inline function like:

/**
  * keystone_timer_barrier: write memory barrier
  * use explicit barrier to avoid using readl/writel non relaxed function
  * variants, because in our case relaxed variants hide the true places
  * where barrier is needed.
  */
static inline void keystone_timer_barrier(void)
{
     __iowmb();
}

and use it where it is needed.
Are you OK with it?

And I propose to leave comments under the barriers in order to be
able to understand why they are used.

-- 
Regards,
Ivan Khoronzhuk

