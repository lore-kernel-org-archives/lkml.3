Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbaDXQE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:04:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41001 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758167AbaDXQEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:04:51 -0400
Message-ID: <53593619.2000107@free-electrons.com>
Date: Thu, 24 Apr 2014 18:04:41 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 5/5] irqchip: armanda: Sanitize set_irq_affinity()
References: <20140304202425.102779779@linutronix.de> <20140304203101.088889302@linutronix.de> <20140306190531.GF1872@titan.lakedaemon.net> <5319ED86.2050707@free-electrons.com> <alpine.DEB.2.02.1403071816340.18573@ionos.tec.linutronix.de> <53285303.8000305@free-electrons.com> <alpine.DEB.2.02.1403182153330.18573@ionos.tec.linutronix.de> <5328B4C9.6020906@free-electrons.com>
In-Reply-To: <5328B4C9.6020906@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 18/03/2014 22:04, Gregory CLEMENT wrote:
> On 18/03/2014 21:55, Thomas Gleixner wrote:
>> On Tue, 18 Mar 2014, Gregory CLEMENT wrote:
>>> On 07/03/2014 18:17, Thomas Gleixner wrote:
>>>> It might be the readback of the routing register. I don't have the
>>>> datasheet of this.
>>>
>>> Sorry for the delay, I was on vacation without the hardware to test it.
>>>
>>> Indeed it was the readback of the routing register. (Unfortunately the
>>> datasheet was not yet publicly available :(  ). In your patch by replacing
>>> the line:
>>>
>>> writel(mask, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
>>>
>>> by the following ones:
>>>
>>> reg = readl(main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
>>> reg = (reg & (~ARMADA_370_XP_INT_SOURCE_CPU_MASK)) | mask;
>>> writel(reg, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
>>>
>>> with
>>> #define ARMADA_370_XP_INT_SOURCE_CPU_MASK	0xF
>>>
>>> Then it worked.
>>>
>>> About masking with the online CPU in the original code, the purpose
>>> was to allow sharing the SoC with an other OS by doing AMP. This feature
>>> is part of the Marvell version of the kernel.
>>> The idea was to bring this latter in the vanilla kernel, but I am not sure
>>> that all the part needed for AMP are acceptable for mainline. So I can add
>>> it back later when we will need it.
>>
>> Right.
>>
>> So are you ok with that patch (including your change) ? If you send me
>> tested/acked-by i'll route it for 3.15
> 
> With the change I included you can add my
> 
> Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> 

I have just noticed that this patch was not merged in 3.15.
Actually it is not in the core/irq branch of tip.git with
the other patches of the same series.
Is there any reason for this?

Thanks,

Gregory


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
