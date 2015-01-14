Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbbANNkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:40:45 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:30325 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbANNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:40:43 -0500
Message-ID: <54B671DA.7020009@atmel.com>
Date: Wed, 14 Jan 2015 14:40:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] ARM: at91/dt: add AIC irq1 muxed peripheral id
 definitions
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>	<1421174781-4340-5-git-send-email-boris.brezillon@free-electrons.com>	<54B66D6B.9050205@atmel.com> <20150114143448.09d362b8@bbrezillon>
In-Reply-To: <20150114143448.09d362b8@bbrezillon>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/01/2015 14:34, Boris Brezillon a écrit :
> On Wed, 14 Jan 2015 14:21:47 +0100
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> Le 13/01/2015 19:46, Boris Brezillon a écrit :
>>> These ids will be used to define irqs multiplexed on the first irq line.
>>>
>>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>> ---
>>>  .../dt-bindings/interrupt-controller/atmel-aic.h   | 22 ++++++++++++++++++++++
>>>  1 file changed, 22 insertions(+)
>>>  create mode 100644 include/dt-bindings/interrupt-controller/atmel-aic.h
>>>
>>> diff --git a/include/dt-bindings/interrupt-controller/atmel-aic.h b/include/dt-bindings/interrupt-controller/atmel-aic.h
>>> new file mode 100644
>>> index 0000000..e14a94f
>>> --- /dev/null
>>> +++ b/include/dt-bindings/interrupt-controller/atmel-aic.h
>>> @@ -0,0 +1,22 @@
>>> +#ifndef _DT_BINDINGS_INTERRUPT_CONTROLLER_ARM_GIC_H
>>> +#define _DT_BINDINGS_INTERRUPT_CONTROLLER_ARM_GIC_H
>>
>> Nit.: why ARM_GIC?
> 
> Because I copied it from the arm-gic.h header and forgot to rename
> those macros :-).
> I'll fix that.
> 
>>
>>> +#include <dt-bindings/interrupt-controller/irq.h>
>>> +
>>> +#define AIC_IRQ1_PMC		0
>>> +#define AIC_IRQ1_ST		1
>>> +#define AIC_IRQ1_PIT		1
>>> +#define AIC_IRQ1_DBGU		2
>>> +#define AIC_IRQ1_RTC		3
>>> +#define AIC_IRQ1_RTT		4
>>> +#define AIC_IRQ1_WATCHDOG	5
>>> +#define AIC_IRQ1_MC		6
>>> +#define AIC_IRQ1_SDRAMC		6
>>> +#define AIC_IRQ1_DDRSDRC	6
>>> +#define AIC_IRQ1_RSTC		7
>>> +#define AIC_IRQ1_PMERRLOC	8
>>> +#define AIC_IRQ1_PMECC		9
> 
> Following up the discussion we had privately regarding these
> macros (whether we really need them or not), maybe adding a comment
> above the irqs property would be enough:
> 
> 	dumb_irq1_demux: dumb-irq-demux@1 {
> 		compatible = "irqchip-dumb-demux";
> 		interrupt-controller;
> 		#interrupt-cells = <1>;
> 		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> 		/*
> 		 * Interrupt lines:
> 		 * 0: PMC
> 		 * 1: PIT
> 		 * 2: DBGU
> 		 * 3: RTT
> 		 * 4: WATCHDOG
> 		 * 5: RSTC
> 		 */
> 		irqs = <0x3f>;
> 	};

Well, I tend to prefer when no additional macros are defined in DT for
no real added value. So, this comment seems to be enough... I would vote
for this solution ;-)

Thanks, bye,
-- 
Nicolas Ferre
