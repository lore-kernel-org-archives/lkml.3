Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaLALbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:31:15 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42309 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaLALbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:31:13 -0500
Message-ID: <547C5179.5020505@arm.com>
Date: Mon, 01 Dec 2014 11:31:05 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Liviu Dudau <Liviu.Dudau@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: gic: Allow interrupt level to be set for PPIs.
References: <1417197340-27298-1-git-send-email-Liviu.Dudau@arm.com> <20141201104145.GY3836@n2100.arm.linux.org.uk> <20141201104612.GM828@e106497-lin.cambridge.arm.com> <20141201110358.GA3836@n2100.arm.linux.org.uk> <547C4ECD.20802@arm.com> <20141201112302.GC3836@n2100.arm.linux.org.uk>
In-Reply-To: <20141201112302.GC3836@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/14 11:23, Russell King - ARM Linux wrote:
> On Mon, Dec 01, 2014 at 11:19:41AM +0000, Marc Zyngier wrote:
>> Hi Russell,
>>
>> On 01/12/14 11:03, Russell King - ARM Linux wrote:
>>> If all you want to do is to bypass the following check, what's wrong
>>> with actually doing that:
>>>
>>> -	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
>>> +	if (gicirq >= 32 && type != IRQ_TYPE_LEVEL_HIGH &&
>>> +	    type != IRQ_TYPE_EDGE_RISING)
>>> 		return -EINVAL;
>>>
>>
>> I think that will require some additional changes to gic_configure_irq
>> (in irq-gic-common.c).
> 
> I don't think so - gic_configure_irq() will treat it as a no-op as far
> as trying to configure the IRQ settings.

I agree. But that's following ARM's tradition of making PPIs
non-configurable. I seem to remember that there is at least one
occurrence of a GIC with configurable PPIs (Qualcomm, IIRC).

With this use case in mind, Liviu's patch allows an active-low interrupt
to be correctly configured as level, for example.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
