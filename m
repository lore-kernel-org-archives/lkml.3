Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaENR5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:57:35 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:52382 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaENR5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:57:34 -0400
X-CheckPoint: {5373AD5F-2000D-2100090A-1FFFF}
Message-ID: <5373AE8C.40705@tilera.com>
Date: Wed, 14 May 2014 13:57:32 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Lu <zlu@tilera.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 03/32] genirq: Provide generic hwirq allocation facility
References: <20140507153622.703412101@linutronix.de> <20140507154334.208629358@linutronix.de> <536A998A.4000307@tilera.com> <alpine.DEB.2.02.1405072259230.6261@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405072259230.6261@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2014 7:15 PM, Thomas Gleixner wrote:
> On Wed, 7 May 2014, Chris Metcalf wrote:
>> We have an internal change that we haven't upstreamed yet that makes
>> irqs actually (cpu,ipi) pairs, so that more irqs can be allocated.
>> As a result we allocate some irqs as bound to a specific IPI on a single
>> cpu, and some irqs get bound to a particular IPI registered on every cpu.
>>
>> I'll have to set aside a bit of time to look more closely at how your
>> change interacts with the work we've done internally.  I've appended the
>> per-cpu IRQ change from our internal tree here (and cc'ed the author).
>> The API change is in the <asm/irq.h> diff at the very start.
> Sure it'll break it. [...]

I think the right thing for now is to take my Acked-by for the tile changes
(given a couple of minor nits replied to in separate emails).

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

When we have the chance to set aside some time for more upstreaming of some
of the work we've done it does seem like it makes sense to tackle doing some
kind of matrix mapping in a more generic way.

You're probably right that a cpumask approach would have made more sense
than a cpu integer in the tile API, so we'd certainly go with that in any
fgeneric matrix mapping code.

I do have one question about the irq_alloc_hwirqs() API, which is the use of
zero as an error indicator.  Given that zero can plausibly be an IRQ number,
it seems cleaner to specify this as returning a negative errno failure instead.
Doing so would also align with __irq_alloc_descs().  So, what was your thinking
around using zero?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

